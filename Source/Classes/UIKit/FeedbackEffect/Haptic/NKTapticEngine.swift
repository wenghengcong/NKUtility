//
//  NKTapticEngine.swift
//  NKUtility
//
//  Created by Hunt on 2021/9/19.
//

import Foundation
import UIKit
import AudioToolbox.AudioServices


/// 震动马达
final class NKTapticEngine: NSObject {
    struct SoundID {
        static let successID = SystemSoundID(1519)
        static let warningID = SystemSoundID(1102)
        static let errorID = SystemSoundID(1107)
    }
        
    func feedback(_ notification: NKHapticNotificationType) {
        guard #available(iOS 9, *) else { return }
        guard NKDevice.current.isTapticEngineCapable else { return }
        
        switch notification {
        case .success:
            AudioServicesPlaySystemSoundWithCompletion(SoundID.successID, nil)
        case .warning:
            AudioServicesPlaySystemSoundWithCompletion(SoundID.warningID, nil)
        case .error:
            AudioServicesPlaySystemSoundWithCompletion(SoundID.errorID, nil)
        }
    }
}
