//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation

public enum SwitchState {
    case on
    case off
}

public enum ElementState {
    case enabled(isEnabled: Bool)
    case visible(isVisible: Bool)
    case focused(isFocused: Bool)

    public var errorMessage: String {
        let state: String
        switch self {
        case let .enabled(isEnabled):
            state = isEnabled ? "enabled" : "disabled"
        case let .focused(isFocused):
            state = isFocused ? "in focus" : "out of focus"
        case let .visible(isVisible):
            state = isVisible ? "visible" : "hidden"
        }
        return "Element should be \(state)"
    }
}
