//
//  UITableViewCell.swift
//  FireFly
//
//  Created by Hunt on 2020/11/3.
//

import UIKit

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
