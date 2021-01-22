//
//  UIApplication+LinearNetworkActivityIndicator.swift
//  Alamofire
//
//  Created by Hunt on 2021/1/22.
//

import Foundation
import UIKit

public extension UIApplication {
    
    func setIndicator(visible: Bool) {
        if visible {
            showStatusIndicator()
        } else {
            hiddenStatusIndicator()
        }
    }
    
    func showStatusIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hiddenStatusIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

public extension UIApplication {
    @objc final class func configureLinearNetworkActivityIndicatorIfNeeded() {
        #if !targetEnvironment(macCatalyst)
        if #available(iOS 11.0, *) {
            // detect iPhone X
            if let window = UIWindow.topWindow(), window.safeAreaInsets.bottom > 0.0 {
                if UIDevice.current.userInterfaceIdiom != .pad {
                    configureLinearNetworkActivityIndicator()
                }
            }
        }
        #endif
    }

    #if !targetEnvironment(macCatalyst)
    class func configureLinearNetworkActivityIndicator() {
        DispatchQueue.once {
            let originalSelector = #selector(setter: UIApplication.isNetworkActivityIndicatorVisible)
            let swizzledSelector = #selector(nk_setNetworkActivityIndicatorVisible(visible:))
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
        UIViewController.configureLinearNetworkActivityIndicator()
    }

    private struct AssociatedKeys {
        static var indicatorWindowKey = "NKLinearActivityIndicatorWindowKey"
    }

    var indicatorWindow: UIWindow? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.indicatorWindowKey) as? UIWindow
        }

        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.indicatorWindowKey,
                    newValue as UIWindow?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }


    @objc func nk_setNetworkActivityIndicatorVisible(visible: Bool) {
        self.nk_setNetworkActivityIndicatorVisible(visible: visible) // original implementation

        if visible {
            if indicatorWindow == nil {
                indicatorWindow = UIWindow(frame: statusBarFrame)
                indicatorWindow?.windowLevel = UIWindow.Level.statusBar + 1
                indicatorWindow?.isUserInteractionEnabled = false

                let indicator = NKLinearActivityIndicator(frame: CGRect(x: indicatorWindow!.frame.width - 74, y: 6, width: 44, height: 4))
                indicator.isUserInteractionEnabled = false
                indicator.hidesWhenStopped = false
                indicator.startAnimating()
                indicatorWindow?.addSubview(indicator)
            }
        }
        guard let indicator = indicatorWindow?.subviews.first as? NKLinearActivityIndicator else {return}
        if #available(iOS 13.0, *) {
            indicator.tintColor = indicatorWindow?.windowScene?.statusBarManager?.statusBarStyle == .lightContent ? .white : .black
        } else {
            indicator.tintColor = statusBarStyle == .default ? UIColor.black : UIColor.white
        }
        if visible {
            indicatorWindow?.isHidden = self.isStatusBarHidden
            indicator.isHidden = false
            indicator.alpha = 1
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                indicator.alpha = 0
            }) { (finished) in
                if (finished) {
                    indicator.isHidden = !self.isNetworkActivityIndicatorVisible  // might have changed in the meantime
                    self.indicatorWindow?.isHidden = !self.isNetworkActivityIndicatorVisible || self.isStatusBarHidden
                }
            }
        }
    }

    func nkUpdateNetworkActivityIndicatorAppearance() {
        self.indicatorWindow?.isHidden = !self.isNetworkActivityIndicatorVisible || self.isStatusBarHidden
    }
    #endif
}

#if !targetEnvironment(macCatalyst)
extension UIViewController {
    @objc final public class func configureLinearNetworkActivityIndicator() {
        DispatchQueue.once {
            let originalSelector = #selector(setNeedsStatusBarAppearanceUpdate)
            let swizzledSelector = #selector(nkSetNeedsStatusBarAppearanceUpdate)
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }

    @objc func nkSetNeedsStatusBarAppearanceUpdate() {
        self.nkSetNeedsStatusBarAppearanceUpdate()
        UIApplication.shared.nkUpdateNetworkActivityIndicatorAppearance()
    }

}

#endif
