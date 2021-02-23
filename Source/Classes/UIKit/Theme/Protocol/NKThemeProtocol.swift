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
    var name: String {get}
    
    /// 主题色
    var tintColor: UIColor {get}
    
    // MARK: - 背景
    /// 界面背景色
    var backgroundColor: UIColor {get}

    /// 浅一点的界面背景色，例如 Grouped 类型的列表的 cell 背景
    var backgroundColorLighten: UIColor {get}
    
    /// 在通用背景色上的 item 点击高亮背景色，例如 cell 的 highlightedBackgroundColor
    var backgroundColorHighlighted: UIColor {get}
    
    // MARK: - Text
    /// 最深的文字颜色，可用于标题或者输入框文字
    var titleTextColor: UIColor {get}
    
    /// 主要内容的文字颜色，例如列表的 textLabel
    var mainTextColor: UIColor {get}
    
    /// 界面上一些附属说明的小字颜色
    var descriptionTextColor: UIColor {get}
    
    /// 输入框 placeholder 的颜色
    var placeholderColor: UIColor {get}
    
    /// 文字中的代码颜色
    var codeColor: UIColor {get}
    
    // MARK: - Tabbar
    var tabBarBackgroundColor: UIColor {get}
    
    var tabBarItemBackgroundColor: UIColor {get}
    var tabBarItemBackgroundColorHighlight: UIColor {get}
    var tabBarItemTextColor: UIColor {get}
    var tabBarItemIconColor: UIColor {get}
    var tabBarItemTextColorHighlight: UIColor {get}
    var tabBarItemIconColorHighlight: UIColor {get}
    
    // MARK: - 其他
    /// 分隔线颜色，例如 tableViewSeparator
    var separatorColor: UIColor {get}
    
    /// App 首页每个单元格的颜色
    var gridItemTintColor: UIColor {get}
}
