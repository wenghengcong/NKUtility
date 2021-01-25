//
//  FFDarkTheme.swift
//  FireFly
//
//  Created by Hunt on 2020/10/26.
//

import Foundation
import UIKit

/// 黑暗主题
public struct FFDarkTheme: NKThemeProtocol {
    public static let shared = FFLightTheme()
    public var themeName: String {
        return "Dark"
    }
    
    public var themeBackgroundColor: UIColor {
        return FFThemeElement.blackColor
    }
    
    public var themeBackgroundColorLighten: UIColor {
        return UIColor(rgb: (28, 28, 30))
    }
    
    public var themeBackgroundColorHighlighted: UIColor {
        return UIColor(rgb: (48, 49, 51))
    }
    
    public var themeTintColor: UIColor {
        return UIColor.NKTheme.Dark
    }
    
    public var themeTitleTextColor: UIColor {
        return UIColor.NKGray.level1
    }
    
    public var themeMainTextColor: UIColor {
        return UIColor.NKGray.level3
    }
    
    public var themeDescriptionTextColor: UIColor {
        return UIColor.NKGray.level6

    }
    
    public var themePlaceholderColor: UIColor {
        return UIColor.NKGray.level8

    }
    
    public var themeCodeColor: UIColor {
        return self.themeTintColor

    }
    
    public var themeSeparatorColor: UIColor {
        return UIColor(rgb: (46, 50, 54))

    }
    
    public var themeGridItemTintColor: UIColor {
        return UIColor(rgb: (238, 239, 241))

    }
}
