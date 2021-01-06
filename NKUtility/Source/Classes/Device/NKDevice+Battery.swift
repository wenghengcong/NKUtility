//
//  NKDevice+Battery.swift
//  NKDevice
//
//  Created by Andrea Mario Lufino on 10/11/2019.
//

import Foundation
import UIKit

#if os(iOS) || os(watchOS)
public extension NKDevice {
    
    // MARK: Battery
    /// The state of the battery
    var batteryState: BatteryState? {
        return NKDevice.BatteryState()
    }
    
    /// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
    var batteryLevel: Int? {
        switch BatteryState() {
        case .unknown: return nil
        case .charging(let value): return value
        case .full: return 100
        case .unplugged(let value): return value
        }
    }
    
    /**
     This enum describes the state of the battery.
     
     - Full:      The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
     - Charging:  The device is plugged into power and the battery is less than 100% charged.
     - Unplugged: The device is not plugged into power; the battery is discharging.
     */
    enum BatteryState: CustomStringConvertible, Equatable {
        
        case unknown
        /// The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
        case full
        /// The device is plugged into power and the battery is less than 100% charged.
        /// The associated value is in percent (0-100).
        case charging(Int)
        /// The device is not plugged into power; the battery is discharging.
        /// The associated value is in percent (0-100).
        case unplugged(Int)
        
        #if os(iOS)
        fileprivate init() {
            let wasBatteryMonitoringEnabled = UIDevice.current.isBatteryMonitoringEnabled
            UIDevice.current.isBatteryMonitoringEnabled = true
            let batteryLevel = Int(round(UIDevice.current.batteryLevel * 100)) // round() is actually not needed anymore since -[batteryLevel] seems to always return a two-digit precision number
            // but maybe that changes in the future.
            switch UIDevice.current.batteryState {
            case .charging: self = .charging(batteryLevel)
            case .full: self = .full
            case .unplugged: self = .unplugged(batteryLevel)
            case .unknown: self = .full // Should never happen since `batteryMonitoring` is enabled.
            @unknown default:
                self = .full // To cover any future additions for which DeviceKit might not have updated yet.
            }
            UIDevice.current.isBatteryMonitoringEnabled = wasBatteryMonitoringEnabled
        }
        #elseif os(watchOS)
        fileprivate init() {
            let wasBatteryMonitoringEnabled = WKInterfaceDevice.current().isBatteryMonitoringEnabled
            WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
            let batteryLevel = Int(round(WKInterfaceDevice.current().batteryLevel * 100)) // round() is actually not needed anymore since -[batteryLevel] seems to always return a two-digit precision number
            // but maybe that changes in the future.
            switch WKInterfaceDevice.current().batteryState {
            case .charging: self = .charging(batteryLevel)
            case .full: self = .full
            case .unplugged: self = .unplugged(batteryLevel)
            case .unknown: self = .full // Should never happen since `batteryMonitoring` is enabled.
            @unknown default:
                self = .full // To cover any future additions for which DeviceKit might not have updated yet.
            }
            WKInterfaceDevice.current().isBatteryMonitoringEnabled = wasBatteryMonitoringEnabled
        }
        #endif
        
        @available(iOS 9.0,*)
        /// Check if the low power mode is currently enabled (iOS 9 and above).
        public var lowPowerMode: Bool {
            return ProcessInfo.processInfo.isLowPowerModeEnabled
        }
        
        /// Provides a textual representation of the battery state.
        /// Examples:
        /// ```
        /// Battery level: 90%, device is plugged in.
        /// Battery level: 100 % (Full), device is plugged in.
        /// Battery level: \(batteryLevel)%, device is unplugged.
        /// ```
        public var description: String {
            switch self {
            case .unknown: return "Unknown state"
            case .charging(let batteryLevel): return "Battery level: \(batteryLevel)%, device is plugged in."
            case .full: return "Battery level: 100 % (Full), device is plugged in."
            case .unplugged(let batteryLevel): return "Battery level: \(batteryLevel)%, device is unplugged."
            }
        }
        
    }
}
#endif

// MARK: NKDevice.Batterystate: Comparable
#if os(iOS) || os(watchOS)
@available(iOS 8.0, watchOS 4.0, *)
extension NKDevice.BatteryState: Comparable {
    /// Tells if two battery states are equal.
    ///
    /// - parameter lhs: A battery state.
    /// - parameter rhs: Another battery state.
    ///
    /// - returns: `true` iff they are equal, otherwise `false`
    public static func == (lhs: NKDevice.BatteryState, rhs: NKDevice.BatteryState) -> Bool {
        return lhs.description == rhs.description
    }
    
    /// Compares two battery states.
    ///
    /// - parameter lhs: A battery state.
    /// - parameter rhs: Another battery state.
    ///
    /// - returns: `true` if rhs is `.Full`, `false` when lhs is `.Full` otherwise their battery level is compared.
    public static func < (lhs: NKDevice.BatteryState, rhs: NKDevice.BatteryState) -> Bool {
        switch (lhs, rhs) {
        case (.full, _): return false // return false (even if both are `.Full` -> they are equal)
        case (_, .full): return true // lhs is *not* `.Full`, rhs is
        case let (.charging(lhsLevel), .charging(rhsLevel)): return lhsLevel < rhsLevel
        case let (.charging(lhsLevel), .unplugged(rhsLevel)): return lhsLevel < rhsLevel
        case let (.unplugged(lhsLevel), .charging(rhsLevel)): return lhsLevel < rhsLevel
        case let (.unplugged(lhsLevel), .unplugged(rhsLevel)): return lhsLevel < rhsLevel
        default: return false // compiler won't compile without it, though it cannot happen
        }
    }
}
#endif
