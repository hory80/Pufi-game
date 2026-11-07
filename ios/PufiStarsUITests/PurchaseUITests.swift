import XCTest
import UIKit
import StoreKitTest

final class PurchaseUITests: XCTestCase {
    private var session: SKTestSession!

    override func setUpWithError() throws {
        continueAfterFailure = false
        let url = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "Pufi", withExtension: "storekit"))
        session = try SKTestSession(contentsOf: url)
        session.resetToDefaultState()
        session.disableDialogs = false
        session.clearTransactions()
    }

    @MainActor
    func testParentGateAndIAPReviewScreenshot() throws {
        XCUIDevice.shared.orientation = .portrait
        let app = XCUIApplication()
        app.launchArguments = ["-PufiStoreKitTest", "-PufiNow", "2026-12-15T00:00:00Z", "-PufiOriginalPurchase", "none"]
        app.launch()
        if app.frame.width > 600 {
            XCUIDevice.shared.orientation = .landscapeLeft
            let landscape = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
                app.frame.width > app.frame.height
            }, object: nil)
            XCTAssertEqual(XCTWaiter.wait(for: [landscape], timeout: 10), .completed)
        }
        let language = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@", "▾")).firstMatch
        XCTAssertTrue(language.waitForExistence(timeout: 30))
        if !language.label.contains("English") {
            let english = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "English")).firstMatch
            for _ in 0..<3 {
                language.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
                if english.waitForExistence(timeout: 3) { break }
            }
            XCTAssertTrue(english.exists)
            english.tap()
        }
        let parents = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Parents")).firstMatch
        XCTAssertTrue(parents.waitForExistence(timeout: 10))
        for _ in 0..<8 {
            if parents.isHittable { break }
            app.webViews.firstMatch.swipeUp()
        }
        parents.tap()
        XCTAssertTrue(app.buttons["Cancel"].waitForExistence(timeout: 10))
        let question = app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "times")).firstMatch.label
        let values = ["three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9]
        let numbers = question.replacingOccurrences(of: "?", with: "").split(separator: " ").compactMap { values[String($0)] }
        XCTAssertEqual(numbers.count, 2)
        guard numbers.count == 2 else { return }
        app.buttons[String(numbers[0] * numbers[1])].tap()
        let unlock = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Unlock everything")).firstMatch
        XCTAssertTrue(unlock.waitForExistence(timeout: 20))
        XCTAssertTrue(unlock.label.contains("3.00"), unlock.label)
        XCTAssertTrue(app.buttons["Restore purchases"].exists)
        XCTAssertTrue(unlock.isHittable)
        XCTAssertTrue(app.buttons["Restore purchases"].isHittable)
        XCTAssertTrue(app.buttons["✖ Close"].isHittable)
        XCTAssertFalse(app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Record")).firstMatch.exists)
        let screenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        screenshot.name = "Pufi-IAP-Review-English"
        screenshot.lifetime = .keepAlways
        add(screenshot)
        app.buttons["✖ Close"].tap()
        XCTAssertFalse(unlock.exists)
        app.terminate()
        XCTAssertEqual(session.allTransactions().count, 0)
    }
}
