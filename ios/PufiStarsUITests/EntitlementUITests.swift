import XCTest

final class EntitlementUITests: XCTestCase {
    override func setUpWithError() throws { continueAfterFailure = false }

    @MainActor
    func testBeforeCutoffIsUnlocked() {
        assertUnlocked(now: "2026-12-14T22:59:59Z", original: "none")
    }

    @MainActor
    func testEarlyUserAfterCutoffIsUnlocked() {
        assertUnlocked(now: "2026-12-15T00:00:00Z", original: "2026-12-14T22:59:59Z")
    }

    @MainActor
    func testNewPaidUserAfterCutoffIsUnlocked() {
        assertUnlocked(now: "2026-12-15T00:00:00Z", original: "none", premium: true)
    }

    @MainActor
    func testNewUserAfterCutoffHasLockedNeighborsAndParentalPaywall() {
        let app = launch(now: "2026-12-15T00:00:00Z", original: "none")
        let neighbors = openNumberWorld(in: app)
        let locked = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label CONTAINS %@", "🔒"), object: neighbors)
        XCTAssertEqual(XCTWaiter.wait(for: [locked], timeout: 10), .completed)
        let shot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        shot.name = "New user after cutoff — locked neighbors"
        shot.lifetime = .keepAlways
        add(shot)
        neighbors.tap()
        XCTAssertTrue(app.staticTexts["Jocul acesta e în versiunea completă."].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons.matching(NSPredicate(format: "label CONTAINS %@ OR label == %@", "Deblochează tot", "Unlock")).firstMatch.exists)
        app.buttons["👨‍👩‍👧 Pentru părinți"].tap()
        XCTAssertTrue(app.buttons["Anulează"].waitForExistence(timeout: 10))
        let question = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '?' AND label CONTAINS 'ori'")).firstMatch.label
        let values = ["trei": 3, "patru": 4, "cinci": 5, "șase": 6, "șapte": 7, "opt": 8, "nouă": 9]
        let numbers = question.replacingOccurrences(of: "?", with: "").split(separator: " ").compactMap { values[String($0)] }
        guard numbers.count == 2 else { return XCTFail("Could not read parental gate") }
        app.buttons[String(numbers[0] * numbers[1])].tap()
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS %@ OR label == %@", "Deblochează tot", "Unlock")).firstMatch.waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label IN %@", ["Restaurează cumpărăturile", "Restore"])).firstMatch.exists)
    }

    @MainActor
    private func assertUnlocked(now: String, original: String, premium: Bool = false) {
        let app = launch(now: now, original: original, premium: premium)
        let neighbors = openNumberWorld(in: app)
        XCTAssertFalse(neighbors.label.contains("🔒"))
        neighbors.tap()
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Vecinul din dreapta")).firstMatch.waitForExistence(timeout: 10))
        XCTAssertFalse(app.staticTexts["Jocul acesta e în versiunea completă."].exists)
    }

    @MainActor
    private func launch(now: String, original: String, premium: Bool = false) -> XCUIApplication {
        XCUIDevice.shared.orientation = .portrait
        let app = XCUIApplication()
        app.launchArguments = ["-PufiNow", now, "-PufiOriginalPurchase", original, "-PufiPremium", String(premium)]
        app.launch()
        let language = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@", "▾")).firstMatch
        XCTAssertTrue(language.waitForExistence(timeout: 20))
        if !language.label.contains("Română") {
            language.tap()
            app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Română")).firstMatch.tap()
        }
        return app
    }

    @MainActor
    private func openNumberWorld(in app: XCUIApplication) -> XCUIElement {
        let math = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Matematică")).firstMatch
        XCTAssertTrue(math.waitForExistence(timeout: 10))
        math.tap()
        let neighbors = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Strada vecinilor")).firstMatch
        XCTAssertTrue(neighbors.waitForExistence(timeout: 10))
        for _ in 0..<4 {
            if neighbors.isHittable { break }
            app.webViews.firstMatch.swipeUp()
        }
        return neighbors
    }
}
