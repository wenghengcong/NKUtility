//
//  FFTheme.swift
//  FireFly
//
//  Created by Hunt on 2020/10/26.
//

import Foundation
import SwiftTheme


/// 主题对外元素的提供者，为 SwiftTheme 服务
public struct FFTheme {
    public struct Global {

    }
    
    public struct NavigationBar {
        
    }
    
    public struct TabBar {
        /// tabbar 的背景色，不同于 tabbar item 的背景色，这个在更后面
        public static let barTintColor = ThemeColorPicker.pickerWithUIColors(
            [
                FFThemeElement.clearColor,
                FFThemeElement.clearColor,
                FFDarkTheme.shared.themeBackgroundColor
            ]
        )
        
        public static let barItemBackgroundColor = ThemeColorPicker.pickerWithUIColors(
            [
                FFThemeElement.clearColor,
                FFThemeElement.clearColor,
                FFDarkTheme.shared.themeBackgroundColor
            ]
        )
    
        public static let barItemNormalTextAndIconColor = ThemeColorPicker.pickerWithUIColors(
            [
                FFLightTheme.shared.themeTitleTextColor,
                FFGrassTheme.shared.themeTitleTextColor,
                FFDarkTheme.shared.themeTitleTextColor
            ]
        )

        public static let barItemHighlightTextAndIconColor = ThemeColorPicker.pickerWithUIColors(
            [
                FFLightTheme.shared.themeTintColor,
                FFGrassTheme.shared.themeTintColor,
                FFDarkTheme.shared.themeTintColor
            ]
        )
        
//        themeIcon.theme_image = ["icon_theme_red", "icon_theme_yellow", "icon_theme_blue", "icon_theme_light"]

    }
}
