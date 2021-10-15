// UIAlertControllerExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(UIKit) && !os(watchOS)
import UIKit

#if canImport(AudioToolbox)
import AudioToolbox
#endif

// MARK: - Methods

public extension UIAlertController {
    /// Present alert view controller in the current view controller.
    ///
    /// - Parameters:
    ///   - animated: set true to animate presentation of alert controller (default is true).
    ///   - vibrate: set true to vibrate the device while presenting the alert (default is false).
    ///   - completion: an optional completion handler to be called after presenting alert controller (default is nil).
    @available(iOSApplicationExtension, unavailable)
    func show(animated: Bool = true, vibrate: Bool = false, completion: (() -> Void)? = nil) {
#if targetEnvironment(macCatalyst)
        let window = UIApplication.shared.windows.last
#else
        let window = UIWindow.topWindow()
#endif
        window?.rootViewController?.present(self, animated: animated, completion: completion)
        if vibrate {
#if canImport(AudioToolbox)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
#endif
        }
    }
    
    /// Add an action to Alert
    ///
    /// - Parameters:
    ///   - title: action title
    ///   - style: action style (default is UIAlertActionStyle.default)
    ///   - isEnabled: isEnabled status for action (default is true)
    ///   - handler: optional action handler to be called when button is tapped (default is nil)
    /// - Returns: action created by this method
    @discardableResult
    func addAction(
        title: String,
        style: UIAlertAction.Style = .default,
        isEnabled: Bool = true,
        handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
            let action = UIAlertAction(title: title, style: style, handler: handler)
            action.isEnabled = isEnabled
            addAction(action)
            return action
        }
    
    /// Add a text field to Alert
    ///
    /// - Parameters:
    ///   - text: text field text (default is nil)
    ///   - placeholder: text field placeholder text (default is nil)
    ///   - editingChangedTarget: an optional target for text field's editingChanged
    ///   - editingChangedSelector: an optional selector for text field's editingChanged
    func addTextField(
        text: String? = nil,
        placeholder: String? = nil,
        editingChangedTarget: Any?,
        editingChangedSelector: Selector?) {
            addTextField { textField in
                textField.text = text
                textField.placeholder = placeholder
                if let target = editingChangedTarget, let selector = editingChangedSelector {
                    textField.addTarget(target, action: selector, for: .editingChanged)
                }
            }
        }
}

// MARK: - Initializers
public extension UIAlertController {
    
