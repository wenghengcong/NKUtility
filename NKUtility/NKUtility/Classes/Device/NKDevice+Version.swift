//
//  NKDevice+Version.swift
//  FireFly
//
//  Created by Hunt on 2020/11/24.
//

import Foundation
import UIKit

extension NKDevice {
    
    /// This structure represents the system version. It's useful in case there's the need to
    /// split up the OS version for specific purposes.
    public struct SysVersion: Equatable, Comparable {
        
        /// The major version. Ex: "10.1.2" will return 10.
        private(set) var major: Int
        /// The minor version. Ex: "10.1.2" will return 1.
        private(set) var minor: Int
        /// The patch version. Ex: "10.1.2" will return 2.
        private(set) var patch: Int
        /// The value of the version as string.
        private(set) var stringValue: String
        
        /// The current version of the operating system (e.g. 8.4 or 9.2).
        public static var current: String {
            #if os(watchOS)
            return WKInterfaceDevice.current().systemVersion
            #else
            return UIDevice.current.systemVersion
            #endif
        }

        ///   - Operating system version
        public static var systemFloatVersion: Float {
            let f_version = Float(current) ?? 1.0
            return f_version
        }
        
        public static func isEqual(to version: String) -> Bool {
            return current == version
        }

        public static func isEqualOrLater(to version: String) -> Bool {
            return current >= version
        }
        
        public static func isLater(to version: String) -> Bool {
            return current > version
        }
        
        public static func isEarlier(to version: String) -> Bool {
            return current < version
        }

        public static func isEqualOrEarlier(to version: String) -> Bool {
            return current <= version
        }
        

    
        init() {
            major = 0
            minor = 0
            patch = 0
            stringValue = "\(major).\(minor).\(patch)"
        }
        
        /// Init with a string version.
        /// This will fail if the version is not formatted in the correct way, with at least a dot inside it.
        /// - Parameter version: The version used to init the structure.
        init(withVersion version: String) {
            
            guard version.contains(".") else {
                fatalError("version is not in the correct format")
            }
            
            stringValue = version
            
            let components = version.components(separatedBy: ".")
            
            major = Int(components.first!)!
            minor = Int(components.first!)!
            patch = Int(components.first!)!
        }
        
        public static func ==(lhs: SysVersion, rhs: SysVersion) -> Bool {
            return lhs.stringValue == rhs.stringValue
        }
        
        public static func > (lhs: SysVersion, rhs: SysVersion) -> Bool {
            let lValue = "\(lhs.major)\(lhs.minor)\(lhs.patch)"
            let rValue = "\(rhs.major)\(rhs.minor)\(rhs.patch)"
            return Double(lValue)! > Double(rValue)!
        }
        
        public static func < (lhs: SysVersion, rhs: SysVersion) -> Bool {
            let lValue = "\(lhs.major)\(lhs.minor)\(lhs.patch)"
            let rValue = "\(rhs.major)\(rhs.minor)\(rhs.patch)"
            return Double(lValue)! < Double(rValue)!
        }
    }
}

// MARK: - Version comparison

extension String {
    
    // Modified from the DragonCherry extension - https://github.com/DragonCherry/VersionCompare
    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        var result: ComparisonResult = .orderedSame
        var versionComponents = components(separatedBy: versionDelimiter)
        var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
        let spareCount = versionComponents.count - targetComponents.count
        
        if spareCount == 0 {
            result = compare(targetVersion, options: .numeric)
        } else {
            let spareZeros = repeatElement("0", count: abs(spareCount))
            if spareCount > 0 {
                targetComponents.append(contentsOf: spareZeros)
            } else {
                versionComponents.append(contentsOf: spareZeros)
            }
            result = versionComponents.joined(separator: versionDelimiter)
                .compare(targetComponents.joined(separator: versionDelimiter), options: .numeric)
        }
        return result
    }

    func isVersion(equalTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedSame }

    func isVersion(greaterThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedDescending }

    func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedAscending }

    func isVersion(lessThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedAscending }

    func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedDescending }

    static func ==(lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) == .orderedSame }

    static func <(lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) == .orderedAscending }

    static func <=(lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) != .orderedDescending }

    static func >(lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) == .orderedDescending }

    static func >=(lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) != .orderedAscending }

}
