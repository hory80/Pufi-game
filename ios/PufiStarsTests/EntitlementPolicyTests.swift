import XCTest
import Security
@testable import PufiStars

final class EntitlementPolicyTests: XCTestCase {
    private let cutoff = EntitlementPolicy.cutoff

    func testCutoffIsMidnightZurich() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try XCTUnwrap(TimeZone(identifier: "Europe/Zurich"))
        let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: cutoff)
        XCTAssertEqual(parts.year, 2026)
        XCTAssertEqual(parts.month, 12)
        XCTAssertEqual(parts.day, 15)
        XCTAssertEqual(parts.hour, 0)
        XCTAssertEqual(parts.minute, 0)
    }

    func testLaunchWindowIsFreeEvenWithoutStoreData() {
        XCTAssertTrue(unlocked(now: cutoff.addingTimeInterval(-1)))
        XCTAssertFalse(unlocked(now: cutoff))
        XCTAssertFalse(unlocked(now: cutoff.addingTimeInterval(1)))
    }

    func testEarlyOriginalDownloadKeepsAccessAfterCutoff() {
        XCTAssertTrue(unlocked(now: cutoff.addingTimeInterval(100_000), original: cutoff.addingTimeInterval(-1)))
        XCTAssertFalse(unlocked(now: cutoff.addingTimeInterval(1), original: cutoff))
        XCTAssertFalse(unlocked(now: cutoff.addingTimeInterval(100), original: cutoff.addingTimeInterval(1)))
    }

    func testNewUserWhoBoughtPremiumIsUnlocked() {
        XCTAssertTrue(unlocked(now: cutoff.addingTimeInterval(1), original: cutoff, premium: true))
        XCTAssertFalse(unlocked(now: cutoff.addingTimeInterval(1), original: cutoff, premium: false))
    }

    func testOfflineFallbacksWithoutOriginalTransaction() {
        let later = cutoff.addingTimeInterval(100_000)
        XCTAssertTrue(unlocked(now: later, grandfathered: true))
        XCTAssertTrue(unlocked(now: later, premium: true))
        XCTAssertFalse(unlocked(now: later))
        XCTAssertTrue(unlocked(now: cutoff.addingTimeInterval(-1)))
    }

    func testOnlyEarlyDatesQualifyForPermanentFlag() {
        XCTAssertFalse(EntitlementPolicy.qualifies(nil))
        XCTAssertFalse(EntitlementPolicy.qualifies(cutoff))
        XCTAssertTrue(EntitlementPolicy.qualifies(cutoff.addingTimeInterval(-0.001)))
    }

    func testKeychainFlagSurvivesNewStoreInstance() {
        let service = "com.horace.pufistars.tests." + UUID().uuidString
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service]
        defer { SecItemDelete(query as CFDictionary) }
        let first = GrandfatheredStore(service: service)
        XCTAssertFalse(first.isGrandfathered)
        XCTAssertTrue(first.save())
        XCTAssertTrue(first.save())
        XCTAssertTrue(GrandfatheredStore(service: service).isGrandfathered)
    }

    #if DEBUG
    func testDebugOverridesCoverAllFourScenarios() throws {
        let scenarios: [(String, String, String, Bool)] = [
            ("2026-12-14T22:59:59Z", "none", "false", true),
            ("2026-12-15T00:00:00Z", "2026-12-14T22:59:59Z", "false", true),
            ("2026-12-15T00:00:00Z", "none", "false", false),
            ("2026-12-15T00:00:00Z", "2026-12-15T00:00:00Z", "true", true)
        ]
        XCTAssertNil(EntitlementTestOverrides(arguments: []))
        for (now, original, premium, expected) in scenarios {
            let overrides = try XCTUnwrap(EntitlementTestOverrides(arguments: [
                "-PufiNow", now, "-PufiOriginalPurchase", original, "-PufiPremium", premium
            ]))
            XCTAssertEqual(overrides.isUnlocked, expected)
        }
    }
    #endif

    private func unlocked(now: Date, original: Date? = nil,
                          grandfathered: Bool = false, premium: Bool = false) -> Bool {
        EntitlementPolicy.isUnlocked(now: now, originalPurchaseDate: original,
                                     grandfathered: grandfathered, premium: premium)
    }
}
