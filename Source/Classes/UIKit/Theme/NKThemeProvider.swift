//
//  NKThemeProvider.swift
//  NKUtility
//
//  Created by Hunt on 2021/2/23.
//

import Foundation
import SwiftTheme

private let defaults = UserDefaults.standard

public class NKThemeProvider {
    
    public static let shared = NKThemeProvider()
    
    public var themes: [NKThemeImpProtocol] = []
    
    public var isFollowingSystem: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: NKUserDefaultKey.UI.nkThemeFollowingSystem)
            UserDefaults.standard.synchronize()
        }
        get {
            let followingSystem: Bool = defaults.bool(forKey: NKUserDefaultKey.UI.nkThemeFollowingSystem)
            return followingSystem
        }
    }
    
    public func checkFollowingSystem() {
        let isInSystemDark = UIViewController().isDarkMode
        let appFollowing = isFollowingSystem
        if appFollowing {
            if isInSystemDark {
                if currentIndex != nightIndex {
                    NKThemeProvider.shared.switchNight()
                }
            } else {
                restoreCurrentTheme()
            }
        } else {
            restoreCurrentTheme()
        }
    }
    
    /// 切换主题前的主题 index
    public var lastIndex = 0
    
    /// 当前的主题 index
    public var currentIndex = 0
    public var lightIndex = 0
    public var nightIndex = 1
    
    public func launch(themes:[NKThemeImpProtocol], lightIndex: Int, nightIndex: Int) {
        assert(lightIndex < themes.count && nightIndex < themes.count, "检查传入主题数目与 index")
        self.themes = themes
        self.lightIndex = lightIndex
        self.nightIndex = nightIndex
        checkFollowingSystem()
    }
    
    public static var currentTheme: NKThemeProtocol {
        return shared.currentTheme
    }
    
    public static var lastTheme: NKThemeProtocol {
        return shared.lastTheme ?? shared.currentTheme
    }
    
    // MARK: -
    public var currentTheme: NKThemeProtocol {
        assert(currentIndex < themes.count, "index 出错")
        let theme = themes[currentIndex]
        return theme
    }
    
    public var lastTheme: NKThemeProtocol?
    
    public var colorTheme: NKThemeProtocol {
        return currentTheme
    }
    
    // MARK: - Switch Theme
    
    public func switchTo(name: String) {
        var to = lightIndex
        for (index, theme) in themes.enumerated() {
            if theme.name == name {
                to = index
            }
        }
        switchTo(index: to)
    }
    
    public func switchTo(index: Int) {
        assert(index < themes.count, "index 出错")
        guard currentIndex != index else {
            return
        }
        lastIndex = currentIndex    // 保存切换前的主题 index
        lastTheme = themes[lastIndex]
        saveLastTheme()

        ThemeManager.setTheme(index: index)
        currentIndex = index        // 更新当前 index
        saveCurrentTheme()
    }
    
    public func switchToNext() {
        var next = ThemeManager.currentThemeIndex + 1
        if next >= themes.count { next = 0 } // cycle and without Night
        switchTo(index: next)
    }
    
    // MARK: - Switch Night
    public func switchNight(isToNight: Bool = true) {
        switchTo(index: isToNight ? nightIndex : lastThemeIndex())
    }
        
    public func isNight() -> Bool {
        return currentIndex == nightIndex
    }
    
    // MARK: - Save & Restore
    public func restoreLastTheme() {
        switchTo(index: lastThemeIndex())
    }
    
    public func lastThemeIndex() -> Int {
        let last = defaults.integer(forKey: NKUserDefaultKey.UI.nkThemeLastIndex)
        return last
    }
    
    public func saveLastTheme() {
        defaults.set(lastIndex, forKey: NKUserDefaultKey.UI.nkThemeLastIndex)
        defaults.synchronize()
    }
    
    public func restoreCurrentTheme() {
        switchTo(index: currentThemeIndex())
    }
    
    public func currentThemeIndex() -> Int {
        let last = defaults.integer(forKey: NKUserDefaultKey.UI.nkThemeCurrentIndex)
        return last
    }
    
    public func saveCurrentTheme() {
        defaults.set(currentIndex, forKey: NKUserDefaultKey.UI.nkThemeCurrentIndex)
        defaults.synchronize()
    }
}

