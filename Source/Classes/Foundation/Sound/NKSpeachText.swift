//
//  NKSpeachText.swift
//  NKUtility
//
//  Created by Nemo on 2022/9/28.
//

import Foundation
import AVFoundation

public class NKSpeachText {
    
    public static let shared = NKSpeachText()
    var speechSynthesizer = AVSpeechSynthesizer()
    
    private init() {
        
    }
    
    func prepare() {
        
    }
    
    public func stopSpechText() {
        self.speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    public func spechText(text: String, rate:Float?) {
        let string = text
        let utterance = AVSpeechUtterance(string: string)
        
        if let r = rate {
            utterance.rate = r
        }
        utterance.pitchMultiplier = 0.8;  //改变音调
        utterance.postUtteranceDelay = 0.15;  //播放下一句是有个短时间的暂停
        
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")

        self.speechSynthesizer.speak(utterance)
    }
}
