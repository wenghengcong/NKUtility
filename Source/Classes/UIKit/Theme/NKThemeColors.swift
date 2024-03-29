//
//  NKThemeColors.swift
//  NKUtility
//
//  Created by Hunt on 2021/3/8.
//

import Foundation
import UIKit

public extension ThemeColorPicker {
    static let logoColor = NKThemeProvider.getColorPicker(name: "tintColor")
    
    /// 背景色
    static let backgroundColor = NKThemeProvider.getColorPicker(name: "backgroundColor")
    
    /// 浅背景色，一般浅色时是白色，深色是略淡的黑色
    static let backgroundColorLighten = NKThemeProvider.getColorPicker(name: "backgroundColorLighten")
    
    /// 内容背景色
    static let tableCellBackgroundColor = NKThemeProvider.getColorPicker(name: "tableCellBackgroundColor")
    
    static let separatorColor = NKThemeProvider.getColorPicker(name: "separatorColor")

    static let borderColor = NKThemeProvider.getColorPicker(name: "borderColor")

    static let titleColor = NKThemeProvider.getColorPicker(name: "titleTextColor")
    
    static let vipTextColor = NKThemeProvider.getColorPicker(name: "vipTextColor")

    static let subTitleColor = NKThemeProvider.getColorPicker(name: "mainTextColor")
    
    static let descriptionTextColor = NKThemeProvider.getColorPicker(name: "descriptionTextColor")

    static let linkColor = UIColor(hex: "#0000EE")
    
    /// 按钮
    static let buttonBackgroundColor = NKThemeProvider.getColorPicker(name: "buttonBackgroundColor")
    static let buttonTitleColor = NKThemeProvider.getColorPicker(name: "buttonTitleColor")
    static let buttonBorderColor = NKThemeProvider.getColorPicker(name: "buttonBorderColor")
}

public extension ThemeCGColorPicker {
    static let borderColor = NKThemeProvider.getCGColorPicker(name: "borderColor")
}
