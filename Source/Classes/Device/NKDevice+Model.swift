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
}
