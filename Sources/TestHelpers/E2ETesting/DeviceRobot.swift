//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import XCTest

/// Simulates device behavior
public class DeviceRobot: Robot {
    
    private var app: XCUIApplication

    public init(_ app: XCUIApplication) {
        self.app = app
    }

    public enum Orientation {
        case portrait, landscape
    }

    public enum ApplicationState {
        case foreground, background
    }

    @discardableResult
    public func rotateDevice(_ orientation: Orientation) -> Self {
        switch orientation {
        case .portrait:
            app.portrait()
        case .landscape:
            app.landscape()
        }
        return self
    }

    @discardableResult
    public func moveApplication(to state: ApplicationState) -> Self {
        switch state {
        case .background:
            XCUIDevice.shared.press(XCUIDevice.Button.home)
        case .foreground:
            app.activate()
        }
        return self
    }
}
