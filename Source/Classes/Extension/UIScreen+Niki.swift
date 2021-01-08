//
//  UIScreen+Niki.swift
//  FireFly
//
//  Created by Hunt on 2020/11/24.
//

import UIKit

public extension UIScreen {
    // MARK: properties
    /// 屏幕scale（避免与scale冲突）
    static let screenScale = UIScreen.scale()

    /// 是否是retina屏幕
    static let isRetina = UIScreen.scale() > 1.0

    /// 屏幕bound(去掉s，避免与bounds冲突)
    static let bound  = UIScreen.bounds()

    /// 屏幕Size
    static let size  = UIScreen.bound.size

    /// 屏幕width
    static let width  = UIScreen.size.width

    /// 屏幕height
    static let height  = UIScreen.size.height
    
    
    /// 返回屏幕bounds
    ///
    /// - Returns: <#return value description#>
    static func bounds() -> CGRect {
        return UIScreen.main.bounds
    }

    /// 返回屏幕scale
    ///
    /// - Returns: <#return value description#>
    static func scale() -> CGFloat {
        return UIScreen.main.scale
    }
    
}
