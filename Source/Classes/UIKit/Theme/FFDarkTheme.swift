//
//  FFDarkTheme.swift
//  FireFly
//
//  Created by Hunt on 2020/10/26.
//

import Foundation
import UIKit
import NKUtility

/// 黑暗主题
struct FFDarkTheme: NKThemeProtocol {
    static let shared = FFLightTheme()
    var themeName: String {
        return "Dark"
    }
    
    var themeBackgroundColor: UIColor {
        return FFThemeElement.blackColor
    }
    
    var themeBackgroundColorLighten: UIColor {
        return UIColor(rgb: (28, 28, 30))
    }
    
    var themeBackgroundColorHighlighted: UIColor {
        return UIColor(rgb: (48, 49, 51))
    }
    
    var themeTintColor: UIColor {
        return UIColor.NKTheme.Dark
    }
    
    var themeTitleTextColor: UIColor {
        return UIColor.NKGray.level1
    }
    
    var themeMainTextColor: UIColor {
        return UIColor.NKGray.level3
    }
    
    var themeDescriptionTextColor: UIColor {
        return UIColor.NKGray.level6

    }
    
    var themePlaceholderColor: UIColor {
        return UIColor.NKGray.level8

    }
    
    var themeCodeColor: UIColor {
        return self.themeTintColor

    }
    
    var themeSeparatorColor: UIColor {
        return UIColor(rgb: (46, 50, 54))

    }
    
    var themeGridItemTintColor: UIColor {
        return UIColor(rgb: (238, 239, 241))

    }
}
