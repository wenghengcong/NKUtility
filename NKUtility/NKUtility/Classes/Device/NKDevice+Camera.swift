//
//  NKDevice+Camera.swift
//  FireFly
//
//  Created by Hunt on 2020/11/22.
//

import Foundation

#if os(iOS)
// MARK: Cameras
extension NKDevice {
    
    public enum CameraType {
        case wide
        case telephoto
        case ultraWide
    }
    
    /// Returns an array of the types of cameras the device has
    public var cameras: [CameraType] {
        switch self {
        case .iPodTouch5: return [.wide]
        case .iPodTouch6: return [.wide]
        case .iPodTouch7: return [.wide]
        case .iPhone4: return [.wide]
        case .iPhone4s: return [.wide]
        case .iPhone5: return [.wide]
        case .iPhone5c: return [.wide]
        case .iPhone5s: return [.wide]
        case .iPhone6: return [.wide]
        case .iPhone6Plus: return [.wide]
        case .iPhone6s: return [.wide]
        case .iPhone6sPlus: return [.wide]
        case .iPhone7: return [.wide]
        case .iPhoneSE: return [.wide]
        case .iPhone8: return [.wide]
        case .iPhoneXR: return [.wide]
        case .iPhoneSE2: return [.wide]
        case .iPad2: return [.wide]
        case .iPad3: return [.wide]
        case .iPad4: return [.wide]
        case .iPadAir: return [.wide]
        case .iPadAir2: return [.wide]
        case .iPad5: return [.wide]
        case .iPad6: return [.wide]
        case .iPadAir3: return [.wide]
        case .iPad7: return [.wide]
        case .iPad8: return [.wide]
        case .iPadAir4: return [.wide]
        case .iPadMini: return [.wide]
        case .iPadMini2: return [.wide]
        case .iPadMini3: return [.wide]
        case .iPadMini4: return [.wide]
        case .iPadMini5: return [.wide]
        case .iPadPro9Inch: return [.wide]
        case .iPadPro12Inch: return [.wide]
        case .iPadPro12Inch2: return [.wide]
        case .iPadPro10Inch: return [.wide]
        case .iPadPro11Inch: return [.wide]
        case .iPadPro12Inch3: return [.wide]
        case .iPhone7Plus: return [.wide, .telephoto]
        case .iPhone8Plus: return [.wide, .telephoto]
        case .iPhoneX: return [.wide, .telephoto]
        case .iPhoneXS: return [.wide, .telephoto]
        case .iPhoneXSMax: return [.wide, .telephoto]
        case .iPhone11: return [.wide, .ultraWide]
        case .iPhone12: return [.wide, .ultraWide]
        case .iPhone12Mini: return [.wide, .ultraWide]
        case .iPadPro11Inch2: return [.wide, .ultraWide]
        case .iPadPro12Inch4: return [.wide, .ultraWide]
        case .iPhone11Pro: return [.wide, .telephoto, .ultraWide]
        case .iPhone11ProMax: return [.wide, .telephoto, .ultraWide]
        case .iPhone12Pro: return [.wide, .telephoto, .ultraWide]
        case .iPhone12ProMax: return [.wide, .telephoto, .ultraWide]
        default: return []
        }
    }
    
    /// All devices that feature a camera
    public static var allDevicesWithCamera: [NKDevice] {
        return [.iPodTouch5, .iPodTouch6, .iPodTouch7, .iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPad5, .iPad6, .iPadAir3, .iPad7, .iPad8, .iPadAir4, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    /// All devices that feature a wide camera
    public static var allDevicesWithWideCamera: [NKDevice] {
        return [.iPodTouch5, .iPodTouch6, .iPodTouch7, .iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPad5, .iPad6, .iPadAir3, .iPad7, .iPad8, .iPadAir4, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    /// All devices that feature a telephoto camera
    public static var allDevicesWithTelephotoCamera: [NKDevice] {
        return [.iPhone7Plus, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhone11Pro, .iPhone11ProMax, .iPhone12Pro, .iPhone12ProMax]
    }
    
    /// All devices that feature an ultra wide camera
    public static var allDevicesWithUltraWideCamera: [NKDevice] {
        return [.iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    /// Returns whether or not the current device has a camera
    public var hasCamera: Bool {
        return !self.cameras.isEmpty
    }
    
    /// Returns whether or not the current device has a wide camera
    public var hasWideCamera: Bool {
        return self.cameras.contains(.wide)
    }
    
    /// Returns whether or not the current device has a telephoto camera
    public var hasTelephotoCamera: Bool {
        return self.cameras.contains(.telephoto)
    }
    
    /// Returns whether or not the current device has an ultra wide camera
    public var hasUltraWideCamera: Bool {
        return self.cameras.contains(.ultraWide)
    }
    
}
#endif
