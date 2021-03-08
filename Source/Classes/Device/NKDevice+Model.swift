//
//  NKDevice+Model.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/31.
//

import Foundation
import UIKit

extension NKDevice {
    public static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    public static func isIPad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }
    
    public static func isIPhone() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return true
        }
        return false
    }
    
    public static func isCarPlay() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .carPlay {
            return true
        }
        return false
    }
    
    @available(iOS 14.0, *)
    public static func isMac() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .mac {
            return true
        }
        return false
    }
    
    public static func isTv() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .tv {
            return true
        }
        return false
    }
}
