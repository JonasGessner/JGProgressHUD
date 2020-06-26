import XCTest

class JGProgressHUD_TestsUITests_Swift: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {

    }

    func testDemo() {
        XCTAssert(app.waitHud(textLabel: "Downloading"))
        XCTAssert(app.waitHud(textLabel: "Downloading", detailTextLabel: "100% Complete"))
        XCTAssert(app.waitHud(textLabel: "Success"))
        XCTAssert(app.waitHud(textLabel: "Loading"))
        XCTAssert(app.waitHud(textLabel: "Done"))

        #if os(tvOS)
            XCTAssert(app.waitHud(textLabel: "Simple example on tvOS in Swift", detailTextLabel: "See JGProgressHUD-Tests for more examples"))
        #else
            XCTAssert(app.waitHud(textLabel: "Simple example in Swift", detailTextLabel: "See JGProgressHUD-Tests for more examples"))
        #endif
    }
}

extension XCUIApplication {

    var huds: XCUIElementQuery {
        return self.otherElements.matching(identifier: "HUD")
    }

    var hudTextLabel: String? {
        return hudElement(identifier: "HUD_textLabel")
    }

    var hudTextDetailLabel: String? {
        return hudElement(identifier: "HUD_detailTextLabel")
    }

    func hudElement(identifier: String) -> String? {
        let hud = huds.firstMatch
        let descendants = hud.descendants(matching: .any)
        let query = descendants.matching(identifier: identifier)
        guard query.count > 0 else {
            return nil
        }

        let label = query.firstMatch.label
        print("\(identifier): \(label)")
        return label
    }

    func waitHud(textLabel: String, detailTextLabel: String, timeout: TimeInterval = 10) -> Bool {
        waitHud { text, detail -> Bool in
            return (text?.contains(textLabel) ?? false) && (detail?.contains(detailTextLabel) ?? false)
        }
    }

    func waitHud(detailTextLabel: String, timeout: TimeInterval = 10) -> Bool {
        waitHud { _, detail -> Bool in
            return detail?.contains(detailTextLabel) ?? false
        }
    }

    func waitHud(textLabel: String, timeout: TimeInterval = 10) -> Bool {
        waitHud { text, _ -> Bool in
            return text?.contains(textLabel) ?? false
        }
    }

    func waitHud(timeout: TimeInterval = 10, when:((String?, String?) -> Bool)) -> Bool {
        var completed = false
        let stop = Date(timeIntervalSinceNow: timeout)

        while !completed {
            completed = when(hudTextLabel, hudTextDetailLabel)
            if Date() > stop {
                return false
            }
        }
        return true
    }
}
