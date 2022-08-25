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
    static let mainScale = main.scale

    static let mainNativeScale = main.nativeScale

    /// 是否是retina屏幕)
    static let isRetina = mainScale > 1.0

    /// 屏幕尺寸，以piexl 为单位，且是直向的尺寸
    static let mainNativeBounds  = main.nativeBounds

    /// 屏幕bounds，以 point 为单位，随屏幕旋转返回不同的尺寸
    static let mainBounds  = main.bounds

    /// 屏幕Size
    static let mainSize = mainBounds.size

    static var devicePixel: CGFloat { return 1 / mainScale }

    /// 屏幕width
    static var mainWidth: CGFloat {
        if NKDevice.Screen.isLandscape() {
            return mainSize.height
        }
        return mainSize.width
    }

    /// 屏幕height
    static var mainHeight: CGFloat {
        if NKDevice.Screen.isLandscape() {
            return mainSize.width
        }
        return mainSize.height
    }
    
    static let mainMaxLength  = max(mainWidth, mainHeight)
    
    static let mainMinLength  = min(mainWidth, mainHeight)


}
