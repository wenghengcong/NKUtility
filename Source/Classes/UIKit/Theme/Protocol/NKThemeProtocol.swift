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
    var name: String {set get}
    
    /// 主题色
    var tintColor: UIColor {set get}
    
    // MARK: - 背景
    /// 界面背景色
    var backgroundColor: UIColor {set get}

    /// 浅一点的界面背景色，例如 Grouped 类型的列表的 cell 背景
    var backgroundColorLighten: UIColor {set get}
    
    /// 在通用背景色上的 item 点击高亮背景色，例如 cell 的 highlightedBackgroundColor
    var backgroundColorHighlighted: UIColor {set get}
    
    // MARK: - Text
    /// 最深的文字颜色，可用于标题或者输入框文字
    var titleTextColor: UIColor {set get}
    
    /// 主要内容的文字颜色，例如列表的 textLabel
    var mainTextColor: UIColor {set get}
    
    ///  会员颜色，用于区分 vip 的标识
    var vipTextColor: UIColor {set get}
    
    /// 界面上一些附属说明的小字颜色
    var descriptionTextColor: UIColor {set get}
    
    /// 输入框 placeholder 的颜色
    var placeholderColor: UIColor {set get}
    
    /// 文字中的代码颜色
    var codeColor: UIColor {set get}
    
    // MARK: - Cell
    var tableCellBackgroundColor: UIColor {set get}
    
    
    // MARK: - 按钮
    /// 按钮背景色
    var buttonBackgroundColor: UIColor {set get}
    /// 按钮标题颜色
    var buttonTitleColor: UIColor {set get}
    /// 按钮边框色
    var buttonBorderColor: UIColor {set get}


    // MARK: - Nav Bar/ Tabbar
    var statusBarStyle: UIStatusBarStyle {set get}
    
    var barBackgroundColor: UIColor {set get}
    
    var tabBarItemBackgroundColor: UIColor {set get}
    var tabBarItemBackgroundColorHighlight: UIColor {set get}
    var tabBarItemTextColor: UIColor {set get}
    var tabBarItemIconColor: UIColor {set get}
    var tabBarItemTextColorHighlight: UIColor {set get}
    var tabBarItemIconColorHighlight: UIColor {set get}
    
    // MARK: - 其他
    /// 分隔线颜色，例如 tableViewSeparator
    var separatorColor: UIColor {set get}
    
    ///  边框颜色
    var borderColor: UIColor {set get}

    /// App 首页每个单元格的颜色
    var gridItemTintColor: UIColor {set get}
    
  
}

@objcMembers
open class NKThemeImpProtocol: NSObject, NKThemeProtocol {
    
    open var name: String {
        set {
            self.name = newValue
        }
        get {
            return "Imp"
        }
    }
    
    open var tintColor: UIColor {
        set {
            self.tintColor = newValue
        }
        get {
            return UIColor(hex: "#34C759")
        }
    }
    
    // MARK: - 背景
    open var backgroundColor: UIColor {
        set {
            self.backgroundColor = newValue
        }
        get {
            return .white
        }
    }
    
    open var backgroundColorLighten: UIColor {
        set {
            self.backgroundColorLighten = newValue
        }
        get {
            return .white
        }
    }
    
    open var backgroundColorHighlighted: UIColor {
        set {
            self.backgroundColorHighlighted = newValue
        }
        get {
            return UIColor(rgb: (238, 239, 241))
        }
    }
    
    // MARK: - Text
    open var titleTextColor: UIColor {
        set {
            self.titleTextColor = newValue
        }
        get {
            return .black
        }
    }
    
    open var mainTextColor: UIColor {
        set {
            self.mainTextColor = newValue
        }
        get {
            return .lightGray
        }
    }
    
    open var vipTextColor: UIColor {
        set {
            self.vipTextColor = newValue
        }
        get {
            return UIColor(hex: "#e9be7b")
        }
    }
    
    
    open var descriptionTextColor: UIColor {
        set {
            self.descriptionTextColor = newValue
        }
        get {
            return .lightGray
        }
    }
    
    open var placeholderColor: UIColor {
        set {
            placeholderColor = newValue
        }
        get {
            return .lightGray
        }
    }
    
    open var codeColor: UIColor {
        set {
            self.codeColor = newValue
        }
        get {
            return self.tintColor
        }
    }
    
    // MARK: - Cell
    open var tableCellBackgroundColor: UIColor {
        set {
            self.tableCellBackgroundColor = newValue
        }
        get {
            return .white
        }
    }
    
    // MARK: - 按钮
    /// 按钮背景色
    open var buttonBackgroundColor: UIColor {
        set {
            tableCellBackgroundColor = newValue
        }
        get {
            return tintColor
        }
    }
    /// 按钮标题颜色
    open var buttonTitleColor: UIColor {
        set {
            tableCellBackgroundColor = newValue
        }
        get {
            return .white
        }
    }
    /// 按钮边框色
    open var buttonBorderColor: UIColor {
        set {
            tableCellBackgroundColor = newValue
        }
        get {
            return .white
        }
    }
    
    // MARK: - Tabbar
    open var statusBarStyle: UIStatusBarStyle {
        set {
            self.statusBarStyle = newValue
        }
        get {
            return .default
        }
    }
    
    open var barBackgroundColor: UIColor {
        set {
            self.barBackgroundColor = newValue
        }
        get {
            return .clear
        }
    }
    
    open var tabBarItemBackgroundColor: UIColor {
        set {
            self.tabBarItemBackgroundColor = newValue
        }
        get {
            return .clear
        }
    }
    
    open var tabBarItemBackgroundColorHighlight: UIColor {
        set {
            self.tabBarItemBackgroundColorHighlight = newValue
        }
        get {
            return .clear
        }
    }
    
    open var tabBarItemTextColor: UIColor {
        set {
            self.tabBarItemTextColor = newValue
        }
        get {
            return titleTextColor
        }
    }
    
    open var tabBarItemIconColor: UIColor {
        set {
            self.tabBarItemIconColor = newValue
        }
        get {
            return titleTextColor
        }
    }
    
    open var tabBarItemTextColorHighlight: UIColor {
        set {
            self.tabBarItemTextColorHighlight = newValue
        }
        get {
            return tintColor
        }
    }
    
    open var tabBarItemIconColorHighlight: UIColor {
        set {
            self.tabBarItemIconColorHighlight = newValue
        }
        get {
            return tintColor
        }
    }
    
    // MARK: - 其他
    open var separatorColor: UIColor {
        set {
            self.separatorColor = newValue
        }
        get {
            return UIColor(rgb: (46, 50, 54))
        }
    }
    
    open var borderColor: UIColor {
        set {
            self.borderColor = newValue
        }
        get {
            return UIColor(rgb: (46, 50, 54))
        }
    }
    
    open var gridItemTintColor: UIColor {
        set {
            self.gridItemTintColor = newValue
        }
        get {
            return UIColor(rgb: (238, 239, 241))
        }
    }
}
