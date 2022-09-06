//
//  CloudManager.swift
//  DuZi
//
//  Created by Nemo on 2022/9/2.
//

import Foundation

class NKCloudManager {
    static let shared = NKCloudManager()
    
    // MARK: Configuration Options
    // testingEnabled - Customize class behaviors for testing. See README.md
    lazy var testingEnabled: Bool = {
        let arguments = ProcessInfo.processInfo.arguments
        var enabled = false
        for index in 0..<arguments.count - 1 where arguments[index] == "-CDCKDTesting" {
            enabled = arguments.count >= (index + 1) ? arguments[index + 1] == "1" : false
            break
        }
        return enabled
    }()
    
    
    // allowCloudKitSync - Enable or disable CloudKit sync. See README.md
    lazy var allowCloudKitSync: Bool = {
        let arguments = ProcessInfo.processInfo.arguments
        var allow = true
        for index in 0..<arguments.count - 1 where arguments[index] == "-CDCKDAllowCloudKitSync" {
            allow = arguments.count >= (index + 1) ? arguments[index + 1] == "1" : true
            break
        }
        return allow
    }()
    
    
}
