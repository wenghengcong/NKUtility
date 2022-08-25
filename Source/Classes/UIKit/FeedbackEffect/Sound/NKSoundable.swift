//
//  NKSoundable.swift
//  Alamofire
//
//  Created by Hunt on 2021/9/20.
//

import Foundation
import AudioToolbox
import AVFoundation

/// 可播放声音的的协议
/// source : https://github.com/efremidze/Peep
public protocol NKSoundable {
    func play(_ completion: (() -> Void)?)
}

public extension NKSound {
    static func play(sound: NKSoundable?) {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
        sound?.play({
            
        })
    }
    
    /// 播放系统声音
    /// - Parameter sysSound: 系统声音
    static func play(sysSound: NKSystemSound) {
        AudioServicesPlaySystemSound(sysSound.rawValue)
    }
}

/*--常用的音频，指定名称---*/

// MARK: - key press
public enum NKKeyPressSound: UInt32 {
    case tap = 1104
}

extension NKKeyPressSound: NKSoundable {
    public func play(_ completion: (() -> Void)?) {
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(rawValue)) {
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}

// MARK: - key press
public enum NKHapticSound: UInt32 {
    case impact = 1520
    case notification = 1521
    case selection = 1519
}

extension NKHapticSound: NKSoundable {
    public func play(_ completion: (() -> Void)?) {
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(rawValue)) {
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
// MARK: - URL
extension URL: NKSoundable {
    public func play(_ completion: (() -> Void)?) {
        let player = AVQueuePlayer.shared
        player.removeAllItems()
        let item = AVPlayerItem(url: self)
        player.insert(item, after: nil)
        player.play()
        
        DispatchQueue.main.async {
            completion?()
        }
    }
}

extension AVQueuePlayer {
    static let shared = AVQueuePlayer()
}
