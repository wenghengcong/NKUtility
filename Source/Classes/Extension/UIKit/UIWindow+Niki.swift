//
//  UIWindow+Niki.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/15.
//

#if canImport(UIKit) && os(iOS)
import UIKit

public extension UIWindow {
    
    static func safeAreaInsetTop() -> CGFloat {
        var height: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            if let window = UIWindow.topWindow() {
                height += window.safeAreaInsets.top
            }
        }
        return height
    }
    
    static func safeAreaInsetBottom() -> CGFloat {
        var height: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            if let window = UIWindow.topWindow() {
                height += window.safeAreaInsets.bottom
            }
        }
        return height
    }
    
    static func topWindow() -> UIWindow? {
        var topWindow: UIWindow?
        if #available(iOS 13, *){
            topWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        } else {
            topWindow = UIApplication.shared.keyWindow
        }
        return topWindow
    }
    
    static func topViewController() -> UIViewController? {
        let kwindow = topWindow()
        if kwindow == nil {
            return nil
        }
        var top = kwindow!.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
    
    /// switch current root view controller
    ///
    /// - Parameters:
    ///   - viewController: new view controller.
    ///   - animated: set to true to animate view controller change (default is true).
    ///   - duration: animation duration in seconds (default is 0.5).
    ///   - options: animation options (default is .transitionFlipFromRight).
    ///   - completion: optional completion handler called after view controller is changed.
    func switchRootViewController(to viewController: UIViewController,
                                  animated: Bool = true,
                                  duration: TimeInterval = 0.5,
                                  options: AnimationOptions = .transitionFlipFromRight,
                                  completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
}

#endif

