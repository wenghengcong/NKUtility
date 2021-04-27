// UIApplicationExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(UIKit)
import UIKit

#if os(iOS) || os(tvOS)

public extension UIApplication {
    ///  Application running environment.
    ///
    /// - debug: Application is running in debug mode.
    /// - testFlight: Application is installed from Test Flight.
    /// - appStore: Application is installed from the App Store.
    enum Environment {
        ///  Application is running in debug mode.
        case debug
        ///  Application is installed from Test Flight.
        case testFlight
        ///  Application is installed from the App Store.
        case appStore
    }

    ///  Current inferred app environment.
    var inferredEnvironment: Environment {
        #if DEBUG
        return .debug

        #elseif targetEnvironment(simulator)
        return .debug

        #else
        if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
            return .testFlight
        }

        guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
            return .debug
        }

        if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
            return .testFlight
        }

        if appStoreReceiptUrl.path.lowercased().contains("simulator") {
            return .debug
        }

        return .appStore
        #endif
    }

    /// Application name (if applicable).
    var displayName: String? {
        return NKDevice.Application.displayName
    }

    ///  App current build number (if applicable).
    var buildNumber: String? {
        return NKDevice.Application.buildNumber
    }

    ///  App's current version number (if applicable).
    var version: String? {
        return NKDevice.Application.version
    }
    
    var bundleId: String? {
        return NKDevice.Application.bundleId
    }
}

#endif

#endif
