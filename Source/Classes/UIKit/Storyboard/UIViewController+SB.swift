//
//  UIViewController+SB.swift
//  FireFly
//
//  Created by Hunt on 2020/11/3.
//

import UIKit

public extension UIViewController {
    
    public class var identifier : String {
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
