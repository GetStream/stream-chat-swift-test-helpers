//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

// MARK: XCUIApplication
public extension XCUIApplication {

    func waitForChangingState(from previousState: State, timeout: Double) -> Bool {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var isChanged = (previousState != state)
        while !isChanged && endTime > Date().timeIntervalSince1970 * 1000 {
            isChanged = (previousState != state)
        }
        return isChanged
    }

    func waitForLosingFocus(timeout: Double) -> Bool {
        sleep(UInt32(timeout))
        return !debugDescription.contains("subtree")
    }

    func saveToPasteboard(text: String) {
        UIPasteboard.general.string = text
    }

    func bundleId() -> String {
        Bundle.main.bundleIdentifier ?? ""
    }
}

// MARK: Gestures
public extension XCUIApplication {

    func tap(x: CGFloat, y: CGFloat) {
        let normalized = coordinate(
            withNormalizedOffset: CGVector(dx: 0, dy: 0)
        )
        let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
        coordinate.tap()
    }

    func doubleTap(x: CGFloat, y: CGFloat) {
        let normalized = coordinate(
            withNormalizedOffset: CGVector(dx: 0, dy: 0)
        )
        let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
        coordinate.doubleTap()
    }

    func back() {
        navigationBars.buttons.element(boundBy: 0).tapIfExists()
    }
}

// MARK: Device Orientation
public extension XCUIApplication {

    func landscape() {
        XCUIDevice.shared.orientation = .landscapeLeft
    }

    func portrait() {
        XCUIDevice.shared.orientation = .portrait
    }
}

// MARK: App States
public extension XCUIApplication {

    func rollUp() {
        XCUIDevice.shared.press(XCUIDevice.Button.home)
    }

    func rollUp(sec: Int, withDelay: Bool = false) {
        if withDelay { sleep(1) }
        rollUp()
        sleep(UInt32(sec))
        activate()
        if withDelay { sleep(1) }
    }

    func restart() {
        terminate()
        activate()
    }
}

// MARK: Centers
public extension XCUIApplication {
    func openNotificationCenter() {
        let up = coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.001))
        let down = coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.8))
        up.press(forDuration: 0.1, thenDragTo: down)
    }

    func openControlCenter() {
        let down = coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.999))
        let up = coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        down.press(forDuration: 0.1, thenDragTo: up)
    }
}