    // MARK: - Action sheet
    /// Helper method to display an alert on any UIViewController subclass. Uses UIAlertController to show an alert
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message/body of the alert
    ///   - buttonTitles: (Optional)list of button titles for the alert. Default button i.e "OK" will be shown if this paramter is nil
    ///   - highlightedButtonIndex: (Optional) index of the button from buttonTitles that should be highlighted. If this parameter is nil no button will be highlighted
    ///   - completion: (Optional) completion block to be invoked when any one of the buttons is tapped. It passes the index of the tapped button as an argument
    /// - Returns: UIAlertController object (discardable).
    convenience init(alertTitle: String?,
                     message: String?,
                     actionTitles: [String]? = nil,
                     highlightedButtonIndex: Int? = nil,
                     completion: ((Int) -> Void)? = nil) {
        self.init(title: alertTitle, message: message, preferredStyle: .alert)
        let allButtons = checkAlertControllerTitles(actionTitles)
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
                completion?(index)
            })
            addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                preferredAction = action
            }
        }
    }
    
    /// Create new alert view controller with default OK action.
    ///
    /// - Parameters:
    ///   - title: alert controller's title.
    ///   - message: alert controller's message (default is nil).
    ///   - defaultActionButtonTitle: default action button title (default is "OK")
    ///   - tintColor: alert controller's tint color (default is nil)
    convenience init(alertTitle: String,
                     message: String? = nil,
                     defaultActionButtonTitle: String = "OK",
                     tintColor: UIColor? = nil) {
        self.init(title: alertTitle, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = tintColor {
            view.tintColor = color
        }
    }
    
    convenience init(alertTitle: String?,
                     message: String? = nil,
                     actionTitles: [String]? = nil,
                     actionStyles: [UIAlertAction.Style] = [.default],
                     handle: NKUIAlertActionHanlder) {
        self.init(title: alertTitle, message: message, preferredStyle: .alert)
        let actions = checkAlertControllerTitles(actionTitles)
        for (buttonIndex, buttonTitle) in actions.enumerated() {
            var buttonStyle: UIAlertAction.Style = .default
            if buttonIndex < actionStyles.count {
                buttonStyle = actionStyles[buttonIndex]
            }
            let doAction = UIAlertAction(title: buttonTitle, preferredStyle: buttonStyle, buttonIndex: buttonIndex, handler: handle)
            addAction(doAction)
        }
    }
    
    convenience init(alertTitle: String?,
                     message: String? = nil,
                     actionTitle: String? = nil,
                     actionStyle: UIAlertAction.Style = .default,
                     hanlder: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: alertTitle, message: message, preferredStyle: .alert)
        if let leftTitle = actionTitle {
            let leftAction = UIAlertAction(title: leftTitle, style: actionStyle, handler: hanlder)
            addAction(leftAction)
        }
    }
    
    convenience init(alertTitle: String?,
                     message: String? = nil,
                     leftActionTitle: String? = nil,
                     leftActionStyle: UIAlertAction.Style = .default,
                     leftHandler: ((UIAlertAction) -> Void)? = nil,
                     rightActionTitle: String? = nil,
                     rightActionStyle:UIAlertAction.Style,
                     rightHandler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: alertTitle, message: message, preferredStyle: .alert)
        
        if let leftTitle = leftActionTitle {
            let leftAction = UIAlertAction(title: leftTitle, style: leftActionStyle, handler: leftHandler)
            addAction(leftAction)
        }
        
        if let rightTitle = rightActionTitle {
            let rightAction = UIAlertAction(title: rightTitle, style: rightActionStyle, handler: rightHandler)
            addAction(rightAction)
        }
    }
    
    /// Create new error alert view controller from Error with default OK action.
    ///
    /// - Parameters:
    ///   - title: alert controller's title (default is "Error").
    ///   - error: error to set alert controller's message to it's localizedDescription.
    ///   - defaultActionButtonTitle: default action button title (default is "OK")
    ///   - tintColor: alert controller's tint color (default is nil)
    convenience init(title: String = "Error",
                     error: Error,
                     defaultActionButtonTitle: String = "OK",
                     preferredStyle: UIAlertController.Style = .alert,
                     tintColor: UIColor? = nil) {
        self.init(title: title, message: error.localizedDescription, preferredStyle: preferredStyle)
        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = tintColor {
            view.tintColor = color
        }
    }
    
    // MARK: - Action sheet
    convenience init(actionSheetTitle: String?,
                     message: String?,
                     actionTitles: [String]? = nil,
                     highlightedButtonIndex: Int? = nil,
                     completion: ((Int) -> Void)? = nil) {
        self.init(title: actionSheetTitle, message: message, preferredStyle: .actionSheet)
        let allButtons = checkAlertControllerTitles(actionTitles)
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
                completion?(index)
            })
            addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                preferredAction = action
            }
        }
        
        if let currentTopVC = UIWindow.topViewController() {
            // 为了防止 iPad
            if (popoverPresentationController != nil) {
                popoverPresentationController?.permittedArrowDirections = .any
                popoverPresentationController?.sourceView = currentTopVC.view
                popoverPresentationController?.sourceRect = CGRect(x: currentTopVC.view.bounds.midX, y: currentTopVC.view.bounds.midY, width: 0, height: 0)
            }
        }
    }
    
    //TODO: 将 actionsheet 整理合并
    convenience init(actionSheetTitle: String?,
                     message: String? = nil,
                     actionTitles: [String]? = nil,
                     actionStyles: [UIAlertAction.Style] = [.default],
                     handle: NKUIAlertActionHanlder) {
        self.init(title: actionSheetTitle, message: message, preferredStyle: .actionSheet)
        let actions = checkAlertControllerTitles(actionTitles)
        for (buttonIndex, buttonTitle) in actions.enumerated() {
            var buttonStyle: UIAlertAction.Style = .default
            if buttonIndex < actionStyles.count {
                buttonStyle = actionStyles[buttonIndex]
            }
            let doAction = UIAlertAction(title: buttonTitle, preferredStyle: buttonStyle, buttonIndex: buttonIndex, handler: handle)
            addAction(doAction)
        }
        
        if let currentTopVC = UIWindow.topViewController() {
            // 为了防止 iPad
            if (popoverPresentationController != nil) {
                popoverPresentationController?.permittedArrowDirections = .any
                popoverPresentationController?.sourceView = currentTopVC.view
                popoverPresentationController?.sourceRect = CGRect(x: currentTopVC.view.bounds.midX, y: currentTopVC.view.bounds.midY, width: 0, height: 0)
            }
        }
    }
    
}

fileprivate extension UIViewController {
    func checkAlertControllerTitles(_ titles: [String]?) -> [String] {
        var allButtons = titles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }
        return allButtons
    }
}

#endif
