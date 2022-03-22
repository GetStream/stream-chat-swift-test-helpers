//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import XCTest

// MARK: Permission
public enum Permission {

    /// Alert resolution options
    public enum Resolution {
        case accept
        case decline
    }

    /// Different permission `Resource`s
    public enum Resource {
        case camera
        case photos
        case microphone
        case localNotifications

        fileprivate var description: String {
            switch self {
            case .camera:
                return "Handle Camera Alert"
            case .photos:
                return "Accept Photos Alert"
            case .microphone:
                return "Microphone Access"
            case .localNotifications:
                return "Local Notifications"
            }
        }

        fileprivate var expectedTitle: String {
            switch self {
            case .camera:
                return "Would Like to Access the Camera"
            case .photos:
                return "Would Like to Access Your Photos"
            case .microphone:
                return "Would Like to Access the Microphone"
            case .localNotifications:
                return "Would Like to Send You Notifications"
            }
        }

        fileprivate func label(for resolution: Resolution) -> String {
            switch resolution {
            case .accept:
                switch self {
                case .camera, .microphone:
                    return "OK"
                case .photos:
                    guard #available(iOS 14, *) else { return "OK" }
                    return "Allow Access to All Photos"
                case .localNotifications:
                    return "Allow"
                }
            case .decline:
                return "Don’t Allow"
            }
        }

        @available(iOS 13.4, *)
        var resource: XCUIProtectedResource? {
            switch self {
            case .camera:
                return .camera
            case .photos:
                return .photos
            case .microphone:
                return .microphone
            default:
                return .none
            }
        }
    }

}

// MARK: XCUIApplication
public extension XCUIApplication {
    /// Springboard app that owns the `UIInterruption`s
    static var springboard: XCUIApplication { XCUIApplication(bundleIdentifier: "com.apple.springboard") }

    /// Handle a `UIInteruption` that was sent by the system
    /// - Parameters:
    ///   - resource: Resource to send
    ///   - resolution: Resolution type to accept or decline the requested permission
    /// - Returns: `Bool` signalling if the alert was handled correctly
    @discardableResult
    func handleExternalUIInterruption(for resource: Permission.Resource,
                                      resolution: Permission.Resolution) -> Bool {
        let alert = XCUIApplication.springboard.alerts.element(contains: resource.expectedTitle)
        guard alert.exists else { return false }

        let label = resource.label(for: resolution)
        alert.buttons[label].tap()
        return true
    }

    @available(iOS 13.4, *)
    func resetAuthorizationStatus(resource: Permission.Resource) {
        guard let protectedResource = resource.resource else { return }
        self.resetAuthorizationStatus(for: protectedResource)
    }
}

// MARK: XCTestCase
public extension XCTestCase {

    @available(*, deprecated, renamed: "Permission.Resolution")
    enum AlertOption {
        case accept
        case decline

        /// Don't want to introduce a breaking API change
        fileprivate var resolution: Permission.Resolution {
            switch self {
            case .accept:
                return .accept
            case .decline:
                return .decline
            }
        }
    }

    /// Add `UIInterruptionMonitior` for an alert for a specific media type, and handle it based on the resolution type
    ///
    /// - Note:If you are developing on Xcode 12, permission alerts may not be caught by the `addUIInteruptionMonitor` handler.
    /// Use `handleExternalUIInterruption(for:resolution:)` on the instance of your `XCUIApplication` instead.
    /// Cal this API as the alerts appear, not on test setup.
    /// - Parameters:
    ///   - resource: `MediaType` of the interruption
    ///   - resolution: How to handle the interruption
    ///   - app: The app where the interruption is shown on top off
    func handlePermissionAlert(for resource: Permission.Resource,
                               resolution: Permission.Resolution,
                               for app: XCUIApplication) {
        addUIInterruptionMonitor(withDescription: resource.description) { [weak self] (alert) -> Bool in
            self?.alertHandler(app: app, alert: alert, resource: resource, resolution: resolution) ?? false
        }
    }
    
    @available(*, deprecated, message: """
    Permission related alerts no longer fire addUIInterruptionMonitor handlers.
    Handle permissions as they appear, using handleExternalUIInterruption(for:resolution:) on your instance of XCUIApplication
    """, renamed: "handleExternalUIInterruption(for:resolution:)")
    func handleCameraPermissionAlert(_ resolution: AlertOption, for app: XCUIApplication) {
        handlePermissionAlert(for: .camera, resolution: resolution.resolution, for: app)
    }

    @available(*, deprecated, message: """
    Permission related alerts no longer fire addUIInterruptionMonitor handlers.
    Handle permissions as they appear, using handleExternalUIInterruption(for:resolution:) on your instance of XCUIApplication
    """, renamed: "handleExternalUIInterruption(for:resolution:)")
    func handlePhotosPermissionAlert(_ resolution: AlertOption, for app: XCUIApplication) {
        handlePermissionAlert(for: .photos, resolution: resolution.resolution, for: app)
    }

    /// Alert Handler
    /// - Parameters:
    ///   - app: XCUIApplication instance that triggered the alert
    ///   - alert: XCUIElement that is causing the UI interruption
    ///   - resource: The media type associated with the alert
    ///   - resolution: Accept or decline the alert
    /// - Returns: `Bool` value signalling if the interuption was handled successfully
    private func alertHandler(app: XCUIApplication,
                              alert: XCUIElement,
                              resource: Permission.Resource,
                              resolution: Permission.Resolution) -> Bool {
        /// Hi, I'm a UI Interruption handler and i need a nap BEFORE handling an alert.
        /// Removing this will introduce flakiness to alert handling, do it at your own risk.
        sleep(2)

        guard alert.exists else {
            return false
        }
        guard alert.labelContains(text: resource.expectedTitle) else {
            return false
        }

        let label = resource.label(for: resolution)
        alert.buttons[label].tap()

        /// Hi, I'm a UI Interruption handler and i need a nap AFTER handling an alert.
        /// Removing this will introduce flakiness to alert handling, do it at your own risk.
        sleep(2)
        app.activate()
        return true
    }
}
