//
//  NKUIGlobal.swift
//  FireFly
//
//  Created by Hunt on 2020/11/22.
//

import Foundation
import UIKit

// MARK: - Sys Version
public let NKSystemVersion = NKDevice.SysVersion.current
public func iOSVersionIsEqual(to version: String) -> Bool {
    return NKDevice.SysVersion.isEqual(to: version)
}

public func iOSVersionIsEqualOrLater(to version: String) -> Bool {
    return NKDevice.SysVersion.isEqualOrLater(to: version)
}

public func iOSVersionIsLater(to version: String) -> Bool {
    return NKDevice.SysVersion.isEqual(to: version)
}

public func iOSVersionIsEarlier(to version: String) -> Bool {
    return NKDevice.SysVersion.isEarlier(to: version)
}

public func iOSVersionIsEqualOrEarlier(to version: String) -> Bool {
    return NKDevice.SysVersion.isEqualOrEarlier(to: version)
}

// MARK: - UIView
public let NKSCREEN_WIDTH =  NKDevice.Screen.width
public let NKSCREEN_HEIGHT = NKDevice.Screen.height
public let NKTopBarHeight = UIViewController.topViewController()?.topBarHeight ?? 44.0

/// https://ios-resolution.com/
// MARK: - Design Scale
/// 设计稿全部以iPhone 12 Pro Max尺寸设计
public func NKDesignByW428(_ x: CGFloat) -> CGFloat {
    return NKDevice.Screen.scaleBase428(x)
}

/// 设计稿全部以iPhone XS Max， iPhone 11 Pro Max尺寸设计
public func NKDesignByW414(_ x: CGFloat) -> CGFloat {
    return NKDevice.Screen.scaleBase414(x)
}

/// 设计稿全部以iPhone 5尺寸设计
public func NKDesignByW320(_ x: CGFloat) -> CGFloat {
    return NKDevice.Screen.scaleBase320(x)
}

/// 设计稿全部以 iPhone 12 mini尺寸设计
public func NKDesignByW360(_ x: CGFloat) -> CGFloat {
    return NKDevice.Screen.scaleBase360(x)
}

/// 设计稿全部以iPhone 6尺寸设计
public func NKDesignByW375(_ x: CGFloat) -> CGFloat {
    return NKDevice.Screen.scaleBase375(x)
}

/// 设计稿全部以iPhone 6 Plus, iPhone 12 Pro尺寸设计
public func NKDesignByW390(_ x: CGFloat) -> CGFloat {
    return NKDevice.Screen.scaleBase390(x)
}
