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
@available(iOS 10.0, *)
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
@available(iOS 10.0, *)
public enum NKHapticNotificationType {
    case success
    case warning
    case error
}


/// Generates iOS Device vibrations by UIFeedbackGenerator.
/*
 使用说明
 方法一：
 NKHaptic.Impact.feedback(.light)
 NKHaptic.Selection.feedback()
 NKHaptic.Notification.feedback(.error)
 
 方法二：
 NKHaptic.impact(.light).feedback()

 方法三：
 NKHaptic.play("..oO-Oo..", delay: 0.1)
 NKHaptic.play([.haptic(.impact(.light)), .haptic(.impact(.heavy)), .wait(0.1), .haptic(.impact(.heavy)), .haptic(.impact(.light))])
 
 方法四：快捷方法
 NKHaptic.lightImpact
 
 reference: https://github.com/efremidze/Haptica
 https://github.com/iSapozhnik/Haptico
 */
@available(iOS 10.0, *)
public enum NKHaptic {

    case impact(NKHapticImpactStyle)
    case notification(NKHapticNotificationType)
    case selection
    
    public static let Impact: NKHapticImpact = .init()
    public static let Selection: NKHapticSelection = .init()
    public static let Notification: NKHapticNotification = .init()
        
    // trigger
    public func feedback() {
        guard #available(iOS 10, *) else { return }
        guard NKHaptic.enable else {
            return
        }
        switch self {
        case .impact(let style):
            NKHaptic.Impact.feedback(style)
        case .notification(let type):
            NKHaptic.Notification.feedback(type)
        case .selection:
            NKHaptic.Selection.feedback()
        }
    }
    
    // MARK: - Impact
    public static func lightImpact() {
        NKHaptic.Impact.feedback(.light)
    }
    
    public static func mediumImpact() {
        NKHaptic.Impact.feedback(.medium)
    }
    
    public static func heavyImpact() {
        NKHaptic.Impact.feedback(.heavy)
    }
    
    // MARK: - Selection
    public static func selectionImpact() {
        NKHaptic.Selection.feedback()
    }
    
    // MARK: - Notification
    public static func errorNotification() {
        NKHaptic.Notification.feedback(.error)
    }
    
    public static func successNotification() {
        NKHaptic.Notification.feedback(.success)
    }
    
    public static func warningNotification() {
        NKHaptic.Notification.feedback(.warning)
    }
    
    ///  用户信息，用于区分不同用户的存储
    public static var userinfo = "NKUtility"
    
    private static func generateKey() -> String {
        let ori = "com.niki.taptic.enable"
        let result = "\(NKHaptic.userinfo)_\(ori))"
        return result
    }
    
    /// 是否启用触感
    public static var enable: Bool {
        set {
            // 取反存储
            let defaults = UserDefaults.standard
            defaults.setValue(!newValue, forKey: generateKey())
            defaults.synchronize()
        }
        get {
            let defaults = UserDefaults.standard
            let isEnable = !defaults.bool(forKey: generateKey())
            return isEnable
        }
    }
    
}

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
        guard #available(iOS 10.0, *),
              NKDevice.current.isHapticFeedbackCapable,
              NKHaptic.enable else { return }
        updateGeneratorIfNeeded(style)
        guard let generator = generator as? UIImpactFeedbackGenerator else { return }
        generator.impactOccurred()
        generator.prepare()
    }
    
    /// 触感反馈
    /// - Parameter intensity: [0,1]
    @available(iOS 13.0, *)
    public func feedback(intensity: CGFloat) {
        guard #available(iOS 10.0, *),
              NKDevice.current.isHapticFeedbackCapable,
              NKHaptic.enable else { return }
        guard let generator = generator as? UIImpactFeedbackGenerator else { return }
        generator.impactOccurred(intensity: intensity)
        generator.prepare()
    }
    
    public func prepare(_ style: NKHapticImpactStyle) {
        guard #available(iOS 10.0, *),
              NKDevice.current.isHapticFeedbackCapable,
              NKHaptic.enable else { return }
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
              NKHaptic.enable,
              let generator = generator as? UISelectionFeedbackGenerator else { return }
        generator.selectionChanged()
        generator.prepare()
    }
    
    public func prepare() {
        guard #available(iOS 10.0, *),
              NKDevice.current.isHapticFeedbackCapable,
              NKHaptic.enable,
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
        guard #available(iOS 10.0, *),
              NKDevice.current.isHapticFeedbackCapable,
              NKHaptic.enable,
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
        guard #available(iOS 10.0, *),
              NKDevice.current.isHapticFeedbackCapable,
              NKHaptic.enable,
              let generator = generator as? UINotificationFeedbackGenerator else { return }
        generator.prepare()
    }
}




/*
 iOS 振动设计与落地全解析：https://zhuanlan.zhihu.com/p/342443635
 
 功能的核心由 UIFeedbackGenerator 提供，不过这只是一个抽象类 (abstract class) —— 你真正需要关注的三个类是 UINotificationFeedbackGenerator，UIImpactFeedbackGenerator，和 UISelectionFeedbackGenerator
 
 >>>>> UIImpactFeedbackGenerator
 a.微弱短振-Light（表示较小的界面元素的物理碰撞或互动时）
 b.中等短振-Medium（表示中等大小的界面元素的物理碰撞或互动时）
 c.明显短振-Heavy（表示较大的界面元素的物理碰撞或互动时）
 
 特点：常用于下拉刷新和手势反馈；
 适配：只支持 iPhone 7 及以上机型且系统需 iOS 10 及以上，如果机型或系统不支持将不振动；
 案例：a.使用iOS 的时钟调节时间刻度、iOS 开关控件的开启和关闭；
 b.支付宝我的应用编辑页中长按某个应用；

 c.支付宝首页长按功能区触发二级操作。Heavy 与 3D touch 振感中的 Peek 极为接近，使用Peek的案例换用 Heavy 也是可行的；


 
 >>>>> UINotificationFeedbackGenerator 让你可以根据三种系统事件：error，success，和 warning 来产生反馈。
 成功：Success。振幅从低到高，传递积极的信号，隐喻本次操作结果为成功。案例：人脸识别成功。
 警告：Warning。振幅从高到底，传递消极的信号，隐喻本次操作有风险，需要确认。案例：摇动以撤销。
 失败：Error。振幅先变高再变低，隐喻本次操作结果为失败。案例：人脸识别失败。


 特点：此 API 的三个类型都是连续振动多次，常应用于成功、警告、失败的场景；
 案例：a.人脸识别成功；b.摇动撤销；c.人脸识别失败、锁屏后输入密码错误。

 
 >>>>> UIImpactFeedbackGenerator，它可以产生三种不同程度的、 Apple 所说的“物理与视觉相得益彰的体验”。最后一个，
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
