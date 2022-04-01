//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

public extension Robot {

    /// Assert that an element is in a specific state, `enabled`, `focused` or `visible`
    /// - Parameters:
    ///   - element: the element to assert on
    ///   - state: the type of state to check
    /// - Returns: Self for command chaining
    @discardableResult
    func assertElement(_ element: XCUIElement,
                       state: ElementState,
                       file: StaticString = #filePath,
                       line: UInt = #line) -> Self {
        element.wait(timeout: 1.5)

        let expected: Bool
        let actual: Bool
        switch state {
        case .enabled(let isEnabled):
            expected = isEnabled
            actual = element.isEnabled
        case .focused(let isFocused):
            expected = isFocused
            actual = element.hasKeyboardFocus

        case .visible(let isVisible):
            expected = isVisible
            actual = element.exists
        }
        XCTAssertEqual(expected, actual, state.errorMessage, file: file, line: line)
        return self
    }

    /// Check the state of an element
    ///
    /// - Parameters:
    ///     - XCUIElement: the element that has to be verified
    ///     - ElementState: the state in which the element should be presented
    ///     - timeout: the timeout that has to be used to wait for an element to appear
    /// - Returns: Self
    @discardableResult
    func assertElement(
        _ element: XCUIElement,
        state: ElementState,
        timeout: Double = XCUIElement.waitTimeout,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        element.wait(timeout: timeout)
        let expected: Bool
        let actual: Bool
        switch state {
        case .enabled(let isEnabled):
            expected = isEnabled
            actual = element.isEnabled
        case .focused(let isFocused):
            expected = isFocused
            actual = element.hasKeyboardFocus
        case .visible(let isVisible):
            expected = isVisible
            actual = element.exists
        }
        XCTAssertEqual(expected, actual, state.errorMessage, file: file, line: line)
        return self
    }

    /// Check the availability and visibility of an element
    ///
    /// - Parameters:
    ///     - element: the element that has to be verified
    ///     - isEnabled: an expected availability of the element
    ///     - isVisible: an expected visibility of the element
    /// - Returns: Self
    @discardableResult
    private func assertElement(
        _ element: XCUIElement,
        isEnabled: Bool,
        isVisible: Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        if isEnabled || isVisible {
            let visible = isVisible == element.isHittable
            let enabled = isEnabled == element.isEnabled
            XCTAssertTrue(visible && enabled, file: file, line: line)
        } else {
            XCTAssertFalse(element.exists, file: file, line: line)
        }
        return self
    }

    /// Check if the given element has expected accessibility identifier
    ///
    /// - Parameters:
    ///     - element: the element that has to be verified
    ///     - hasIdentifier: an expected accessibility identifier
    /// - Returns: Self
    @discardableResult
    func assertElement(_ element: XCUIElement,
                       hasIdentifier identifier: String,
                       file: StaticString = #filePath,
                       line: UInt = #line) -> Self {
        XCTAssertEqual(element.identifier, identifier)
        return self
    }

    /// Check the size of an element
    ///
    /// - Parameters:
    ///     - element: the element that has to be verified
    ///     - hasSize: an expected size of the element
    /// - Returns: Self
    @discardableResult
    private func assertElement(
        _ element: XCUIElement,
        hasSize size: CGSize,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        XCTAssertEqual(element.frame.size, size)
        return self
    }

    @discardableResult
    func assertQuery(_ query: XCUIElementQuery,
                     count: Int,
                     file: StaticString = #filePath,
                     line: UInt = #line) -> Self {
        let actualCount = query.waitCount(count, timeout: 5).count
        let errorMessage = "Expected: \(count) messages, received: \(actualCount)"
        XCTAssertEqual(actualCount, count, errorMessage, file: file, line: line)
        return self
    }

    func findMatch(for identifier: String,
                   in query: XCUIElementQuery,
                   waitTimeout timeout: TimeInterval = 3.0) -> Bool {
        query.matching(identifier: identifier).firstMatch.waitForExistence(timeout: timeout)
    }
}
