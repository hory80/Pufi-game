import XCTest
import StoreKit
import StoreKitTest
@testable import PufiStars

@MainActor
final class PurchaseServiceTests: XCTestCase {
    private var session: SKTestSession!
    private var service: PurchaseService!

    override func setUpWithError() throws {
        let url = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "Pufi", withExtension: "storekit"))
        session = try SKTestSession(contentsOf: url)
        session.resetToDefaultState()
        session.disableDialogs = true
        session.clearTransactions()
        service = PurchaseService(arguments: ["-PufiStoreKitTest"])
        service.configure()
    }

    override func tearDownWithError() throws {
        session.clearTransactions()
        service = nil
        session = nil
    }

    private func refresh() async -> Bool {
        await withCheckedContinuation { continuation in
            service.refresh { continuation.resume(returning: $0) }
        }
    }

    private func buy() async -> Bool {
        await withCheckedContinuation { continuation in
            service.buy { continuation.resume(returning: $0) }
        }
    }


    private func waitForAccess(_ expected: Bool) async -> Bool {
        for _ in 0..<50 {
            let value = await refresh()
            if value == expected { return value }
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
        return service.isPremium
    }

    func testLocalizedPricePurchaseAndRestoreInNewService() async throws {
        let price: String? = await withCheckedContinuation { continuation in
            service.price { continuation.resume(returning: $0) }
        }
        XCTAssertEqual(price, "$3.00")
        let before = await refresh()
        XCTAssertFalse(before)
        let bought = await buy()
        XCTAssertTrue(bought)
        XCTAssertEqual(session.allTransactions().filter { $0.productIdentifier == "unlock_all" }.count, 1)

        // Un serviciu nou trebuie să citească achiziția Apple, fără un flag UserDefaults.
        service = PurchaseService(arguments: ["-PufiStoreKitTest"])
        service.configure()
        let restored: Bool = await withCheckedContinuation { continuation in
            service.restore { continuation.resume(returning: $0) }
        }
        XCTAssertTrue(restored)
    }

    func testRefundRemovesPurchasedAccess() async throws {
        let transaction = try await session.buyProduct(identifier: "unlock_all")
        let owned = await waitForAccess(true)
        XCTAssertTrue(owned)
        try session.refundTransaction(identifier: UInt(transaction.id))
        let afterRefund = await waitForAccess(false)
        XCTAssertFalse(afterRefund)
    }

    func testCancelledPurchaseDoesNotUnlock() async throws {
        try await session.setSimulatedError(.generic(.userCancelled), forAPI: StoreKitPurchaseAPI())
        let bought = await buy()
        XCTAssertFalse(bought)
        let owned = await refresh()
        XCTAssertFalse(owned)
    }

    func testPendingPurchaseOnlyUnlocksAfterApproval() async throws {
        session.askToBuyEnabled = true
        let bought = await buy()
        XCTAssertFalse(bought)
        let pending = await refresh()
        XCTAssertFalse(pending)
        let transaction = try XCTUnwrap(session.allTransactions().first)
        try session.approveAskToBuyTransaction(identifier: transaction.identifier)
        let approved = await waitForAccess(true)
        XCTAssertTrue(approved)
    }
}
