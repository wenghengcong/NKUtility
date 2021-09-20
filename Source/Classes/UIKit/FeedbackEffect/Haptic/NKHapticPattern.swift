//
//  NKHapticPattern.swift
//  NKUtility
//
//  Created by Hunt on 2021/9/19.
//

import Foundation

/// 触觉反馈表达式
private enum NKHapticPatternChar: Character {
    /// 暂停
    case wait = "-"
    /// 重
    case heavy = "O"
    /// 中
    case medium = "o"
    /// 轻
    case light = "."
}

public extension NKHaptic {
    
    static let queue: OperationQueue = .serial
        
    static func play(_ notes: [NKHapticNode]) {
        guard #available(iOS 10, *), queue.operations.isEmpty else { return }
        
        for note in notes {
            let operation = note.operation
            if let last = queue.operations.last {
                operation.addDependency(last)
            }
            queue.addOperation(operation)
        }
    }
    
    static func play(_ pattern: String, delay: TimeInterval) {
        let notes = pattern.compactMap { NKHapticNode($0, delay: delay) }
        play(notes)
    }
}

public enum NKHapticNode {
    case haptic(NKHaptic)
    case wait(TimeInterval)
    
    init?(_ char: Character, delay: TimeInterval) {
        let patternChar = NKHapticPatternChar(rawValue: char)
        switch patternChar {
        case .heavy:
            self = .haptic(.impact(.heavy))
        case .medium:
            self = .haptic(.impact(.medium))
        case .light:
            self = .haptic(.impact(.light))
        case .wait:
            self = .wait(delay)
        default:
            return nil
        }
    }
    
    var operation: Operation {
        switch self {
        case .haptic(let haptic):
            return NKHapticOperation(haptic)
        case .wait(let interval):
            return NKHapticWaitOperation(interval)
        }
    }
}

class NKHapticOperation: Operation {
    let haptic: NKHaptic
    
    init(_ haptic: NKHaptic) {
        self.haptic = haptic
    }
    
    override func main() {
        DispatchQueue.main.sync {
            self.haptic.feedback()
        }
    }
}

class NKHapticWaitOperation: Operation {
    let duration: TimeInterval
    init(_ duration: TimeInterval) {
        self.duration = duration
    }
    override func main() {
        Thread.sleep(forTimeInterval: duration)
    }
}
