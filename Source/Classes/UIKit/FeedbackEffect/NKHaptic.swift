//
//  NKHaptic.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/9/18.
//

import Foundation
import UIKit

public enum NKHapticError: Error {
    case notSupportedByOS
    case notSupportedByDevice
    case notSupported
}

/// Impact feedback styles
///
/// - light: A impact feedback between small, light user interface elements.
/// - medium: A impact feedback between moderately sized user interface elements.
/// - heavy: A impact feedback between large, heavy user interface elements.
public enum NKHapticImpactStyle: Equatable {
    case light
    case medium
    case heavy
    
    @available(iOS 13.0, *)
    case soft
    
    @available(iOS 13.0, *)
    case rigid
    
    @available(iOS 13.0, *)
    case impactWithIntensity(intensity: CGFloat)
}

/// Notification feedback types
///
/// - success: A notification feedback, indicating that a task has completed successfully.
/// - warning: A notification feedback, indicating that a task has produced a warning.
/// - error: A notification feedback, indicating that a task has failed.
public enum NKHapticNotificationType {
    case success, warning, error
}


/// Generates iOS Device vibrations by UIFeedbackGenerator.
/*
 使用说明
 NKHaptic.impact.feedback(.light)
 NKHaptic.selection.feedback()
 NKHaptic.notification.feedback(.error)
 */
@available(iOS 10.0, *)
open class NKHaptic {
    public static let impact: NKHapticImpact = .init()
    public static let selection: NKHapticSelection = .init()
    public static let notification: NKHapticNotification = .init()
    
    /// Wrapper of `UIImpactFeedbackGenerator`
    open class NKHapticImpact {
        
        private var style: NKHapticImpactStyle = .light
        private var generator: Any? = NKHapticImpact.makeGenerator(.light)
        
        private static func makeGenerator(_ style: NKHapticImpactStyle) -> Any? {
            guard #available(iOS 10.0, *) else { return nil }
            
            let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
            switch style {
            case .light:
                feedbackStyle = .light
            case .medium:
                feedbackStyle = .medium
            case .heavy:
                feedbackStyle = .heavy
            case .soft:
                feedbackStyle = .soft
            case .rigid:
                feedbackStyle = .rigid
            case .impactWithIntensity(let intensity):
                feedbackStyle = .light
            }
            let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
            // 提前 prepare()
            generator.prepare()
            return generator
        }
        
        private func updateGeneratorIfNeeded(_ style: NKHapticImpactStyle) {
            guard self.style != style else { return }
            generator = NKHapticImpact.makeGenerator(style)
            self.style = style
        }
        
        public func feedback(_ style: NKHapticImpactStyle) {
            guard #available(iOS 10.0, *), NKDevice.current.isHapticFeedbackCapable  else { return }
            updateGeneratorIfNeeded(style)
            guard let generator = generator as? UIImpactFeedbackGenerator else { return }
            generator.impactOccurred()
            generator.prepare()
        }
        
        /// 触感反馈
        /// - Parameter intensity: [0,1]
        @available(iOS 13.0, *)
        public func feedback(intensity: CGFloat) {
            guard #available(iOS 10.0, *), NKDevice.current.isHapticFeedbackCapable  else { return }
            guard let generator = generator as? UIImpactFeedbackGenerator else { return }
            generator.impactOccurred(intensity: intensity)
            generator.prepare()
        }
        
        public func prepare(_ style: NKHapticImpactStyle) {
            guard #available(iOS 10.0, *), NKDevice.current.isHapticFeedbackCapable  else { return }
            updateGeneratorIfNeeded(style)
            guard let generator = generator as? UIImpactFeedbackGenerator else { return }
            generator.prepare()
        }
    }
    
    
    /// Wrapper of `UISelectionFeedbackGenerator`
    open class NKHapticSelection {
        private var generator: Any? = {
            guard #available(iOS 10.0, *) else { return nil }
            let generator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
            generator.prepare()
            return generator
        }()
        
        public func feedback() {
            guard #available(iOS 10.0, *),
                  let generator = generator as? UISelectionFeedbackGenerator else { return }
            
            generator.selectionChanged()
            generator.prepare()
        }
        
        public func prepare() {
            guard #available(iOS 10.0, *), NKDevice.current.isHapticFeedbackCapable,
                  let generator = generator as? UISelectionFeedbackGenerator else { return }
            generator.prepare()
        }
    }
    
    
    /// Wrapper of `UINotificationFeedbackGenerator`
    open class NKHapticNotification {
        
        private var generator: Any? = {
            guard #available(iOS 10.0, *) else { return nil }
            let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
            generator.prepare()
            return generator
        }()
        
        public func feedback(_ type: NKHapticNotificationType) {
            guard #available(iOS 10.0, *), NKDevice.current.isHapticFeedbackCapable,
                  let generator = generator as? UINotificationFeedbackGenerator else { return }
            
            let feedbackType: UINotificationFeedbackGenerator.FeedbackType
            switch type {
            case .success:
                feedbackType = .success
            case .warning:
                feedbackType = .warning
            case .error:
                feedbackType = .error
            }
            generator.notificationOccurred(feedbackType)
            generator.prepare()
        }
        
        public func prepare() {
            guard #available(iOS 10.0, *), NKDevice.current.isHapticFeedbackCapable,
                  let generator = generator as? UINotificationFeedbackGenerator else { return }
            generator.prepare()
        }
    }
}


/*
 iOS 振动设计与落地全解析：https://zhuanlan.zhihu.com/p/342443635
 
 功能的核心由 UIFeedbackGenerator 提供，不过这只是一个抽象类 (abstract class) —— 你真正需要关注的三个类是 UINotificationFeedbackGenerator，UIImpactFeedbackGenerator，和 UISelectionFeedbackGenerator
 
 UINotificationFeedbackGenerator 让你可以根据三种系统事件：error，success，和 warning 来产生反馈。
 特点：此 API 的三个类型都是连续振动多次，常应用于成功、警告、失败的场景；
 案例：a.人脸识别成功；b.摇动撤销；c.人脸识别失败、锁屏后输入密码错误。
 
 
 
 UIImpactFeedbackGenerator，它可以产生三种不同程度的、 Apple 所说的“物理与视觉相得益彰的体验”。最后一个，
 去掉连续振动的类型，全部 API 中单次振动的振感从小到大的排序为：
 UISelectionFeedbackGenerator（微弱）
 UIImpactFeedbackGenerator-light（适中）
 UIImpactFeedbackGenerator-medium（适中）
 UIImpactFeedbackGenerator-heavy（强烈）
 3D touch-peek（强烈）
 3D touch-poop（强烈）
 Vibration（嘈杂）
 
 
 UISelectionFeedbackGenerator 会在用户改变他们在屏幕上的选择（例如滑动一个转盘选择器）的时候被触发，产生一个相应的反馈。
 */
