//
//  UIWindow+Niki.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/15.
//

import UIKit

public extension UIWindow {
    
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
}
