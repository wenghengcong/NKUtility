//
//  NKHapticable.swift
//  NKUtility
//
//  Created by Hunt on 2021/9/19.
//

import Foundation


private var hapticKey: Void?
private var eventKey: Void?
private var targetsKey: Void?


/*
 UIControl 类拓展，不受 NKHapticConfig 影响

 1）button.addHaptic(.selection, forControlEvents: .touchDown)
 2）
 button.isHaptic = true
 button.hapticType = .impact(.light)
 */
public protocol NKHapticable: class {
    func feedback(_ sender: Any)
}

public extension NKHapticable where Self: UIControl {
    public var isHaptic: Bool {
        get {
            guard let actions = actions(forTarget: self, forControlEvent: hapticControlEvents ?? .touchDown) else { return false }
            return !actions.filter { $0 == #selector(feedback).description }.isEmpty
        }
        set {
            if newValue {
                addTarget(self, action: #selector(feedback), for: hapticControlEvents ?? .touchDown)
            } else {
                removeTarget(self, action: #selector(feedback), for: hapticControlEvents ?? .touchDown)
            }
        }
    }
    
    public var hapticType: NKHaptic? {
        get { return getAssociatedObject(&hapticKey) }
        set { setAssociatedObject(&hapticKey, newValue) }
    }
    
    public var hapticControlEvents: UIControl.Event? {
        get { return getAssociatedObject(&eventKey) }
        set { setAssociatedObject(&eventKey, newValue) }
    }
    
    private var hapticTargets: [UIControl.Event: HapticTarget] {
        get { return getAssociatedObject(&targetsKey) ?? [:] }
        set { setAssociatedObject(&targetsKey, newValue) }
    }
    
    public func addHaptic(_ haptic: NKHaptic, forControlEvents events: UIControl.Event) {
        let hapticTarget = HapticTarget(haptic: haptic)
        hapticTargets[events] = hapticTarget
        addTarget(hapticTarget, action: #selector(hapticTarget.feedback), for: events)
    }
    
    public func removeHaptic(forControlEvents events: UIControl.Event) {
        guard let hapticTarget = hapticTargets[events] else { return }
        hapticTargets[events] = nil
        removeTarget(hapticTarget, action: #selector(hapticTarget.feedback), for: events)
    }
    
}

extension UIControl: NKHapticable {
    @objc public func feedback(_ sender: Any) {
        hapticType?.feedback()
    }
}

private class HapticTarget {
    let haptic: NKHaptic
    init(haptic: NKHaptic) {
        self.haptic = haptic
    }
    
    @objc func feedback(_ sender: Any) {
        haptic.feedback()
    }
}
