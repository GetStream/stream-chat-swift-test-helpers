//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

// MARK: Robot
public protocol Robot: AnyObject {}

public extension Robot {

    /// Set the state of a switch if it already isn't that state
    /// - Parameters:
    ///   - element: the switch to set
    ///   - state: The state to set it to
    /// - Returns: instance of `Robot`
    @discardableResult
    func setSwitchState(_ element: XCUIElement, state: SwitchState) -> Self {
        _ = element.waitForExistence(timeout: 3.0)
        switch state {
        case .off where element.isOn:
            element.tap()
        case .on where element.isOff:
            element.tap()
        default:
            return self
        }
        return self
    }

    /// Tap an element. Fails if it doesn't exist
    /// - Parameters:
    ///   - element: Element to tap
    ///   - file: The file in which the failure occurred. The default is the file name of the test case in which this function was called.
    ///   - line: The line number on which the failure occurred. The default is the line number on which this function was called.
    /// - Returns: instance of `Robot`
    @discardableResult
    func tap(_ element: XCUIElement, file: StaticString = #filePath, line: UInt = #line) -> Self {
        let existence = element.wait()
        XCTAssertTrue(existence, "Element \(element.label) doesn't exist", file: file, line: line)
        if element.isEnabled {
            element.tap()
        }
        return self
    }

    /// Tap an element using it's frame. Fails if it doesn't exist
    /// - Parameters:
    ///   - element: Element to tap
    ///   - file: The file in which the failure occurred. The default is the file name of the test case in which this function was called.
    ///   - line: The line number on which the failure occurred. The default is the line number on which this function was called.
    /// - Returns: instance of `Robot`
    @discardableResult
    func tapFrameCenter(_ element: XCUIElement, file: StaticString = #filePath, line: UInt = #line) -> Self {
        let existence = element.wait()
        XCTAssertTrue(existence, "Element \(element.label) doesn't exist", file: file, line: line)
        element.tapFrameCenter()
        return self
    }

    /// Tap an element only if it exists. No failure
    /// - Parameters:
    ///   - element: Element to tap
    ///   - file: The file in which the failure occurred. The default is the file name of the test case in which this function was called.
    ///   - line: The line number on which the failure occurred. The default is the line number on which this function was called.
    /// - Returns: instance of `Robot`
    @discardableResult
    func tapIfExists(_ element: XCUIElement, file: StaticString = #filePath, line: UInt = #line) -> Self {
        element.tapIfExists()
        return self
    }
}
