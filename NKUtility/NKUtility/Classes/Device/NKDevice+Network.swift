//
//  NKDevice+Network.swift
//  NKDevice
//
//  Created by Andrea Mario Lufino on 10/11/2019.
//

import Foundation
import SystemConfiguration.CaptiveNetwork


extension NKDevice {
    
    // MARK: Network
    
    #if os(iOS) || os(watchOS)
    /// Returns connectivity of device
    public var connectivity: NKDeviceConnectivity {
        #if os(iOS)
        switch self {
        case .iPodTouch1: return .wiFi
        case .iPodTouch2: return .wiFi
        case .iPodTouch3: return .wiFi
        case .iPodTouch4: return .wiFi
        case .iPodTouch5: return .wiFi
        case .iPodTouch6: return .wiFi
        case .iPodTouch7: return .wiFi
        case .iPhone4: return .wiFi3G
        case .iPhone4s: return .wiFi3G
        case .iPhone5: return .wiFi4G
        case .iPhone5c: return .wiFi4G
        case .iPhone5s: return .wiFi4G
        case .iPhone6: return .wiFi4G
        case .iPhone6Plus: return .wiFi4G
        case .iPhone6s: return .wiFi4G
        case .iPhone6sPlus: return .wiFi4G
        case .iPhone7: return .wiFi4G
        case .iPhone7Plus: return .wiFi4G
        case .iPhoneSE: return .wiFi4G
        case .iPhone8: return .wiFi4G
        case .iPhone8Plus: return .wiFi4G
        case .iPhoneX: return .wiFi4G
        case .iPhoneXS: return .wiFi4G
        case .iPhoneXSMax: return .wiFi4G
        case .iPhoneXR: return .wiFi4G
        case .iPhone11: return .wiFi4G
        case .iPhone11Pro: return .wiFi4G
        case .iPhone11ProMax: return .wiFi4G
        case .iPhoneSE2: return .wiFi4G
        case .iPhone12: return .wiFi5G
        case .iPhone12Mini: return .wiFi5G
        case .iPhone12Pro: return .wiFi5G
        case .iPhone12ProMax: return .wiFi5G
            
        case .iPad2: return .wiFi3G
        case .iPad3: return .wiFi3G
        case .iPad4: return .wiFi4G
        case .iPad5: return .wiFi4G
        case .iPad6: return .wiFi4G
        case .iPad7: return .wiFi4G
        case .iPad8: return .wiFi4G
            
        case .iPadAir: return .wiFi4G
        case .iPadAir2: return .wiFi4G
        case .iPadAir3: return .wiFi4G
        case .iPadAir4: return .wiFi4G

        case .iPadMini: return .wiFi3G
        case .iPadMini2: return .wiFi4G
        case .iPadMini3: return .wiFi4G
        case .iPadMini4: return .wiFi4G
        case .iPadMini5: return .wiFi4G
            
        case .iPadPro9Inch: return .wiFi4G
        case .iPadPro12Inch: return .wiFi4G
        case .iPadPro12Inch2: return .wiFi4G
        case .iPadPro10Inch: return .wiFi4G
        case .iPadPro11Inch: return .wiFi4G
        case .iPadPro12Inch3: return .wiFi4G
        case .iPadPro11Inch2: return .wiFi4G
        case .iPadPro12Inch4: return .wiFi4G
        case .homePod: return .unknown
        case .simulator(let model): return model.connectivity
        case .unknown: return .unknown
        }
        #elseif os(watchOS)
        switch self {
        case .appleWatchSeries0_38mm: return .wiFi4G
        case .appleWatchSeries0_42mm: return .wiFi4G
        case .appleWatchSeries1_38mm: return .wiFi4G
        case .appleWatchSeries1_42mm: return .wiFi4G
        case .appleWatchSeries2_38mm: return .wiFi4G
        case .appleWatchSeries2_42mm: return .wiFi4G
        case .appleWatchSeries3_38mm: return .wiFi4G
        case .appleWatchSeries3_42mm: return .wiFi4G
        case .appleWatchSeries4_40mm: return .wiFi4G
        case .appleWatchSeries4_44mm: return .wiFi4G
        case .appleWatchSeries5_40mm: return .wiFi4G
        case .appleWatchSeries5_44mm: return .wiFi4G
        case .appleWatchSeries6_40mm: return .wiFi4G
        case .appleWatchSeries6_44mm: return .wiFi4G
        case .appleWatchSE_40mm: return .wiFi4G
        case .appleWatchSE_44mm: return .wiFi4G
        case .simulator(let model): return model.connectivity
        case .unknown: return .wiFi4G
        }
        #endif
    }
    #endif
    
    /// Network information.
    public struct Network {
        /// Check if the device is connected to the WiFi network.
        public static var isConnectedViaWiFi: Bool {
            return NKNetworkUtil.shared.isReachableOnWiFi
        }
        
        /// Check if the device is connected to the cellular network.
        public static var isConnectedViaCellular: Bool {
            return NKNetworkUtil.shared.isReachableOnCellular
        }
        
        /// Check if the internet is available.
        public static var isInternetAvailable: Bool {
            return NKNetworkUtil.shared.isReachable
        }
        
        /// Get the network SSID (doesn't work in the Simulator). Empty string if not available.
        /// This property is deprecated since version 2 of NKDevice as iOS 13 does not allow access to
        /// `CNCopySupportedInterfaces`.
        @available(iOS, deprecated: 13.0, message: "It's no longer possible to get SSID info using CNCopySupportedInterfaces.")
        public static var SSID: String {
            
            // Doesn't work in the Simulator
            var currentSSID = ""
            if let interfaces:CFArray = CNCopySupportedInterfaces() {
                for i in 0..<CFArrayGetCount(interfaces){
                    let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                    let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                    let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                    if unsafeInterfaceData != nil {
                        let interfaceData = unsafeInterfaceData! as Dictionary?
                        for dictData in interfaceData! {
                            if dictData.key as! String == "SSID" {
                                currentSSID = dictData.value as! String
                            }
                        }
                    }
                }
            }
            
            return currentSSID
        }
    }
}
