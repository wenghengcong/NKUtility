//
//  UIViewController+Niki.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/15.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Properties

public extension UIViewController {
    /// SwifterSwift: Check if ViewController is onscreen and not hidden.
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return isViewLoaded && view.window != nil
    }
}

// MARK: - Dark Mode
public extension UIViewController {
    /// 暗黑模式
    public var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            let isDark = (UIScreen.main.traitCollection.userInterfaceStyle == .dark)
            return isDark
        } else {
            return false
        }
    }

    /**
     returns true only if the viewcontroller is presented.
     form: https://stackoverflow.com/questions/23620276/how-to-check-if-a-view-controller-is-presented-modally-or-pushed-on-a-navigation
     */
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            if let parent = parent, !(parent is UINavigationController || parent is UITabBarController) {
                return false
            }
            return true
        } else if let navController = navigationController, navController.presentingViewController?.presentedViewController == navController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    /// 检查当前是否是暗黑模式下
    /// - Parameters:
    ///   - lightHandler: <#lightHandler description#>
    ///   - darkHandler: <#darkHandler description#>
    public func detectDarkMode(lightHandler: ((UIUserInterfaceStyle) -> Void)? = nil,
                               darkHandler: ((UIUserInterfaceStyle) -> Void)? = nil) {
        let style = traitCollection.userInterfaceStyle
        switch style {
        case .light, .unspecified:
            NKlogger.debug("light mode now")
            if let handler = lightHandler {
                handler(style)
            }
        case .dark:
            NKlogger.debug("dark mode now")
            if let handler = darkHandler {
                handler(style)
            }
        @unknown default:
            fatalError()
        }
    }
}

// MARK: - Navigation bar
public extension UIViewController {
    
    /// Hide the navigation bar on the this view controller
    /// - Parameter animated: <#animated description#>
    func hideNavigationBar(animated: Bool){
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    /// Show the navigation bar on other view controllers
    /// - Parameter animated: <#animated description#>
    func showNavigationBar(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Methods

public extension UIViewController {
    /// SwifterSwift: Instantiate UIViewController from storyboard
    ///
    /// - Parameters:
    ///   - storyboard: Name of the storyboard where the UIViewController is located
    ///   - bundle: Bundle in which storyboard is located
    ///   - identifier: UIViewController's storyboard identifier
    /// - Returns: Custom UIViewController instantiated from storyboard
    class func instantiate(from storyboard: String = "Main", bundle: Bundle? = nil, identifier: String? = nil) -> Self {
        let viewControllerIdentifier = identifier ?? String(describing: self)
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        guard let viewController = storyboard
                .instantiateViewController(withIdentifier: viewControllerIdentifier) as? Self else {
            preconditionFailure(
                "Unable to instantiate view controller with identifier \(viewControllerIdentifier) as type \(type(of: self))")
        }
        return viewController
    }

    /// SwifterSwift: Assign as listener to notification.
    ///
    /// - Parameters:
    ///   - name: notification name.
    ///   - selector: selector to run with notified.
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    /// SwifterSwift: Unassign as listener to notification.
    ///
    /// - Parameter name: notification name.
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }

    /// SwifterSwift: Unassign as listener from all notifications.
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    /// SwifterSwift: Helper method to display an alert on any UIViewController subclass. Uses UIAlertController to show an alert
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message/body of the alert
    ///   - buttonTitles: (Optional)list of button titles for the alert. Default button i.e "OK" will be shown if this paramter is nil
    ///   - highlightedButtonIndex: (Optional) index of the button from buttonTitles that should be highlighted. If this parameter is nil no button will be highlighted
    ///   - completion: (Optional) completion block to be invoked when any one of the buttons is tapped. It passes the index of the tapped button as an argument
    /// - Returns: UIAlertController object (discardable).
    @discardableResult
    func showAlert(
        title: String?,
        message: String?,
        buttonTitles: [String]? = nil,
        highlightedButtonIndex: Int? = nil,
        completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }

        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }

    /// SwifterSwift: Helper method to add a UIViewController as a childViewController.
    ///
    /// - Parameters:
    ///   - child: the view controller to add as a child
    ///   - containerView: the containerView for the child viewcontroller's root view.
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// SwifterSwift: Helper method to remove a UIViewController from its parent.
    func removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    #if os(iOS)
    /// SwifterSwift: Helper method to present a UIViewController as a popover.
    ///
    /// - Parameters:
    ///   - popoverContent: the view controller to add as a popover.
    ///   - sourcePoint: the point in which to anchor the popover.
    ///   - size: the size of the popover. Default uses the popover preferredContentSize.
    ///   - delegate: the popover's presentationController delegate. Default is nil.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - completion: The block to execute after the presentation finishes. Default is nil.
    func presentPopover(
        _ popoverContent: UIViewController,
        sourcePoint: CGPoint,
        size: CGSize? = nil,
        delegate: UIPopoverPresentationControllerDelegate? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil) {
        popoverContent.modalPresentationStyle = .popover

        if let size = size {
            popoverContent.preferredContentSize = size
        }

        if let popoverPresentationVC = popoverContent.popoverPresentationController {
            popoverPresentationVC.sourceView = view
            popoverPresentationVC.sourceRect = CGRect(origin: sourcePoint, size: .zero)
            popoverPresentationVC.delegate = delegate
        }

        present(popoverContent, animated: animated, completion: completion)
    }
    #endif
}

public extension UIViewController {
    
    static func push(_ viewController: UIViewController, animated: Bool = true) {
        topViewController()?.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    static func present(_ viewControllerToPresent: UIViewController, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        topViewController()?.navigationController?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    static func topViewController() -> UIViewController? {
        return UIWindow.topViewController()
    }
    
    func topViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topViewController()
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topViewController()
            }
            return tabBarController.topViewController()
        }

        else if let presentedViewController = self.presentedViewController {
            return presentedViewController.topViewController()
        }
        
        else {
            return self
        }
    }
    
    var safeAreaInsetTop: CGFloat {
        return UIWindow.safeAreaInsetTop()
    }
    
    var safeAreaInsetBottom: CGFloat {
        return UIWindow.safeAreaInsetBottom()
    }
    
    
    /// 顶部导航栏高度
    var topBarHeight: CGFloat {
        // 44
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 13.0, *) {
            // 41
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        return top
    }
    
    /// 底部标签栏高度
    var tabBarHeight: CGFloat {
        var height: CGFloat = 0.0
        
        var hasTabBar = !hidesBottomBarWhenPushed
        if let tabBarVc = self.navigationController?.tabBarController {
            height = tabBarVc.tabBar.height
        } else if let defaultVc = self.tabBarController {
            height = defaultVc.tabBar.height
        }
        return height
    }
    
    /// 可见区域，除去导航栏和标签栏
    var visibleHeight: CGFloat {
        let topAndBot = topBarHeight + tabBarHeight
        let visible = UIScreen.mainHeight-topAndBot
        return visible
    }
}

#endif
