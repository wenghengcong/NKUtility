//
//  FFRedTheme.swift
//  FireFly
//
//  Created by Hunt on 2020/10/27.
//

import Foundation
import UIKit

public struct FFGrassTheme: NKThemeProtocol {
    public static let shared = FFGrassTheme()

    public var themeName: String {
        return "Grass"
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
        return UIColor.NKTheme.Grass
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
        return UIColor(rgb: (222, 224, 226))
    }
    
    public var themeGridItemTintColor: UIColor {
        return UIColor(rgb: (238, 239, 241))

    }
}
