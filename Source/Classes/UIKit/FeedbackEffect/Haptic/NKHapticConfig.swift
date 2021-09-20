//
//  NKHapticConfig.swift
//  NKUtility
//
//  Created by Hunt on 2021/9/19.
//

import Foundation
import SwiftyUserDefaults

private func generateKey(ori: String) -> String {
    let result = "\(NKHapticConfig.userinfo)_\(ori))"
    return result
}

extension DefaultsKeys {
    var hapticEnable: DefaultsKey<String?> {.init("") }
    
}

public class NKHapticConfig: NSObject {
    
    public static let shared = NKHapticConfig()
    ///  用户信息，用于区分不同用户的存储
    public static var userinfo = "NKUtility"
    
    /// 是否启用触感
    public static var enable: Bool {
        set {
            let defaults = UserDefaults.standard
            defaults.setValue(newValue, forKey: generateKey(ori: "hapticEnable"))
            defaults.synchronize()
        }
        get {
            let defaults = UserDefaults.standard
            let isEnable = defaults.bool(forKey: generateKey(ori: "hapticEnable")) ?? false
            return isEnable
        }
    }
    
    public override init() {
        
    }
    
    public func setup() {
        NKHapticConfig.enable = true
        
    }
}
