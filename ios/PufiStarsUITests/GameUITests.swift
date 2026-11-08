import XCTest

final class GameUITests: XCTestCase {
    @MainActor
    func testLayoutsGateAndRelaunch() throws {
        let app = XCUIApplication()
        app.launch()
        let web = app.webViews.firstMatch
        XCTAssertTrue(web.waitForExistence(timeout: 30))
        chooseEnglish(in: app)
        for orientation in [UIDeviceOrientation.portrait, .landscapeLeft] {
            XCUIDevice.shared.orientation = orientation
            let rotated = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
                orientation == .portrait ? app.frame.height > app.frame.width : app.frame.width > app.frame.height
            }, object: nil)
            XCTAssertEqual(XCTWaiter.wait(for: [rotated], timeout: 10), .completed)
            // Wait for the simulator display compositor after the app has rotated.
            Thread.sleep(forTimeInterval: 1)
            let card = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "⚙️")).firstMatch
            XCTAssertTrue(card.waitForExistence(timeout: 10))
            let shot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
            shot.name = orientation == .portrait ? "Portrait" : "Landscape"
            shot.lifetime = .keepAlways
            add(shot)
            for _ in 0..<5 {
                if card.isHittable { break }
                web.swipeUp()
            }
            XCTAssertTrue(card.isHittable)
        }
        let parents = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "⚙️")).firstMatch
        parents.tap()
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label IN %@", ["Anulează", "Abbrechen", "Cancel"])).firstMatch.waitForExistence(timeout: 10))
        XCTAssertFalse(app.staticTexts["🎙️ Parent’s voice"].exists)
        app.buttons.matching(NSPredicate(format: "label IN %@", ["Anulează", "Abbrechen", "Cancel"])).firstMatch.tap()
        app.terminate()
        app.launch()
        XCTAssertTrue(app.webViews.firstMatch.waitForExistence(timeout: 20))
        XCTAssertTrue(app.buttons["📖 Reading"].waitForExistence(timeout: 10))
    }
    @MainActor
    func testParentRecording() throws {
        XCUIDevice.shared.orientation = .portrait
        let app = XCUIApplication()
        app.launch()
        chooseEnglish(in: app)
        let parents = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Parents")).firstMatch
        XCTAssertTrue(parents.waitForExistence(timeout: 20))
        for _ in 0..<5 {
            if parents.isHittable { break }
            app.webViews.firstMatch.swipeUp()
        }
        parents.tap()
        let cancel = app.buttons.matching(NSPredicate(format: "label IN %@", ["Anulează", "Abbrechen", "Cancel"])).firstMatch
        XCTAssertTrue(cancel.waitForExistence(timeout: 10))
        let values = ["trei": 3, "patru": 4, "cinci": 5, "șase": 6, "șapte": 7, "opt": 8, "nouă": 9,
                      "drei": 3, "vier": 4, "fünf": 5, "sechs": 6, "sieben": 7, "acht": 8, "neun": 9,
                      "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9]
        let question = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '?' AND (label CONTAINS 'ori' OR label CONTAINS 'mal' OR label CONTAINS 'times')")).firstMatch.label
        let numbers = question.replacingOccurrences(of: "?", with: "").split(separator: " ").compactMap { values[String($0)] }
        guard numbers.count == 2 else { return XCTFail("Could not read gate question") }
        app.buttons[String(numbers[0] * numbers[1])].tap()
        let voice = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS[c] %@", "parent’s voice")).firstMatch
        XCTAssertTrue(voice.waitForExistence(timeout: 10))
        voice.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        let record = app.buttons["⏺ Record"]
        XCTAssertTrue(record.waitForExistence(timeout: 10))
        // A taller home page can leave the first recording row beneath the status bar.
        for _ in 0..<5 {
            if record.frame.minY > app.frame.minY + 100 { break }
            app.webViews.firstMatch.swipeDown()
        }
        XCTAssertTrue(record.isHittable)
        record.tap()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        if springboard.alerts.firstMatch.waitForExistence(timeout: 3) {
            XCTAssertTrue(springboard.staticTexts.matching(NSPredicate(format: "label == %@", "The microphone is used so your child can read stories out loud and so parents can record words of praise. Recordings stay on this device.")).firstMatch.exists)
            springboard.alerts.buttons["Allow"].tap()
        }
        let stop = app.buttons.matching(NSPredicate(format: "label IN %@", ["⏹ Gata", "⏹ Fertig", "⏹ Done"])).firstMatch
        XCTAssertTrue(stop.waitForExistence(timeout: 10))
        stop.tap()
        let play = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Play")).firstMatch
        let delete = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Delete")).firstMatch
        XCTAssertEqual(XCTWaiter.wait(for: [XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "enabled == true"), object: play
        )], timeout: 5), .completed)
        play.tap()
        delete.tap()
        XCTAssertEqual(XCTWaiter.wait(for: [XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "enabled == false"), object: play
        )], timeout: 5), .completed)
    }

    @MainActor
    func testReadAloudPermission() throws {
        XCUIDevice.shared.orientation = .portrait
        let app = XCUIApplication()
        app.launch()
        chooseEnglish(in: app)
        let reading = app.buttons["📖 Reading"]
        XCTAssertTrue(reading.waitForExistence(timeout: 20))
        reading.tap()
        let stories = app.buttons["📚 Stories"]
        XCTAssertTrue(stories.waitForExistence(timeout: 10))
        stories.tap()
        let story = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "🚂")).firstMatch
        XCTAssertTrue(story.waitForExistence(timeout: 10))
        story.tap()
        let mic = app.descendants(matching: .any).matching(NSPredicate(format: "label == %@", "🎤 I read aloud")).firstMatch
        XCTAssertTrue(mic.waitForExistence(timeout: 10))
        mic.tap()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        if springboard.alerts.firstMatch.waitForExistence(timeout: 5) {
            let explanation = springboard.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Speech recognition follows")).firstMatch
            XCTAssertTrue(explanation.label.replacingOccurrences(of: "’", with: "'").contains("Speech recognition follows your child's reading and colours each word that was read correctly."))
            springboard.alerts.buttons["Allow"].tap()
        }
        // A simulator cannot supply a child's live reading or prove recognition accuracy.
        let shot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        shot.name = "Read aloud after permission"
        shot.lifetime = .keepAlways
        add(shot)
    }

    @MainActor
    private func chooseEnglish(in app: XCUIApplication) {
        let language = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@", "▾")).firstMatch
        XCTAssertTrue(language.waitForExistence(timeout: 10))
        if !language.label.contains("English") {
            language.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
            let english = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "English")).firstMatch
            XCTAssertTrue(english.waitForExistence(timeout: 5))
            english.tap()
        }
    }

}
