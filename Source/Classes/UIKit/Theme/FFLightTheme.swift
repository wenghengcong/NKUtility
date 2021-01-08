//
//  FFLightTheme.swift
//  FireFly
//
//  Created by Hunt on 2020/10/26.
//

import Foundation
import UIKit
import NKUtility

/// 浅色主题：也为蓝色主题
public struct FFLightTheme: NKThemeProtocol {
    static let shared = FFLightTheme()

    public var themeName: String {
        return "Light"
    }
    
    public var themeBackgroundColor: UIColor {
        return FFThemeElement.backgroundColor
    }
    
    public var themeBackgroundColorLighten: UIColor {
        return FFThemeElement.whiteColor
    }
    
    public var themeBackgroundColorHighlighted: UIColor {
        return UIColor(rgb: (238, 239, 241))
    }
    
    public var themeTintColor: UIColor {
        return UIColor.Behance.blue
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
        return FFThemeElement.separatorColor
    }
    
    public var themeGridItemTintColor: UIColor {
        return UIColor(rgb: (238, 239, 241))

    }
}
