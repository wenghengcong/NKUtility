//
//  NKAlertController.swift
//  Alamofire
//
//  Created by wenghengcong on 2021/10/15.
//

import Foundation
/*
 1. Alert
 
 一个按钮：
 NKAlertController.alert("Title")
 NKAlertController.alert("Title", message: "Message")
 NKAlertController.alert("Title", message: "Message", acceptMessage: "OK") { () -> () in
     print("cliked OK")
 }
 
 多个按钮：
 NKAlertController.alert("Title", message: "Message", buttons: ["First", "Second"]) { (alertAction, position) -> Void in
     if position == 0 {
         print("First button clicked")
     } else if position == 1 {
         print("Second button clicked")
     }
 }
 
 // With Preferred Button Style along with all alerts in a single closure
 // Here the Logout button will be red in color to show that it is a destructive action
 NKAlertController.alert("Title", message: "Message", buttons: ["Cancel","Logout"], buttonsPreferredStyle:[.default, .destructive]) { (alert, position) in
     if position == 0 {
         print("Cancel button clicked")
     } else if position == 1 {
         print("Logout button clicked")
     }
 }
 
 2. Action Sheet:
 
 // With individual UIAlertAction objects
 let firstButtonAction = UIAlertAction(title: "First Button", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
     print("First Button pressed")
 })
 let secondButtonAction = UIAlertAction(title: "Second Button", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
     print("Second Button pressed")
 })

 NKAlertController.actionSheet("Title", message: "message", actions: [firstButtonAction, secondButtonAction])

 // With all actions in single closure
 NKAlertController.actionSheet("Title", message: "Message", buttons: ["First", "Second"]) { (alertAction, position) -> Void in
     if position == 0 {
         print("First button clicked")
     } else if position == 1 {
         print("Second button clicked")
     }
 }
 
 
 3. 自定义：
 let alertController = NKAlertController.alert("Title") // Returns UIAlertController
 alertController.setValue(attributedTitle, forKey: "attributedTitle")
 alertController.setValue(attributedMessage, forKey: "attributedMessage")
 alertController.view.tintColor =  self.view.tintColor
 ...
 
 */
@objc open class NKAlertController : NSObject {

    //==========================================================================================================
    // MARK: - Singleton
    //==========================================================================================================

    class var instance : NKAlertController {
        struct Static {
            static let inst : NKAlertController = NKAlertController ()
        }
        return Static.inst
    }

    //==========================================================================================================
    // MARK: - Private Functions
    //==========================================================================================================

    fileprivate func topMostController() -> UIViewController? {
        let topVc = UIWindow.topViewController()
        return topVc
    }

    //==========================================================================================================
    // MARK: - Class Functions
    //==========================================================================================================
    
    @discardableResult
    open class func alert(_ title: String) -> UIAlertController {
        return alert(title, message: "")
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String) -> UIAlertController {
        return alert(title, message: message, acceptMessage: "OK", acceptBlock: {
            // Do nothing
        })
    }

    @discardableResult
    open class func alert(_ title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)

        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }

    @discardableResult
    open class func alert(_ title: String, message: String, buttons:[String], handler:NKUIAlertActionHanlder ) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, handler: handler)
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String, buttons:[String], buttonsPreferredStyle:[UIAlertAction.Style], handler:NKUIAlertActionHanlder ) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, buttonsPreferredStyle: buttonsPreferredStyle, handler: handler)
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        for action in actions {
            alert.addAction(action)
        }
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }

    @discardableResult
    open class func actionSheet(_ title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }

    @discardableResult
    open class func actionSheet(_ title: String, message: String, sourceView: UIView, buttons:[String], handler:NKUIAlertActionHanlder ) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, handler: handler)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }

}

private extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons:[String], handler:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, handler: handler)
            buttonIndex += 1
            self.addAction(action)
        }
    }
    
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons:[String], buttonsPreferredStyle:[UIAlertAction.Style], handler:NKUIAlertActionHanlder ) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: buttonsPreferredStyle[buttonIndex], buttonIndex: buttonIndex, handler: handler)
            buttonIndex += 1
            self.addAction(action)
        }
    }
}

public typealias NKUIAlertActionHanlder = ((UIAlertAction, Int) -> Void)?

public extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style = .default, buttonIndex:Int, handler: NKUIAlertActionHanlder ) {
        self.init(title: title, style: preferredStyle) {
            (action:UIAlertAction) in
            if let block = handler {
                block(action, buttonIndex)
            }
        }
    }
}
