import XCTest

class JGProgressHUD_TestsUITests_Swift: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {

    }

    func testExample() {
        let app = XCUIApplication()
        app.launch()

        var completed = false
        while (!completed) {
            let hud = app.otherElements.matching(identifier: "HUD")
            let textLabel = hud.descendants(matching: .any).matching(identifier: "HUD_textLabel").firstMatch
            let detailTextLabel = hud.descendants(matching: .any).matching(identifier: "HUD_detailTextLabel").firstMatch
            let indicatorView = hud.descendants(matching: .any).matching(identifier: "HUD_indicatorView").firstMatch

            print("HUD Text Label: ", textLabel.exists ? textLabel.label : "-")
            print("HUD Detail Text Label: ", detailTextLabel.exists ? detailTextLabel.label : "-")
            print("HUD Indicator View: ", indicatorView.exists ? indicatorView.label : "-")

            completed = textLabel.label == "Simple example in Swift" && detailTextLabel.label == "See JGProgressHUD-Tests for more examples"
        }
    }
}
