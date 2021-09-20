//
//  NKFeedback.swift
//  Alamofire
//
//  Created by Hunt on 2021/9/20.
//

import Foundation

/// 开发：https://developer.apple.com/documentation/uikit/animation_and_haptics
/// 设计：https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/haptics/
public class NKFeedback {
    
    public static func feedback(_ file: String? = nil,
                                haptic: NKHaptic? = nil) {
        if let fi = file {
            NKSound.play(file: fi)
        }
        haptic?.feedback()
    }
    
    public static func feedback(_ url: URL? = nil,
                                haptic: NKHaptic? = nil) {
        if let internal_url = url {
            NKSound.play(url: internal_url)
        }
        haptic?.feedback()
    }
    
    public static func feedback(_ sound: NKSound? = nil,
                                haptic: NKHaptic? = nil) {
        sound?.play()
        haptic?.feedback()
    }
    
    public static func feedback(_ sysSound: NKSystemSound = .tock,
                                haptic: NKHaptic? = nil) {
        NKSound.play(sysSound: sysSound)
        haptic?.feedback()
    }
}
