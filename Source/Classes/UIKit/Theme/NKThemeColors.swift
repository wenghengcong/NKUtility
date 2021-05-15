//
//  NKThemeColors.swift
//  NKUtility
//
//  Created by Hunt on 2021/3/8.
//

import Foundation
import UIKit

public extension UIColor {
    // 绿色：25b864，30b767, 47c479
    // 深灰595959
    static let logoColor = UIColor(hex: "#47c479")
    static let logoGrayColor = UIColor(hex: "#595959")

    static let titleColor = NKThemeProvider.currentTheme.titleTextColor
    static let subTitleColor = NKThemeProvider.currentTheme.mainTextColor
}

public extension ThemeColorPicker {
    static let logoColor = NKThemeProvider.getColorPicker(name: "tintColor")
    
    /// 背景色
    static let viewBackgroundColor = NKThemeProvider.getColorPicker(name: "backgroundColor")
    
    /// 内容背景色
    static let tableCellBackgroundColor = NKThemeProvider.getColorPicker(name: "tableCellBackgroundColor")
    
    static let separatorColor = NKThemeProvider.getColorPicker(name: "separatorColor")

    static let borderColor = NKThemeProvider.getColorPicker(name: "borderColor")

    static let titleColor = NKThemeProvider.getColorPicker(name: "titleTextColor")
    static let subTitleColor = NKThemeProvider.getColorPicker(name: "mainTextColor")
    
    static let linkColor = UIColor(hex: "#0000EE")
    
    /// 按钮
    static let buttonBackgroundColor = NKThemeProvider.getColorPicker(name: "buttonBackgroundColor")
    static let buttonTitleColor = NKThemeProvider.getColorPicker(name: "buttonTitleColor")
    static let buttonBorderColor = NKThemeProvider.getColorPicker(name: "buttonBorderColor")
}

public extension ThemeCGColorPicker {
    static let borderColor = NKThemeProvider.getCGColorPicker(name: "borderColor")
}
