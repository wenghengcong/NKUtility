//
//  UIColor+RGBA.swift
//  FireFly
//
//  Created by Hunt on 2020/11/29.
//

import UIKit

public extension UIColor {
    
    public convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8)  / 255.0,
            blue: CGFloat((rgb & 0x0000FF) >> 0)  / 255.0,
            alpha: 1)
    }

    public convenience init(rgba: UInt32) {
        self.init(
            red: CGFloat((rgba & 0xFF000000) >> 24) / 255.0,
            green: CGFloat((rgba & 0x00FF0000) >> 16)  / 255.0,
            blue: CGFloat((rgba & 0x0000FF00) >> 8)  / 255.0,
            alpha: CGFloat((rgba & 0x000000FF) >> 0) / 255.0
        )
    }

    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        assert(alpha >= 0.0 && alpha <= 1.0, "Invalid alpha component")
        let red: CGFloat = CGFloat(red) / 255.0
        let green: CGFloat = CGFloat(green) / 255.0
        let blue: CGFloat = CGFloat(blue) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(_ rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: a
        )
    }
    
    convenience init(rgb: (r: CGFloat, g: CGFloat, b: CGFloat)) {
        self.init(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
    }
    
    convenience init(rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat )) {
        self.init(red: rgba.r, green: rgba.g, blue: rgba.b, alpha: rgba.a)
    }
    
    convenience init(rgb: (r: Int, g: Int, b: Int)) {
        self.init(red: rgb.r , green: rgb.g, blue: rgb.b, alpha: 1.0)
    }
    
    convenience init(rgba: (r: Int, g: Int, b: Int, a: CGFloat )) {
        self.init(red: rgba.r, green: rgba.g, blue: rgba.b, alpha: rgba.a)
    }
    
    func red() -> CGFloat {
        return rgba().r
    }
    
    func green() -> CGFloat {
        return rgba().g
    }
    
    func blue() -> CGFloat {
        return rgba().b
    }
}
