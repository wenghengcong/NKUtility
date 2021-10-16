//
//  UIWindow+Niki.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/15.
//

#if canImport(UIKit) && os(iOS)
import UIKit

@available(iOS 13.0, *)
private extension UIScene.ActivationState {
    var sortPriority: Int {
        switch self {
        case .foregroundActive: return 1
        case .foregroundInactive: return 2
        case .background: return 3
        case .unattached: return 4
        @unknown default: return 5
        }
    }
}
extension UIWindow {
    #if !SWIFTMESSAGES_APP_EXTENSIONS
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .sorted { $0.activationState.sortPriority < $1.activationState.sortPriority }
                .compactMap { $0 as? UIWindowScene }
                .compactMap { $0.windows.first { $0.isKeyWindow } }
                .first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    #endif
}


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

    static func pushVC(_ viewController: UIViewController, animated: Bool = true) {
        topViewController()?.navigationController?.pushViewController(viewController, animated: animated)
    }

    static func presentVC(_ viewControllerToPresent: UIViewController, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        topViewController()?.navigationController?.present(viewControllerToPresent, animated: flag, completion: completion)
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

