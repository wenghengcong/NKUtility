//
//  UIStoryboard+Look.swift
//  FireFly
//
//  Created by Hunt on 2020/11/3.
//

import UIKit

extension UIStoryboard {
    class func viewController(fromStoryboardName storyBoardName : String, storyBoardIdentifier : String) -> AnyObject {
        let viewController:UIViewController = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: storyBoardIdentifier)
        return viewController
    }
}
