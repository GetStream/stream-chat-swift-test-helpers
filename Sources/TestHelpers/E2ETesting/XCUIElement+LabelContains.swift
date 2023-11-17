//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import XCTest

public extension XCUIElement {
    /// Match substring in accessibility label
    func labelContains(text: String) -> Bool {
        staticTexts.element(contains: text).exists
    }
}

public extension XCUIElementQuery {
    /// - Parameter label: Label of the element
    /// - Returns: First match of the element that contains the label
    func element(contains label: String) -> XCUIElement {
        matching(.containsWithSpecialChars(label)).firstMatch
    }
}

// MARK: Predicate
public extension NSPredicate {
    static func beginsWith(_ text: String) -> NSPredicate {
        NSPredicate(format: "label BEGINSWITH '\(text)'")
    }

    static func like(_ text: String) -> NSPredicate {
        NSPredicate(format: "label LIKE '\(text)'")
    }

    static func containsWithSpecialChars(_ text: String) -> NSPredicate {
        NSPredicate(format: "label contains[c] '\(text)'")
    }
}
