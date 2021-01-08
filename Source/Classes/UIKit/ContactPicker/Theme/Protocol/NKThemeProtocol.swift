//
//  FFThemeProtocol.swift
//  FireFly
//
//  Created by Hunt on 2020/10/26.
//

import Foundation
import UIKit

public protocol NKThemeProtocol {
    /// 主题名称
    var themeName: String {get}
    
    /// 界面背景色
    var themeBackgroundColor: UIColor {get}
    
    /// 浅一点的界面背景色，例如 Grouped 类型的列表的 cell 背景
    var themeBackgroundColorLighten: UIColor {get}
    
    /// 在通用背景色上的 item 点击高亮背景色，例如 cell 的 highlightedBackgroundColor
    var themeBackgroundColorHighlighted: UIColor {get}
    
    /// 主题色
    var themeTintColor: UIColor {get}
    
    /// 最深的文字颜色，可用于标题或者输入框文字
    var themeTitleTextColor: UIColor {get}
    
    /// 主要内容的文字颜色，例如列表的 textLabel
    var themeMainTextColor: UIColor {get}
    
    /// 界面上一些附属说明的小字颜色
    var themeDescriptionTextColor: UIColor {get}
    
    /// 输入框 placeholder 的颜色
    var themePlaceholderColor: UIColor {get}
    
    /// 文字中的代码颜色
    var themeCodeColor: UIColor {get}
    
    /// 分隔线颜色，例如 tableViewSeparator
    var themeSeparatorColor: UIColor {get}
    
    /// App 首页每个单元格的颜色
    var themeGridItemTintColor: UIColor {get}
}
