//
//  UIView+Storyboard.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/27.
//

import Foundation
import UIKit

extension UIStoryboard {
    class func viewController(fromStoryboardName storyBoardName : String, storyBoardIdentifier : String) -> AnyObject {
        let viewController:UIViewController = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: storyBoardIdentifier)
        return viewController
    }
}

extension UITableViewCell {
    public class var identifier : String {
        var name = NSStringFromClass(self)
        name = name.components(separatedBy: ".").last!
        return name
    }
    
    public class var height : CGFloat {
        return CGFloat(54.0)
    }
}

public extension UIViewController {
    
    class var identifier : String {
        var name = NSStringFromClass(self)
        name = name.components(separatedBy: ".").last!
        return name
    }
    
    /// Loads a `UIViewController` of type `T` with storyboard. Assumes that the storyboards Storyboard ID has the same name as the storyboard and that the storyboard has been marked as Is Initial View Controller.
    /// - Parameter storyboardName: Name of the storyboard without .xib/nib suffix.
    class func load<T: UIViewController>(from storyboardName: String) -> T? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: self.identifier) as? T {
            vc.loadViewIfNeeded() // ensures vc.view is loaded before returning
            return vc
        }
        return nil
    }
}
