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
public let NKTopBarHeight = UIViewController.topViewController()?.topBarHeight

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



// MARK: - Font
public let NKSysFont5 = UIFont.systemFont(ofSize: NKDesignByW375(5.0))
public let NKSysFont6 = UIFont.systemFont(ofSize: NKDesignByW375(6.0))
public let NKSysFont7 = UIFont.systemFont(ofSize: NKDesignByW375(7.0))
public let NKSysFont8 = UIFont.systemFont(ofSize: NKDesignByW375(8.0))
public let NKSysFont9 = UIFont.systemFont(ofSize: NKDesignByW375(9.0))
public let NKSysFont10 = UIFont.systemFont(ofSize: NKDesignByW375(10.0))
public let NKSysFont11 = UIFont.systemFont(ofSize: NKDesignByW375(11.0))
public let NKSysFont12 = UIFont.systemFont(ofSize: NKDesignByW375(12.0))
public let NKSysFont13 = UIFont.systemFont(ofSize: NKDesignByW375(13.0))
public let NKSysFont14 = UIFont.systemFont(ofSize: NKDesignByW375(14.0))
public let NKSysFont15 = UIFont.systemFont(ofSize: NKDesignByW375(15.0))
public let NKSysFont16 = UIFont.systemFont(ofSize: NKDesignByW375(16.0))
public let NKSysFont17 = UIFont.systemFont(ofSize: NKDesignByW375(17.0))
public let NKSysFont18 = UIFont.systemFont(ofSize: NKDesignByW375(18.0))
public let NKSysFont19 = UIFont.systemFont(ofSize: NKDesignByW375(19.0))
public let NKSysFont20 = UIFont.systemFont(ofSize: NKDesignByW375(20.0))
public let NKSysFont21 = UIFont.systemFont(ofSize: NKDesignByW375(21.0))
public let NKSysFont22 = UIFont.systemFont(ofSize: NKDesignByW375(22.0))
public let NKSysFont23 = UIFont.systemFont(ofSize: NKDesignByW375(23.0))
public let NKSysFont24 = UIFont.systemFont(ofSize: NKDesignByW375(24.0))
public let NKSysFont25 = UIFont.systemFont(ofSize: NKDesignByW375(25.0))
public let NKSysFont26 = UIFont.systemFont(ofSize: NKDesignByW375(26.0))
public let NKSysFont27 = UIFont.systemFont(ofSize: NKDesignByW375(27.0))
public let NKSysFont28 = UIFont.systemFont(ofSize: NKDesignByW375(28.0))
public let NKSysFont29 = UIFont.systemFont(ofSize: NKDesignByW375(29.0))
public let NKSysFont30 = UIFont.systemFont(ofSize: NKDesignByW375(30.0))
public let NKSysFont31 = UIFont.systemFont(ofSize: NKDesignByW375(31.0))
public let NKSysFont32 = UIFont.systemFont(ofSize: NKDesignByW375(32.0))

public let NKBoldSysFont8 = UIFont.boldSystemFont(ofSize: NKDesignByW375(8.0))
public let NKBoldSysFont9 = UIFont.boldSystemFont(ofSize: NKDesignByW375(9.0))
public let NKBoldSysFont10 = UIFont.boldSystemFont(ofSize: NKDesignByW375(10.0))
public let NKBoldSysFont11 = UIFont.boldSystemFont(ofSize: NKDesignByW375(11.0))
public let NKBoldSysFont12 = UIFont.boldSystemFont(ofSize: NKDesignByW375(12.0))
public let NKBoldSysFont13 = UIFont.boldSystemFont(ofSize: NKDesignByW375(13.0))
public let NKBoldSysFont14 = UIFont.boldSystemFont(ofSize: NKDesignByW375(14.0))
public let NKBoldSysFont15 = UIFont.boldSystemFont(ofSize: NKDesignByW375(15.0))
public let NKBoldSysFont16 = UIFont.boldSystemFont(ofSize: NKDesignByW375(16.0))
public let NKBoldSysFont17 = UIFont.boldSystemFont(ofSize: NKDesignByW375(17.0))
public let NKBoldSysFont18 = UIFont.boldSystemFont(ofSize: NKDesignByW375(18.0))
public let NKBoldSysFont19 = UIFont.boldSystemFont(ofSize: NKDesignByW375(19.0))
public let NKBoldSysFont20 = UIFont.boldSystemFont(ofSize: NKDesignByW375(20.0))
public let NKBoldSysFont21 = UIFont.boldSystemFont(ofSize: NKDesignByW375(21.0))
public let NKBoldSysFont22 = UIFont.boldSystemFont(ofSize: NKDesignByW375(22.0))
public let NKBoldSysFont23 = UIFont.boldSystemFont(ofSize: NKDesignByW375(23.0))
public let NKBoldSysFont24 = UIFont.boldSystemFont(ofSize: NKDesignByW375(24.0))
public let NKBoldSysFont25 = UIFont.boldSystemFont(ofSize: NKDesignByW375(25.0))
public let NKBoldSysFont26 = UIFont.boldSystemFont(ofSize: NKDesignByW375(26.0))
public let NKBoldSysFont27 = UIFont.boldSystemFont(ofSize: NKDesignByW375(27.0))
public let NKBoldSysFont28 = UIFont.boldSystemFont(ofSize: NKDesignByW375(28.0))
public let NKBoldSysFont29 = UIFont.boldSystemFont(ofSize: NKDesignByW375(29.0))
public let NKBoldSysFont30 = UIFont.boldSystemFont(ofSize: NKDesignByW375(30.0))
public let NKBoldSysFont31 = UIFont.boldSystemFont(ofSize: NKDesignByW375(31.0))
public let NKBoldSysFont32 = UIFont.boldSystemFont(ofSize: NKDesignByW375(32.0))
