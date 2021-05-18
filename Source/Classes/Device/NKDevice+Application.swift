//
//  NKDevice+Application.swift
//  NKDevice
//
//  Created by Andrea Mario Lufino on 10/11/2019.
//

import Foundation
import UIKit

extension NKDevice {
    
    // MARK: Application
    
    /// Application information.
    public struct Application {
        /// The current app version.
        public static var version: String? {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }
        
        /// The build number.
        public static var buildNumber: String? {
            return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        }
        
        ///  Application name (if applicable).
        public static  var displayName: String? {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        }
        
        /// bundle name
        public static  var bundleName: String? {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        }
                
        /// The complete app version with build number (i.e. : "2.1.3 (343)").
        public static var completeAppVersion: String {
            return "\(Application.version) (\(Application.buildNumber))"
        }
        
        /// The current content of the clipboard (only string).
        public static var clipboardString: String? {
            return UIPasteboard.general.string
        }
        
        
        /// App bundle identifier in Info.plist(i.e. : com.---.---
        public static var bundleId: String? {
            return Bundle.main.infoDictionary!["CFBundleIdentifier"] as? String
        }

    }
    
    ///  - UUID
    /// uuid
    /// - Returns: Each time the same will be generated
    public static func uuid() -> String {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        }
        return uuidRandom()
    }
    
    /// uuid
    /// - Returns: Each time a new one will be generated
    public static func uuidRandom() -> String {
        return UUID().uuidString
    }
}
