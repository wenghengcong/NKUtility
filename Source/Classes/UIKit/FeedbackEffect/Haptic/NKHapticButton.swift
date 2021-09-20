//
//  NKHapticButton.swift
//  NKUtility
//
//  Created by Hunt on 2021/9/19.
//

import Foundation

open class NKHapticButton: UIButton {
    
    open func addHapticTarget(_ target: Any?,
                              action: Selector,
                              for controlEvents: UIControl.Event) {
        addTarget(self, action: action, for: controlEvents)
        self.isHaptic = true
        self.hapticType = .impact(.light)
    }
    
    open func addHapticTarget(_ target: Any?,
                              action: Selector,
                              for controlEvents: UIControl.Event,
                              haptic: NKHaptic? = nil) {
        addTarget(self, action: action, for: controlEvents)
        if haptic != nil {
            self.isHaptic = true
            self.hapticType = haptic
        }
    }
}
