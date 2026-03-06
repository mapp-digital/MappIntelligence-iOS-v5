import XCTest

final class MappIntelligenceDemoAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunchShowsMainScreen() {
        let app = XCUIApplication()
        app.launch()
        dismissSystemPromptsIfNeeded()

        XCTAssertTrue(app.navigationBars["Mapp Intelligence demo"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Configuration"].exists)
        XCTAssertTrue(app.staticTexts["Page tracking"].exists)
        XCTAssertTrue(app.staticTexts["Action"].exists)
        XCTAssertTrue(app.staticTexts["Campaign"].exists)
        XCTAssertTrue(app.staticTexts["Ecommerce"].exists)
    }

    func testConfigurationScreenHasExpectedControls() {
        let app = XCUIApplication()
        app.launch()
        dismissSystemPromptsIfNeeded()

        app.staticTexts["Configuration"].tap()

        XCTAssertTrue(app.navigationBars["Configuration"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Opt out"].exists)
        XCTAssertTrue(app.buttons["Opt in"].exists)
        XCTAssertTrue(app.buttons["Reset"].exists)
        XCTAssertTrue(app.buttons["Init with everID"].exists)
        XCTAssertTrue(app.buttons["Init at Runtime"].exists)
        XCTAssertTrue(app.buttons["UserMatching set to true"].exists)
    }

    func testPageTrackingButtonsAreReachable() {
        let app = XCUIApplication()
        app.launch()
        dismissSystemPromptsIfNeeded()

        app.staticTexts["Page tracking"].tap()

        XCTAssertTrue(app.navigationBars["Page Tracking"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Track Page"].exists)
        XCTAssertTrue(app.buttons["Track Custom Page"].exists)
        XCTAssertTrue(app.buttons["Track Page with custom data"].exists)
    }

    private func dismissSystemPromptsIfNeeded() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let candidateButtons = [
            "Ask App Not to Track",
            "Don't Allow",
            "Allow",
            "OK"
        ]

        for title in candidateButtons {
            let button = springboard.buttons[title]
            if button.waitForExistence(timeout: 1) {
                button.tap()
                return
            }
        }
    }
}
