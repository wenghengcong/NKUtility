//
//  FFRedTheme.swift
//  FireFly
//
//  Created by Hunt on 2020/10/27.
//

import Foundation
import UIKit

struct FFGrassTheme: NKThemeProtocol {
    static let shared = FFLightTheme()

    var themeName: String {
        return "Grass"
    }
    
    var themeBackgroundColor: UIColor {
        return FFThemeElement.backgroundColor
    }
    
    var themeBackgroundColorLighten: UIColor {
        return FFThemeElement.whiteColor
    }
    
    var themeBackgroundColorHighlighted: UIColor {
        return UIColor(rgb: (238, 239, 241))
    }
    
    var themeTintColor: UIColor {
        return UIColor.NKTheme.Grass
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
        return UIColor(rgb: (222, 224, 226))
    }
    
    var themeGridItemTintColor: UIColor {
        return UIColor(rgb: (238, 239, 241))

    }
}
