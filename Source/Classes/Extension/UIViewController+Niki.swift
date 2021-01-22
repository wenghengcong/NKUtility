//
//  UIViewController+Niki.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/15.
//

import UIKit

public extension UIViewController {
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
}
