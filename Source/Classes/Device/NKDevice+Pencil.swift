//
//  NKDevice+Pencil.swift
//  FireFly
//
//  Created by Hunt on 2020/11/22.
//

import Foundation

#if os(iOS)
// MARK: Apple Pencil
extension NKDevice {
    /**
     This option set describes the current Apple Pencils
     - firstGeneration:  1st Generation Apple Pencil
     - secondGeneration: 2nd Generation Apple Pencil
     */
    public struct ApplePencilSupport: OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static let firstGeneration = ApplePencilSupport(rawValue: 0x01)
        public static let secondGeneration = ApplePencilSupport(rawValue: 0x02)
    }
    
    /// All Apple Pencil Capable Devices
    public static var allApplePencilCapableDevices: [NKDevice] {
        return [.iPad6, .iPadAir3, .iPad7, .iPad8, .iPadAir4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    /// Returns supported version of the Apple Pencil
    public var applePencilSupport: ApplePencilSupport {
        switch self {
        case .iPad6: return .firstGeneration
        case .iPadAir3: return .firstGeneration
        case .iPad7: return .firstGeneration
        case .iPad8: return .firstGeneration
        case .iPadMini5: return .firstGeneration
        case .iPadPro9Inch: return .firstGeneration
        case .iPadPro12Inch: return .firstGeneration
        case .iPadPro12Inch2: return .firstGeneration
        case .iPadPro10Inch: return .firstGeneration
        case .iPadAir4: return .secondGeneration
        case .iPadPro11Inch: return .secondGeneration
        case .iPadPro12Inch3: return .secondGeneration
        case .iPadPro11Inch2: return .secondGeneration
        case .iPadPro12Inch4: return .secondGeneration
        case .simulator(let model): return model.applePencilSupport
        default: return []
        }
    }
}
#endif