public extension NKThemeProvider {
    /*
     usage :
     let styles = NKThemeProvider.allElement(name: "statusBarStyle", type: UIStatusBarStyle.self)
     */
    /// 获取所有对应的属性
    /// - Parameter property: 属性名
    /// - Returns: 返回所有主题的该属性值数组
    public static func allElement<T>(name property: String,
                                     type: T.Type)  -> [T] {
        var propertys: [T] = []
        for theme in shared.themes {
            if property == "statusBarStyle" && type == UIStatusBarStyle.self {
                if let barstyle = theme.value(forKey: property) as? Int {
                    let barStyle: UIStatusBarStyle = UIStatusBarStyle(rawValue: barstyle) ?? .default
                    propertys.append(barStyle as! T)
                }
            }
            else  if let p = theme.value(forKey: property) as? T {
                propertys.append(p)
            }
        }
        return propertys
    }
}

// MARK: - generator theme picker
public extension NKThemeProvider {
    
    public static func themeColors(name property: String)  -> [String] {
        var colors: [String] = []
        for theme in shared.themes {
            if let color = theme.value(forKey: property) as? UIColor {
                colors.append(color.hexString)
            }
        }
        return colors
    }
    
    public static func getColorPicker(name property: String)  -> ThemeColorPicker {
        let colors = themeColors(name: property)
        let colorpickier: ThemeColorPicker = ThemeColorPicker.pickerWithColors(colors)
        return colorpickier
    }
    
    public static func getCGColorPicker(name property: String)  -> ThemeCGColorPicker {
        let colors = themeColors(name: property)
        let colorpickier: ThemeCGColorPicker = ThemeCGColorPicker.pickerWithColors(colors)
        return colorpickier
    }
}

// MARK: - navigation bar / status bar
public extension NKThemeProvider {
    
    /// 返回主题下状态栏样式
    /// - Returns:
    public static var viewControllerStatusBar: UIStatusBarStyle {
        let style: UIStatusBarStyle = NKThemeProvider.shared.isNight() ? .lightContent : .darkContent
        return style
    }
    
    public static var barBackgroundColor: [String] {
        return themeColors(name: "barBackgroundColor")
    }
}

// MARK: - text
public extension NKThemeProvider {
    public static var titleTextColor: [String] {
        return themeColors(name: "titleTextColor")
    }
}

// MARK: - for tabbar
public extension NKThemeProvider {
    public static var barBackgroundColorPicker: ThemeColorPicker {
        return getColorPicker(name: "barBackgroundColor")
    }

    public static var tabBarItemBackgroundColorPicker: ThemeColorPicker {
        return getColorPicker(name: "tabBarItemBackgroundColor")
    }
    
    public static var tabBarItemBackgroundColorHighlightPicker: ThemeColorPicker {
        return getColorPicker(name: "tabBarItemBackgroundColorHighlight")
    }
    
    public static var tabBarItemTextColorPicker: ThemeColorPicker {
        return getColorPicker(name: "tabBarItemTextColor")
    }
    
    public static var tabBarItemIconColorPicker: ThemeColorPicker {
        return getColorPicker(name: "tabBarItemIconColor")
    }
    
    public static var tabBarItemTextColorHighlightPicker: ThemeColorPicker {
        return getColorPicker(name: "tabBarItemTextColorHighlight")
    }
    
    public static var tabBarItemIconColorHighlightPicker: ThemeColorPicker {
        return getColorPicker(name: "tabBarItemIconColorHighlight")
    }
}
