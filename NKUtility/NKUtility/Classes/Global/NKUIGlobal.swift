//
//  NKUIGlobal.swift
//  FireFly
//
//  Created by Hunt on 2020/11/22.
//

import Foundation
import UIKit

/// https://kapeli.com/cheat_sheets/iOS_Design.docset/Contents/Resources/Documents/index

/// 设计稿全部以iPhone 12 Pro Max尺寸设计
func designByW428(_ x: CGFloat) -> CGFloat {
    let scale = ( (UIScreen.width) / CGFloat(428) )
    let result = scale * x
    return result
}

/// 设计稿全部以iPhone XS Max， iPhone 11 Pro Max尺寸设计
func designByW414(_ x: CGFloat) -> CGFloat {
    let scale = ( (UIScreen.width) / CGFloat(414) )
    let result = scale * x
    return result
}

/// 设计稿全部以iPhone 5尺寸设计
func designByW320(_ x: CGFloat) -> CGFloat {
    let scale = ( (UIScreen.width) / CGFloat(320.0) )
    let result = scale * x
    return result
}

/// 设计稿全部以iPhone 6尺寸设计
func designByW375(_ x: CGFloat) -> CGFloat {
    let scale = ( (UIScreen.width) / CGFloat(375.0) )
    let result = scale * x
    return result
}

/// 设计稿全部以iPhone 6 Plus尺寸设计
func designByW390(_ x: CGFloat) -> CGFloat {
    let scale = ( (UIScreen.width) / CGFloat(390.0) )
    let result = scale * x
    return result
}
