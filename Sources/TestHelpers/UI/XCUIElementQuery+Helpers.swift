//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

// MARK: XCUIElementQuery

public extension XCUIElementQuery {

    var lastMatch: XCUIElement? {
        allElementsBoundByIndex.last
    }

    /// Looks for query with identifier that contains a piece of text
    /// - Parameters:
    ///   - identifier: element identifer
    ///   - text: text to query for
    /// - Returns: XCUIElement if it exists
    func match(identifier: String, with text: String) -> XCUIElement {
        let element = matching(identifier: identifier, with: .containsWithSpecialChars(text))
        element.wait()
        return element
    }

    /// Chained identifier and predicate calls returning the first match
    /// - Parameters:
    ///   - identifier: Element identifer
    ///   - predicate: Predicate to satisfy
    /// - Returns: The first `XCUIElement` with matching identifier that satisfies the predicate
    func matching(identifier: String, with predicate: NSPredicate) -> XCUIElement {
        matching(identifier: identifier)
            .matching(predicate)
            .firstMatch
    }

    @discardableResult
    func waitCount(_ expectedCount: Int, timeout: Double = XCUIElement.waitTimeout) -> Self {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var actualCount = count
        while actualCount < expectedCount && endTime > Date().timeIntervalSince1970 * 1000 {
            actualCount = count
        }
        return self
    }
}
