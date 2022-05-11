//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

public extension XCUIElement {

    static var waitTimeout: Double { 10.0 }

    func dragAndDrop(dropElement: XCUIElement, duration: Double = 2) {
        press(forDuration: duration, thenDragTo: dropElement)
    }

    func safeTap() {
        if !isHittable {
            let coordinate: XCUICoordinate =
                coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        } else { tap() }
    }

    func tapIfExists() {
        if waitForExistence(timeout: 1.0) {
            tap()
        }
    }

    func tapFrameCenter() {
        frameCenter.tap()
    }
}

// MARK: Wait
public extension XCUIElement {

    @discardableResult
    func waitForLoss(timeout: Double = waitTimeout) -> Self {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var elementPresent = exists
        while elementPresent && endTime > Date().timeIntervalSince1970 * 1000 {
            elementPresent = exists
        }
        return self
    }

    func waitForText(_ expectedText: String, timeout: Double = waitTimeout, mustBeEqual: Bool = true) -> Self {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var elementPresent = exists
        var textPresent = false
        while !textPresent && elementPresent && endTime > Date().timeIntervalSince1970 * 1000 {
            elementPresent = exists
            textPresent = mustBeEqual ? text == expectedText : text.contains(expectedText)
        }
        return self
    }

    @discardableResult
    func wait(timeout: Double = XCUIElement.waitTimeout) -> Self {
         _ = waitForExistence(timeout: timeout)
         return self
    }
}

// MARK: Dimensions
public extension XCUIElement {

    var centralCoordinates: CGPoint {
        CGPoint(x: frame.midX, y: frame.midY)
    }

    var height: Double {
        Double(frame.size.height)
    }

    var width: Double {
        Double(frame.size.width)
    }

    private var frameCenter: XCUICoordinate {
        let centerX = frame.midX
        let centerY = frame.midY

        let normalizedCoordinate = XCUIApplication().coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let frameCenterCoordinate = normalizedCoordinate.withOffset(CGVector(dx: centerX, dy: centerY))

        return frameCenterCoordinate
    }
}

// MARK: UI element State
/// Check if switch is enabled
public extension XCUIElement {
    var isOn: Bool {
        (self.value as? String) == "1"
    }

    var isOff: Bool {
        (self.value as? String) == "0"
    }
}

// MARK: Keyboard
public extension XCUIElement {

    var hasKeyboardFocus: Bool {
        (value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }

    @discardableResult
    func obtainKeyboardFocus() -> Self {
        let keyboard = XCUIApplication().keyboards.element
        wait()

        if hasKeyboardFocus == false {
            tap()
        }

        if keyboard.exists == false {
            keyboard.wait()
        }

        return self
    }

    var text: String {
        var labelText = label as String
        labelText = label.contains("AX error") ? "" : labelText
        let valueText = value as? String
        let text = labelText.isEmpty ? valueText : labelText
        return text ?? ""
    }

    /// Removes any current text in the field before typing in the new value
    /// - Parameter text: the text to enter into the field
    func clearAndEnterText(text: String) {
        clear()
        typeText(text)
    }

    func clear() {
        guard let oldValue = value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        tapIfExists()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: oldValue.count)
        typeText(deleteString)
    }
}
