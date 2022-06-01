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
        _ = element.wait()
        switch state {
        case .off where element.isOn:
            element.safeTap()
        case .on where element.isOff:
            element.safeTap()
        default:
            return self
        }
        return self
    }
    
}
