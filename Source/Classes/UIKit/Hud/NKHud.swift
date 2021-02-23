//
//  NKHud.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/22.
//

#if canImport(FluentUI)
import Foundation
import UIKit
import FluentUI

public struct NKHud {
    
    // Using a separate overload method for Objective-C instead of default parameters
    static public func show(in view: UIView) {
        HUD.shared.show(in: view)
    }

    static public func show(in view: UIView, with params: HUDParams) {
        HUD.shared.show(in: view, with: params, onTap: nil)
    }

    static public func show(in view: UIView, with params: HUDParams, onTap: (() -> Void)? = nil) {
        HUD.shared.show(in: view, with: params, onTap: onTap)
    }

    // Using a separate overload method for Objective-C instead of default parameters
    static public func show(from controller: UIViewController) {
        HUD.shared.show(from: controller, with: HUDParams())
    }
    
    static public func show(from controller: UIViewController, with params: HUDParams) {
        HUD.shared.show(from: controller, with: params)
    }

    static public func showSuccess(from controller: UIViewController) {
        showSuccess(from: controller, with: NKStringGlobal.Word.Success)
    }
    
    static public func showSuccess(from controller: UIViewController, with caption: String = "") {
        HUD.shared.showSuccess(from: controller, with: caption);
    }
    
    static public func showSuccess(in view: UIView) {
        showSuccess(in: view, with: NKStringGlobal.Word.Success)
    }
    
    static public func showSuccess(in view: UIView, with caption: String = "") {
        HUD.shared.showSuccess(in: view, with: caption)
    }
    
  
    static public func showFailure(from controller: UIViewController) {
        showFailure(from: controller, with: NKStringGlobal.Word.Failure)
    }


    static public func showFailure(from controller: UIViewController, with caption: String = "") {
        HUD.shared.showFailure(from: controller, with: caption)
    }
    
    static public func showFailure(in view: UIView) {
        showFailure(in: view, with: NKStringGlobal.Word.Failure)
    }


    static public func showFailure(in view: UIView, with caption: String = "") {
        HUD.shared.showFailure(in: view, with: caption)
    }
    

    static public func hide(animated: Bool = true) {
        HUD.shared.hide()
    }


    static func showActivity(in view: UIView, caption: String = "") {
        HUD.shared.show(in: view, with: HUDParams(caption: caption))
  
    }
    
    static func showActivity(in view: UIView, caption: String = "", delay: TimeInterval) {
        HUD.shared.show(in: view, with: HUDParams(caption: caption))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            HUD.shared.hide()
        }
    }
}

#endif

