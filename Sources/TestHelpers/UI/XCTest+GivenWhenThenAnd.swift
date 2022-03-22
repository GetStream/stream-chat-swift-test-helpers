//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest


public extension XCTest {

    func step(_ name: String, step: () -> Void) {
        XCTContext.runActivity(named: name) { _ in
            step()
        }
    }

    func GIVEN(_ name: String, actionStep: () -> Void) {
        step("GIVEN \(name)", step: actionStep)
    }

    func WHEN(_ name: String, actionStep: () -> Void) {
        step("WHEN \(name)", step: actionStep)
    }

    func THEN(_ name: String, actionStep: () -> Void) {
        step("THEN \(name)", step: actionStep)
    }

    func AND(_ name: String, actionStep: () -> Void) {
        step("AND \(name)", step: actionStep)
    }

}
