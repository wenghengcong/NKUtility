//
//  NKDevice.swift
//  Pods
//
//  Created by Andrea Mario Lufino on 20/10/16.
//
//
// from https://github.com/dennisweissmann/DeviceKit

import AVFoundation
import CoreMotion
import CoreTelephony
import ExternalAccessory
import Foundation
import SystemConfiguration.CaptiveNetwork

// MARK: NKDevice

#if os(watchOS)
import WatchKit
#else
import UIKit
#endif

// MARK: NKDevice

/// This enum is a value-type wrapper and extension of
/// [`UIDevice`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDevice_Class/).
///
/// Usage:
///
///     let device = NKDevice.current
///
///     NKlogger.debug(device)     // prints, for example, "iPhone 6 Plus"
///
///     if device == .iPhone6Plus {
///         // Do something
///     } else {
///         // Do something else
///     }
///
///     ...
///
///     if device.batteryState == .full || device.batteryState >= .charging(75) {
///         NKlogger.debug("Your battery is happy! 😊")
///     }
///
///     ...
///
///     if device.batteryLevel >= 50 {
///         install_iOS()
///     } else {
///         showError()
///     }
///
extension NKDevice {
    
    /// Returns a `NKDevice` representing the current device this software runs on.
    public static var current: NKDevice {
        return NKDevice.mapToDevice(identifier: NKDevice.identifier)
    }
    
    /// Gets the identifier from the system, such as "iPhone7,1".
    public static var identifier: String = {
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        return identifier
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
        #endif
    }()
    
    /// See https://www.theiphonewiki.com/wiki/Models for identifiers
    public static var modelIdentifier: String {
        return identifier
    }

    public static var modelName: String {
        switch modelIdentifier {
        case "iPod1,1":                                 return "iPod Touch 1"
        case "iPod2,1":                                 return "iPod Touch 2"
        case "iPod3,1":                                 return "iPod Touch 3"
        case "iPod4,1":                                 return "iPod Touch 4"
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPod9,1":                                 return "iPod touch (7th generation)"
            
        case "iPhone1,1":                               return "iPhone 1G"
        case "iPhone1,2":                               return "iPhone 3G"
        case "iPhone2,1":                               return "iPhone 3GS"
        case "iPhone3,1":                               return "iPhone 4 (GSM)"
        case "iPhone3,2":                               return "iPhone 4"
        case "iPhone3,3":                               return "iPhone 4 (CDMA)"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE (2nd generation)"
        case "iPhone13,1":                              return "iPhone 12 mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
            
        case "iPad1,1":                                 return "iPad 1"
        case "iPad2,1":                                 return "iPad 2 (WiFi)"
        case "iPad2,2":                                 return "iPad 2 (GSM)"
        case "iPad2,3":                                 return "iPad 2 (CDMA)"
        case "iPad2,4":                                 return "iPad 2"
        case "iPad3,1":                                 return "iPad 3 (WiFi)"
        case "iPad3,2":                                 return "iPad 3 (4G)"
        case "iPad3,3":                                 return "iPad 3 (4G)"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad11,3":                                return "iPad Air 3"
        case "iPad11,4":                                return "iPad Air 3"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5":                                 return "iPad 6 (WiFi)"
        case "iPad7,6":                                 return "iPad 6 (Cellular)"
        case "iPad7,11":                                return "iPad 7 (WiFi)"
        case "iPad7,12":                                return "iPad 7 (Cellular)"
            
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad11,1","iPad11,2":                     return "iPad Mini 5"
            
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9 Inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5 Inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11 Inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9 Inch) (3rd generation)"
        case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9 Inch) (4th generation)"
            
        case "i386":                                    return "Simulator x86"
        case "x86_64":                                  return "Simulator x64"
        case "":                                        return ""

        case "Watch1,1":                                return "Apple Watch 38mm"
        case "Watch1,2":                                return "Apple Watch 42mm"
        case "Watch2,3":                                return "Apple Watch Series 2 38mm"
        case "Watch2,4":                                return "Apple Watch Series 2 42mm"
        case "Watch2,6":                                return "Apple Watch Series 1 38mm"
        case "Watch2,7":                                return "Apple Watch Series 1 42mm"
        case "Watch3,1":                                return "Apple Watch Series 3 38mm"
        case "Watch3,2":                                return "Apple Watch Series 3 42mm"
        case "Watch3,3":                                return "Apple Watch Series 3 38mm (LTE)"
        case "Watch3,4":                                return "Apple Watch Series 3 42mm (LTE)"
        case "Watch4,1":                                return "Apple Watch Series 4 40mm"
        case "Watch4,2":                                return "Apple Watch Series 4 44mm"
        case "Watch4,3":                                return "Apple Watch Series 4 40mm (LTE)"
        case "Watch4,4":                                return "Apple Watch Series 4 44mm (LTE)"
        case "Watch5,1":                                return "Apple Watch Series 5 40mm"
        case "Watch5,2":                                return "Apple Watch Series 5 44mm"
        case "Watch5,3":                                return "Apple Watch Series 5 40mm (LTE)"
        case "Watch5,4":                                return "Apple Watch Series 5 44mm (LTE)"
            
