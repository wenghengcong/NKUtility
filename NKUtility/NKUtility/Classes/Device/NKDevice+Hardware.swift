//
//  NKDevice+Hardware.swift
//  NKDevice
//
//  Created by Andrea Mario Lufino on 10/11/2019.
//

import AVFoundation
import CoreMotion
import CoreTelephony
import ExternalAccessory
import Foundation
import SystemConfiguration.CaptiveNetwork
import UIKit

extension NKDevice {
    
    // MARK: Hardware
    
    /// Hardware information.
    public struct Hardware {
        
        /// Number of processors.
        public static var processorsNumber: Int {
            
            return ProcessInfo().processorCount
        }
        
        /// Number of active processors.
        public static var activeProcessorsNumber: Int {
            
            return ProcessInfo().activeProcessorCount
        }
        
        /// Physical memory of the device in megabytes.
        public static func physicalMemory(with sizeScale: MeasureUnit = .gigabytes) -> Double {
            
            let physicalMemory = Float(ProcessInfo().physicalMemory)
            
            switch sizeScale {
            case .bytes:
                return Double(physicalMemory)
            case .kilobytes:
                return Double(physicalMemory / 1024)
            case .megabytes:
                return Double(physicalMemory / 1024 / 1024)
            case .gigabytes:
                return Double(physicalMemory / 1024 / 1024 / 1024)
            case .percentage:
                return 100.0
            }
        }

        /// The current boot time expressed in seconds.
        public static var bootTime: TimeInterval {
            
            return ProcessInfo().systemUptime
        }
        
        
        // MARK: Accessory
        
        /// Accessory information
        public struct Accessory {
            
            /// The number of connected accessories
            public static var count: Int {
                
                return EAAccessoryManager.shared().connectedAccessories.count
            }
            
            /// The names of the attacched accessories. If no accessory is attached the array will be empty, but not nil
            public static var connectedAccessoriesNames: [String] {
                
                var theNames: [String] = []
                
                for accessory in EAAccessoryManager.shared().connectedAccessories {
                    
                    theNames.append(accessory.name)
                }
                
                return theNames
            }
            
            /// The accessories connected and available to use for the app as EAAccessory objects
            public static var connectedAccessories: [EAAccessory] {
                
                return EAAccessoryManager.shared().connectedAccessories
            }
            
            /// Check if headphones are plugged in
            public static var isHeadsetPluggedIn: Bool {
                // !!!: Thanks to Antonio E., this code is coming from this SO answer : http://stackoverflow.com/a/21382748/588967 . I've only translated it in Swift
                let route = AVAudioSession.sharedInstance().currentRoute
                
                for desc in route.outputs {
                    if desc.portType == AVAudioSession.Port.headphones {
                        return true
                    }
                }
                return false
            }
        }
        
        
        // MARK: Sensors
        
        /// Get info about the sensors
        public struct Sensors {
            
            /// Check if the accelerometer is available
            public static var isAccelerometerAvailable: Bool {
                
                return CMMotionManager.init().isAccelerometerAvailable
            }
            
            /// Check if gyroscope is available
            public static var isGyroAvailable: Bool {
                
                return CMMotionManager.init().isGyroAvailable
            }
            
            /// Check if magnetometer is available
            public static var isMagnetometerAvailable: Bool {
                
                return CMMotionManager.init().isMagnetometerAvailable
            }
            
            /// Check if device motion is available
            public static var isDeviceMotionAvailable: Bool {
                
                return CMMotionManager.init().isDeviceMotionAvailable
            }
        }
    }
}