        case "AirPods1,1":                              return "AirPods (1st generation)"
        case "AirPods2,1":                              return "AirPods (2nd generation)"
            
        case "AppleTV2,1":                              return "Apple TV 2"
        case "AppleTV3,1":                              return "Apple TV 3"
        case "AppleTV3,2":                              return "Apple TV 3"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1","AudioAccessory1,2":   return "HomePod"
        default:                                        return identifier
        }
    }
    
    /// Maps an identifier to a NKDevice. If the identifier can not be mapped to an existing device, `UnknownDevice(identifier)` is returned.
    ///
    /// - parameter identifier: The device identifier, e.g. "iPhone7,1". Can be obtained from `NKDevice.identifier`.
    ///
    /// - returns: An initialized `NKDevice`.
    public static func mapToDevice(identifier: String) -> NKDevice { // swiftlint:disable:this cyclomatic_complexity function_body_length
        #if os(iOS)
        switch identifier {
        case "iPod5,1": return iPodTouch5
        case "iPod7,1": return iPodTouch6
        case "iPod9,1": return iPodTouch7
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return iPhone4
        case "iPhone4,1": return iPhone4s
        case "iPhone5,1", "iPhone5,2": return iPhone5
        case "iPhone5,3", "iPhone5,4": return iPhone5c
        case "iPhone6,1", "iPhone6,2": return iPhone5s
        case "iPhone7,2": return iPhone6
        case "iPhone7,1": return iPhone6Plus
        case "iPhone8,1": return iPhone6s
        case "iPhone8,2": return iPhone6sPlus
        case "iPhone9,1", "iPhone9,3": return iPhone7
        case "iPhone9,2", "iPhone9,4": return iPhone7Plus
        case "iPhone8,4": return iPhoneSE
        case "iPhone10,1", "iPhone10,4": return iPhone8
        case "iPhone10,2", "iPhone10,5": return iPhone8Plus
        case "iPhone10,3", "iPhone10,6": return iPhoneX
        case "iPhone11,2": return iPhoneXS
        case "iPhone11,4", "iPhone11,6": return iPhoneXSMax
        case "iPhone11,8": return iPhoneXR
        case "iPhone12,1": return iPhone11
        case "iPhone12,3": return iPhone11Pro
        case "iPhone12,5": return iPhone11ProMax
        case "iPhone12,8": return iPhoneSE2
        case "iPhone13,2": return iPhone12
        case "iPhone13,1": return iPhone12Mini
        case "iPhone13,3": return iPhone12Pro
        case "iPhone13,4": return iPhone12ProMax
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3": return iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6": return iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3": return iPadAir
        case "iPad5,3", "iPad5,4": return iPadAir2
        case "iPad6,11", "iPad6,12": return iPad5
        case "iPad7,5", "iPad7,6": return iPad6
        case "iPad11,3", "iPad11,4": return iPadAir3
        case "iPad7,11", "iPad7,12": return iPad7
        case "iPad11,6", "iPad11,7": return iPad8
        case "iPad13,1", "iPad13,2": return iPadAir4
        case "iPad2,5", "iPad2,6", "iPad2,7": return iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6": return iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9": return iPadMini3
        case "iPad5,1", "iPad5,2": return iPadMini4
        case "iPad11,1", "iPad11,2": return iPadMini5
        case "iPad6,3", "iPad6,4": return iPadPro9Inch
        case "iPad6,7", "iPad6,8": return iPadPro12Inch
        case "iPad7,1", "iPad7,2": return iPadPro12Inch2
        case "iPad7,3", "iPad7,4": return iPadPro10Inch
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return iPadPro11Inch
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return iPadPro12Inch3
        case "iPad8,9", "iPad8,10": return iPadPro11Inch2
        case "iPad8,11", "iPad8,12": return iPadPro12Inch4
        case "AudioAccessory1,1": return homePod
        case "i386", "x86_64": return simulator(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))
        default: return unknown(identifier)
        }
        #elseif os(tvOS)
        switch identifier {
        case "AppleTV5,3": return appleTVHD
        case "AppleTV6,2": return appleTV4K
        case "i386", "x86_64": return simulator(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))
        default: return unknown(identifier)
        }
        #elseif os(watchOS)
        switch identifier {
        case "Watch1,1": return appleWatchSeries0_38mm
        case "Watch1,2": return appleWatchSeries0_42mm
        case "Watch2,6": return appleWatchSeries1_38mm
        case "Watch2,7": return appleWatchSeries1_42mm
        case "Watch2,3": return appleWatchSeries2_38mm
        case "Watch2,4": return appleWatchSeries2_42mm
        case "Watch3,1", "Watch3,3": return appleWatchSeries3_38mm
        case "Watch3,2", "Watch3,4": return appleWatchSeries3_42mm
        case "Watch4,1", "Watch4,3": return appleWatchSeries4_40mm
        case "Watch4,2", "Watch4,4": return appleWatchSeries4_44mm
        case "Watch5,1", "Watch5,3": return appleWatchSeries5_40mm
        case "Watch5,2", "Watch5,4": return appleWatchSeries5_44mm
        case "Watch6,1", "Watch6,3": return appleWatchSeries6_40mm
        case "Watch6,2", "Watch6,4": return appleWatchSeries6_44mm
        case "Watch5,9", "Watch5,11": return appleWatchSE_40mm
        case "Watch5,10", "Watch5,12": return appleWatchSE_44mm
        case "i386", "x86_64": return simulator(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "watchOS"))
        default: return unknown(identifier)
        }
        #endif
    }
        
    
    /// Get the real device from a device.
    /// If the device is a an iPhone8Plus simulator this function returns .iPhone8Plus (the real device).
    /// If the parameter is a real device, this function returns just that passed parameter.
    ///
    /// - parameter device: A device.
    ///
    /// - returns: the underlying device If the `device` is a `simulator`,
    /// otherwise return the `device`.
    public static func realDevice(from device: NKDevice) -> NKDevice {
        if case let .simulator(model) = device {
            return model
        }
        return device
    }
    
    
    #if os(iOS)
    /// All iPods
    public static var allPods: [NKDevice] {
        return [.iPodTouch5, .iPodTouch6, .iPodTouch7]
    }
    
    /// All iPhones
    public static var allPhones: [NKDevice] {
        return [.iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax]
    }
    
    /// All iPads
    public static var allPads: [NKDevice] {
        return [.iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPad5, .iPad6, .iPadAir3, .iPad7, .iPad8, .iPadAir4, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    /// All Plus and Max-Sized Devices
    public static var allPlusSizedDevices: [NKDevice] {
        return [.iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus, .iPhoneXSMax, .iPhone11ProMax, .iPhone12ProMax]
    }
    
    /// All Pro Devices
    public static var allProDevices: [NKDevice] {
        return [.iPhone11Pro, .iPhone11ProMax, .iPhone12Pro, .iPhone12ProMax, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    /// All mini Devices
    public static var allMiniDevices: [NKDevice] {
        return [.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5]
    }
    
    /// All simulator iPods
    public static var allSimulatorPods: [NKDevice] {
        return allPods.map(NKDevice.simulator)
    }
    
    /// All simulator iPhones
    public static var allSimulatorPhones: [NKDevice] {
        return allPhones.map(NKDevice.simulator)
    }
    
    /// All simulator iPads
    public static var allSimulatorPads: [NKDevice] {
        return allPads.map(NKDevice.simulator)
    }
    
    /// All simulator iPad mini
    public static var allSimulatorMiniDevices: [NKDevice] {
        return allMiniDevices.map(NKDevice.simulator)
    }
    
    /// All simulator Plus and Max-Sized Devices
    public static var allSimulatorPlusSizedDevices: [NKDevice] {
        return allPlusSizedDevices.map(NKDevice.simulator)
    }
    
    /// All simulator Pro Devices
    public static var allSimulatorProDevices: [NKDevice] {
        return allProDevices.map(NKDevice.simulator)
    }
    
    /// Returns whether the device is an iPod (real or simulator)
    public var isPod: Bool {
        return isOneOf(NKDevice.allPods) || isOneOf(NKDevice.allSimulatorPods)
    }
    
    /// Returns whether the device is an iPhone (real or simulator)
    public var isPhone: Bool {
        return (isOneOf(NKDevice.allPhones)
                    || isOneOf(NKDevice.allSimulatorPhones)
                    || (UIDevice.current.userInterfaceIdiom == .phone && isCurrent)) && !isPod
    }
    
    /// Returns whether the device is an iPad (real or simulator)
    public var isPad: Bool {
        return isOneOf(NKDevice.allPads)
            || isOneOf(NKDevice.allSimulatorPads)
            || (UIDevice.current.userInterfaceIdiom == .pad && isCurrent)
    }
    
    /// Returns whether the device is any of the simulator
    /// Useful when there is a need to check and skip running a portion of code (location request or others)
    public var isSimulator: Bool {
        return isOneOf(NKDevice.allSimulators)
    }
    
    /// If this device is a simulator return the underlying device,
    /// otherwise return `self`.
    public var realDevice: NKDevice {
        return NKDevice.realDevice(from: self)
    }
    
    public var isZoomed: Bool? {
        guard isCurrent else { return nil }
        if Int(UIScreen.main.scale.rounded()) == 3 {
            // Plus-sized
            return UIScreen.main.nativeScale > 2.7 && UIScreen.main.nativeScale < 3
        } else {
            return UIScreen.main.nativeScale > UIScreen.main.scale
        }
    }
    
    /// All Touch ID Capable Devices
    public static var allTouchIDCapableDevices: [NKDevice] {
        return [.iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneSE2, .iPadAir2, .iPad5, .iPad6, .iPadAir3, .iPad7, .iPad8, .iPadAir4, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch]
    }
    
    /// All Face ID Capable Devices
    public static var allFaceIDCapableDevices: [NKDevice] {
        return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    /// All Devices with Touch ID or Face ID
    public static var allBiometricAuthenticationCapableDevices: [NKDevice] {
        return [.iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPadAir2, .iPad5, .iPad6, .iPadAir3, .iPad7, .iPad8, .iPadAir4, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    /// Returns whether or not the device has Touch ID
    public var isTouchIDCapable: Bool {
        return isOneOf(NKDevice.allTouchIDCapableDevices) || isOneOf(NKDevice.allTouchIDCapableDevices.map(NKDevice.simulator))
    }
    
    /// Returns whether or not the device has Face ID
    public var isFaceIDCapable: Bool {
        return isOneOf(NKDevice.allFaceIDCapableDevices) || isOneOf(NKDevice.allFaceIDCapableDevices.map(NKDevice.simulator))
    }
    
    /// Returns whether or not the device has any biometric sensor (i.e. Touch ID or Face ID)
    public var hasBiometricSensor: Bool {
        return isTouchIDCapable || isFaceIDCapable
    }
    
    /// All devices that feature a sensor housing in the screen
    public static var allDevicesWithSensorHousing: [NKDevice] {
        return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax]
    }
    
    /// All simulator devices that feature a sensor housing in the screen
    public static var allSimulatorDevicesWithSensorHousing: [NKDevice] {
        return allDevicesWithSensorHousing.map(NKDevice.simulator)
    }
    
    /// Returns whether or not the device has a sensor housing
    public var hasSensorHousing: Bool {
        return isOneOf(NKDevice.allDevicesWithSensorHousing) || isOneOf(NKDevice.allDevicesWithSensorHousing.map(NKDevice.simulator))
    }
    
    /// All devices that feature a screen with rounded corners.
    public static var allDevicesWithRoundedDisplayCorners: [NKDevice] {
        return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPadAir4, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    /// Returns whether or not the device has a screen with rounded corners.
    public var hasRoundedDisplayCorners: Bool {
        return isOneOf(NKDevice.allDevicesWithRoundedDisplayCorners) || isOneOf(NKDevice.allDevicesWithRoundedDisplayCorners.map(NKDevice.simulator))
    }
    
    /// All devices that have 3D Touch support.
    public static var allDevicesWith3dTouchSupport: [NKDevice] {
        return [.iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax]
    }
    
    /// Returns whether or not the device has 3D Touch support.
    public var has3dTouchSupport: Bool {
        return isOneOf(NKDevice.allDevicesWith3dTouchSupport) || isOneOf(NKDevice.allDevicesWith3dTouchSupport.map(NKDevice.simulator))
    }
    
    /// All devices that support wireless charging.
    public static var allDevicesWithWirelessChargingSupport: [NKDevice] {
        return [.iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax]
    }
    
    /// Returns whether or not the device supports wireless charging.
    public var supportsWirelessCharging: Bool {
        return isOneOf(NKDevice.allDevicesWithWirelessChargingSupport) || isOneOf(NKDevice.allDevicesWithWirelessChargingSupport.map(NKDevice.simulator))
    }
    
    /// All devices that have a LiDAR sensor.
    public static var allDevicesWithALidarSensor: [NKDevice] {
        return [.iPhone12Pro, .iPhone12ProMax, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    /// Returns whether or not the device has a LiDAR sensor.
    public var hasLidarSensor: Bool {
        return isOneOf(NKDevice.allDevicesWithALidarSensor) || isOneOf(NKDevice.allDevicesWithALidarSensor.map(NKDevice.simulator))
    }
    #elseif os(tvOS)
    /// All TVs
    public static var allTVs: [NKDevice] {
        return [.appleTVHD, .appleTV4K]
    }
    
    /// All simulator TVs
    public static var allSimulatorTVs: [NKDevice] {
        return allTVs.map(NKDevice.simulator)
    }
    #elseif os(watchOS)
    /// All Watches
    public static var allWatches: [NKDevice] {
        return [.appleWatchSeries0_38mm, .appleWatchSeries0_42mm, .appleWatchSeries1_38mm, .appleWatchSeries1_42mm, .appleWatchSeries2_38mm, .appleWatchSeries2_42mm, .appleWatchSeries3_38mm, .appleWatchSeries3_42mm, .appleWatchSeries4_40mm, .appleWatchSeries4_44mm, .appleWatchSeries5_40mm, .appleWatchSeries5_44mm, .appleWatchSeries6_40mm, .appleWatchSeries6_44mm, .appleWatchSE_40mm, .appleWatchSE_44mm]
    }
    
    /// All simulator Watches
    public static var allSimulatorWatches: [NKDevice] {
        return allWatches.map(NKDevice.simulator)
    }
    
    /// All watches that have Force Touch support.
    public static var allWatchesWithForceTouchSupport: [NKDevice] {
        return [.appleWatchSeries0_38mm, .appleWatchSeries0_42mm, .appleWatchSeries1_38mm, .appleWatchSeries1_42mm, .appleWatchSeries2_38mm, .appleWatchSeries2_42mm, .appleWatchSeries3_38mm, .appleWatchSeries3_42mm, .appleWatchSeries4_40mm, .appleWatchSeries4_44mm, .appleWatchSeries5_40mm, .appleWatchSeries5_44mm]
    }
    
    /// Returns whether or not the device has Force Touch support.
    public var hasForceTouchSupport: Bool {
        return isOneOf(NKDevice.allWatchesWithForceTouchSupport) || isOneOf(NKDevice.allWatchesWithForceTouchSupport.map(NKDevice.simulator))
    }
    #endif
    
    /// All real devices (i.e. all devices except for all simulators)
    public static var allRealDevices: [NKDevice] {
        #if os(iOS)
        return allPods + allPhones + allPads
        #elseif os(tvOS)
        return allTVs
        #elseif os(watchOS)
        return allWatches
        #endif
    }
    
    /// All simulators
    public static var allSimulators: [NKDevice] {
        return allRealDevices.map(NKDevice.simulator)
    }
    
    /**
     This method saves you in many cases from the need of updating your code with every new device.
     Most uses for an enum like this are the following:
     
     ```
     switch NKDevice.current {
     case .iPodTouch5, .iPodTouch6: callMethodOnIPods()
     case .iPhone4, iPhone4s, .iPhone5, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX: callMethodOnIPhones()
     case .iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro: callMethodOnIPads()
     default: break
     }
     ```
     This code can now be replaced with
     
     ```
     let device = NKDevice.current
     if device.isOneOf(NKDevice.allPods) {
     callMethodOnIPods()
     } else if device.isOneOf(NKDevice.allPhones) {
     callMethodOnIPhones()
     } else if device.isOneOf(NKDevice.allPads) {
     callMethodOnIPads()
     }
     ```
     
     - parameter devices: An array of devices.
     
     - returns: Returns whether the current device is one of the passed in ones.
     */
    public func isOneOf(_ devices: [NKDevice]) -> Bool {
        return devices.contains(self)
    }
    
    // MARK: Current NKDevice
    
    /// Whether or not the current device is the current device.
    internal var isCurrent: Bool {
        return self == NKDevice.current
    }
    
    /// The name identifying the device (e.g. "Dennis' iPhone").
    public var name: String? {
        guard isCurrent else { return nil }
        #if os(watchOS)
        return WKInterfaceDevice.current().name
        #else
        return UIDevice.current.name
        #endif
    }
    
    /// The name of the operating system running on the device represented by the receiver (e.g. "iOS" or "tvOS").
    public var systemName: String? {
        guard isCurrent else { return nil }
        #if os(watchOS)
        return WKInterfaceDevice.current().systemName
        #else
        return UIDevice.current.systemName
        #endif
    }
    
    
    /// The model of the device (e.g. "iPhone" or "iPod Touch").
    public var model: String? {
        guard isCurrent else { return nil }
        #if os(watchOS)
        return WKInterfaceDevice.current().model
        #else
        return UIDevice.current.model
        #endif
    }
    
    /// The model of the device as a localized string.
    public var localizedModel: String? {
        guard isCurrent else { return nil }
        #if os(watchOS)
        return WKInterfaceDevice.current().localizedModel
        #else
        return UIDevice.current.localizedModel
        #endif
    }

    /// True when a Guided Access session is currently active; otherwise, false.
    public var isGuidedAccessSessionActive: Bool {
        #if os(iOS)
        #if swift(>=4.2)
        return UIAccessibility.isGuidedAccessEnabled
        #else
        return UIAccessibilityIsGuidedAccessEnabled()
        #endif
        #else
        return false
        #endif
    }
}

// MARK: CustomStringConvertible
extension NKDevice: CustomStringConvertible {
        
    /// A textual representation of the device.
    public var description: String {
        #if os(iOS)
        switch self {
        case .iPodTouch1: return "iPod Touch (1th generation)"
        case .iPodTouch2: return "iPod Touch (2th generation)"
        case .iPodTouch3: return "iPod Touch (3th generation)"
        case .iPodTouch4: return "iPod Touch (4th generation)"
        case .iPodTouch5: return "iPod Touch (5th generation)"
        case .iPodTouch6: return "iPod touch (6th generation)"
        case .iPodTouch7: return "iPod touch (7th generation)"
        case .iPhone4: return "iPhone 4"
        case .iPhone4s: return "iPhone 4s"
        case .iPhone5: return "iPhone 5"
        case .iPhone5c: return "iPhone 5c"
        case .iPhone5s: return "iPhone 5s"
        case .iPhone6: return "iPhone 6"
        case .iPhone6Plus: return "iPhone 6 Plus"
        case .iPhone6s: return "iPhone 6s"
        case .iPhone6sPlus: return "iPhone 6s Plus"
        case .iPhone7: return "iPhone 7"
        case .iPhone7Plus: return "iPhone 7 Plus"
        case .iPhoneSE: return "iPhone SE"
        case .iPhone8: return "iPhone 8"
        case .iPhone8Plus: return "iPhone 8 Plus"
        case .iPhoneX: return "iPhone X"
        case .iPhoneXS: return "iPhone Xs"
        case .iPhoneXSMax: return "iPhone Xs Max"
        case .iPhoneXR: return "iPhone Xʀ"
        case .iPhone11: return "iPhone 11"
        case .iPhone11Pro: return "iPhone 11 Pro"
        case .iPhone11ProMax: return "iPhone 11 Pro Max"
        case .iPhoneSE2: return "iPhone SE (2nd generation)"
        case .iPhone12: return "iPhone 12"
        case .iPhone12Mini: return "iPhone 12 mini"
        case .iPhone12Pro: return "iPhone 12 Pro"
        case .iPhone12ProMax: return "iPhone 12 Pro Max"
        case .iPad2: return "iPad 2"
        case .iPad3: return "iPad (3rd generation)"
        case .iPad4: return "iPad (4th generation)"
        case .iPadAir: return "iPad Air"
        case .iPadAir2: return "iPad Air 2"
        case .iPad5: return "iPad (5th generation)"
        case .iPad6: return "iPad (6th generation)"
        case .iPadAir3: return "iPad Air (3rd generation)"
        case .iPad7: return "iPad (7th generation)"
        case .iPad8: return "iPad (8th generation)"
        case .iPadAir4: return "iPad Air (4th generation)"
        case .iPadMini: return "iPad Mini"
        case .iPadMini2: return "iPad Mini 2"
        case .iPadMini3: return "iPad Mini 3"
        case .iPadMini4: return "iPad Mini 4"
        case .iPadMini5: return "iPad Mini (5th generation)"
        case .iPadPro9Inch: return "iPad Pro (9.7-inch)"
        case .iPadPro12Inch: return "iPad Pro (12.9-inch)"
        case .iPadPro12Inch2: return "iPad Pro (12.9-inch) (2nd generation)"
        case .iPadPro10Inch: return "iPad Pro (10.5-inch)"
        case .iPadPro11Inch: return "iPad Pro (11-inch)"
        case .iPadPro12Inch3: return "iPad Pro (12.9-inch) (3rd generation)"
        case .iPadPro11Inch2: return "iPad Pro (11-inch) (2nd generation)"
        case .iPadPro12Inch4: return "iPad Pro (12.9-inch) (4th generation)"
        case .homePod: return "HomePod"
        case .simulator(let model): return "Simulator (\(model.description))"
        case .unknown(let identifier): return identifier
        }
        #elseif os(watchOS)
        switch self {
        case .appleWatchSeries0_38mm: return "Apple Watch (1st generation) 38mm"
        case .appleWatchSeries0_42mm: return "Apple Watch (1st generation) 42mm"
        case .appleWatchSeries1_38mm: return "Apple Watch Series 1 38mm"
        case .appleWatchSeries1_42mm: return "Apple Watch Series 1 42mm"
        case .appleWatchSeries2_38mm: return "Apple Watch Series 2 38mm"
        case .appleWatchSeries2_42mm: return "Apple Watch Series 2 42mm"
        case .appleWatchSeries3_38mm: return "Apple Watch Series 3 38mm"
        case .appleWatchSeries3_42mm: return "Apple Watch Series 3 42mm"
        case .appleWatchSeries4_40mm: return "Apple Watch Series 4 40mm"
        case .appleWatchSeries4_44mm: return "Apple Watch Series 4 44mm"
        case .appleWatchSeries5_40mm: return "Apple Watch Series 5 40mm"
        case .appleWatchSeries5_44mm: return "Apple Watch Series 5 44mm"
        case .appleWatchSeries6_40mm: return "Apple Watch Series 6 40mm"
        case .appleWatchSeries6_44mm: return "Apple Watch Series 6 44mm"
        case .appleWatchSE_40mm: return "Apple Watch SE 40mm"
        case .appleWatchSE_44mm: return "Apple Watch SE 44mm"
        case .simulator(let model): return "Simulator (\(model.description))"
        case .unknown(let identifier): return identifier
        }
        #elseif os(tvOS)
        switch self {
        case .appleTVHD: return "Apple TV HD"
        case .appleTV4K: return "Apple TV 4K"
        case .simulator(let model): return "Simulator (\(model.description))"
        case .unknown(let identifier): return identifier
        }
        #endif
    }
    
    /// A safe version of `description`.
    /// Example:
    /// NKDevice.iPhoneXR.description:     iPhone Xʀ
    /// NKDevice.iPhoneXR.safeDescription: iPhone XR
    public var safeDescription: String {
        #if os(iOS)
        switch self {
        case .iPodTouch1: return "iPod Touch (1th generation)"
        case .iPodTouch2: return "iPod Touch (2th generation)"
        case .iPodTouch3: return "iPod Touch (3th generation)"
        case .iPodTouch4: return "iPod Touch (4th generation)"
        case .iPodTouch5: return "iPod Touch (5th generation)"
        case .iPodTouch6: return "iPod touch (6th generation)"
        case .iPodTouch7: return "iPod touch (7th generation)"
        case .iPhone4: return "iPhone 4"
        case .iPhone4s: return "iPhone 4s"
        case .iPhone5: return "iPhone 5"
        case .iPhone5c: return "iPhone 5c"
        case .iPhone5s: return "iPhone 5s"
        case .iPhone6: return "iPhone 6"
        case .iPhone6Plus: return "iPhone 6 Plus"
        case .iPhone6s: return "iPhone 6s"
        case .iPhone6sPlus: return "iPhone 6s Plus"
        case .iPhone7: return "iPhone 7"
        case .iPhone7Plus: return "iPhone 7 Plus"
        case .iPhoneSE: return "iPhone SE"
        case .iPhone8: return "iPhone 8"
        case .iPhone8Plus: return "iPhone 8 Plus"
        case .iPhoneX: return "iPhone X"
        case .iPhoneXS: return "iPhone XS"
        case .iPhoneXSMax: return "iPhone XS Max"
        case .iPhoneXR: return "iPhone XR"
        case .iPhone11: return "iPhone 11"
        case .iPhone11Pro: return "iPhone 11 Pro"
        case .iPhone11ProMax: return "iPhone 11 Pro Max"
        case .iPhoneSE2: return "iPhone SE (2nd generation)"
        case .iPhone12: return "iPhone 12"
        case .iPhone12Mini: return "iPhone 12 mini"
        case .iPhone12Pro: return "iPhone 12 Pro"
        case .iPhone12ProMax: return "iPhone 12 Pro Max"
        case .iPad2: return "iPad 2"
        case .iPad3: return "iPad (3rd generation)"
        case .iPad4: return "iPad (4th generation)"
        case .iPadAir: return "iPad Air"
        case .iPadAir2: return "iPad Air 2"
        case .iPad5: return "iPad (5th generation)"
        case .iPad6: return "iPad (6th generation)"
        case .iPadAir3: return "iPad Air (3rd generation)"
        case .iPad7: return "iPad (7th generation)"
        case .iPad8: return "iPad (8th generation)"
        case .iPadAir4: return "iPad Air (4th generation)"
        case .iPadMini: return "iPad Mini"
        case .iPadMini2: return "iPad Mini 2"
        case .iPadMini3: return "iPad Mini 3"
        case .iPadMini4: return "iPad Mini 4"
        case .iPadMini5: return "iPad Mini (5th generation)"
        case .iPadPro9Inch: return "iPad Pro (9.7-inch)"
        case .iPadPro12Inch: return "iPad Pro (12.9-inch)"
        case .iPadPro12Inch2: return "iPad Pro (12.9-inch) (2nd generation)"
        case .iPadPro10Inch: return "iPad Pro (10.5-inch)"
        case .iPadPro11Inch: return "iPad Pro (11-inch)"
        case .iPadPro12Inch3: return "iPad Pro (12.9-inch) (3rd generation)"
        case .iPadPro11Inch2: return "iPad Pro (11-inch) (2nd generation)"
        case .iPadPro12Inch4: return "iPad Pro (12.9-inch) (4th generation)"
        case .homePod: return "HomePod"
        case .simulator(let model): return "Simulator (\(model.safeDescription))"
        case .unknown(let identifier): return identifier
        }
        #elseif os(watchOS)
        switch self {
        case .appleWatchSeries0_38mm: return "Apple Watch (1st generation) 38mm"
        case .appleWatchSeries0_42mm: return "Apple Watch (1st generation) 42mm"
        case .appleWatchSeries1_38mm: return "Apple Watch Series 1 38mm"
        case .appleWatchSeries1_42mm: return "Apple Watch Series 1 42mm"
        case .appleWatchSeries2_38mm: return "Apple Watch Series 2 38mm"
        case .appleWatchSeries2_42mm: return "Apple Watch Series 2 42mm"
        case .appleWatchSeries3_38mm: return "Apple Watch Series 3 38mm"
        case .appleWatchSeries3_42mm: return "Apple Watch Series 3 42mm"
        case .appleWatchSeries4_40mm: return "Apple Watch Series 4 40mm"
        case .appleWatchSeries4_44mm: return "Apple Watch Series 4 44mm"
        case .appleWatchSeries5_40mm: return "Apple Watch Series 5 40mm"
        case .appleWatchSeries5_44mm: return "Apple Watch Series 5 44mm"
        case .appleWatchSeries6_40mm: return "Apple Watch Series 6 40mm"
        case .appleWatchSeries6_44mm: return "Apple Watch Series 6 44mm"
        case .appleWatchSE_40mm: return "Apple Watch SE 40mm"
        case .appleWatchSE_44mm: return "Apple Watch SE 44mm"
        case .simulator(let model): return "Simulator (\(model.safeDescription))"
        case .unknown(let identifier): return identifier
        }
        #elseif os(tvOS)
        switch self {
        case .appleTVHD: return "Apple TV HD"
        case .appleTV4K: return "Apple TV 4K"
        case .simulator(let model): return "Simulator (\(model.safeDescription))"
        case .unknown(let identifier): return identifier
        }
        #endif
    }
    
}

// MARK: Equatable
extension NKDevice: Equatable {
    
    /// Compares two devices
    ///
    /// - parameter lhs: A device.
    /// - parameter rhs: Another device.
    ///
    /// - returns: `true` iff the underlying identifier is the same.
    public static func == (lhs: NKDevice, rhs: NKDevice) -> Bool {
        return lhs.description == rhs.description
    }
    
}

// MARK: Battery
#if os(iOS) || os(watchOS)
@available(iOS 8.0, watchOS 4.0, *)
extension NKDevice {
   
}
#endif

#if os(iOS)
// MARK: DiskSpace
extension NKDevice {
    
    /// Return the root url
    ///
    /// - returns: the NSHomeDirectory() url
    private static let rootURL = URL(fileURLWithPath: NSHomeDirectory())
    
    /// The volume’s total capacity in bytes.
    public static var volumeTotalCapacity: Int? {
        return (try? NKDevice.rootURL.resourceValues(forKeys: [.volumeTotalCapacityKey]))?.volumeTotalCapacity
    }
    
    /// The volume’s available capacity in bytes.
    public static var volumeAvailableCapacity: Int? {
        return (try? rootURL.resourceValues(forKeys: [.volumeAvailableCapacityKey]))?.volumeAvailableCapacity
    }
    
    /// The volume’s available capacity in bytes for storing important resources.
    @available(iOS 11.0, *)
    public static var volumeAvailableCapacityForImportantUsage: Int64? {
        return (try? rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]))?.volumeAvailableCapacityForImportantUsage
    }
    
    /// The volume’s available capacity in bytes for storing nonessential resources.
    @available(iOS 11.0, *)
    public static var volumeAvailableCapacityForOpportunisticUsage: Int64? { //swiftlint:disable:this identifier_name
        return (try? rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey]))?.volumeAvailableCapacityForOpportunisticUsage
    }
    
    /// All volumes capacity information in bytes.
    @available(iOS 11.0, *)
    public static var volumes: [URLResourceKey: Int64]? {
        do {
            let values = try rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                              .volumeAvailableCapacityKey,
                                                              .volumeAvailableCapacityForOpportunisticUsageKey,
                                                              .volumeTotalCapacityKey
            ])
            return values.allValues.mapValues {
                if let int = $0 as? Int64 {
                    return int
                }
                if let int = $0 as? Int {
                    return Int64(int)
                }
                return 0
            }
        } catch {
            return nil
        }
    }
}
#endif

