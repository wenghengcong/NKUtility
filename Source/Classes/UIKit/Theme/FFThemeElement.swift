//
//  LightTheme.swift
//  FireFly
//
//  Created by Hunt on 2020/10/25.
//

import Foundation
import UIKit

/// 为主题提供一些基本元素，比如颜色、字体、图片等等
public struct FFThemeElement: NKThemeGlobalColorProtocol {
    public static var clearColor: UIColor {
        return UIColor(rgba: (255, 255, 255, 0))
    }
    
    public static var whiteColor: UIColor {
        return UIColor(rgb: (255, 255, 255))
    }
    
    public static var blackColor: UIColor {
        return UIColor(rgb: (0, 0, 0))
    }
    
    public static var grayColor: UIColor {
        return UIColor(rgb: (179, 179, 179))
    }
    
    public static var grayDarkenColor: UIColor {
        return UIColor(rgb: (163, 163, 163))
    }
    
    public static var grayLightenColor: UIColor {
        return UIColor(rgb: (198, 198, 198))
    }
    
    public static var redColor: UIColor {
        return UIColor(rgb: (250, 58, 58))
    }
    
    public static var greenColor: UIColor {
        return UIColor(rgb: (159, 214, 97))
    }
    
    public static var blueColor: UIColor {
        return UIColor(rgb: (49, 189, 243))
    }
    
    public static var yellowColor: UIColor {
        return UIColor(rgb: (255, 207, 71))
    }
    
    public static var linkColor: UIColor {
        return UIColor(rgb: (56, 116, 171))
    }
    
    public static var disabledColor: UIColor {
        return UIColor(rgba: (0, 0, 0, 0.35))
    }
    
    public static var backgroundColor: UIColor {
        return UIColor(rgb: (246, 246, 246))
    }
    
    public static var maskDarkColor: UIColor {
        return UIColor(rgba: (0, 0, 0, 0.35))
    }
    
    public static var maskLightColor: UIColor {
        return UIColor(rgba: (255, 255, 255, 0))
    }
    
    public static var separatorColor: UIColor {
        return UIColor(rgb: (222, 224, 226))
    }
    
    public static var separatorDashedColor: UIColor {
        return UIColor(rgb: (17, 17, 17))
    }
    
    public static var placeholderColor: UIColor {
        return UIColor(rgb: (196, 200, 208))
    }
    
    public static var testColorRed: UIColor {
        return UIColor(rgba: (255, 0, 0, 0.3))
    }
    
    public static var testColorGreen: UIColor {
        return UIColor(rgba: (0, 255, 0, 0.3))
    }
    
    public static var testColorBlue: UIColor {
        return UIColor(rgba: (0, 0, 255, 0.3))
    }
}

public extension UIColor {
    struct NKGray {
        public static var level1 = UIColor(rgb: (53, 60, 70))
        public static var level2 = UIColor(rgb: (73, 80, 90))
        public static var level3 = UIColor(rgb: (93, 100, 110))
        public static var level4 = UIColor(rgb: (113, 120, 130))
        public static var level5 = UIColor(rgb: (133, 140, 150))
        public static var level6 = UIColor(rgb: (153, 160, 170))
        public static var level7 = UIColor(rgb: (173, 180, 190))
        public static var level8 = UIColor(rgb: (196, 200, 208))
        public static var level9 = UIColor(rgb: (216, 220, 228))
    }
    
    struct NKDarkGray {
        public static var level1 = UIColor(rgb: (218, 220, 224))
        public static var level2 = UIColor(rgb: (198, 200, 204))
        public static var level3 = UIColor(rgb: (178, 180, 184))
        public static var level4 = UIColor(rgb: (158, 160, 164))
        public static var level5 = UIColor(rgb: (138, 140, 144))
        public static var level6 = UIColor(rgb: (118, 120, 124))
        public static var level7 = UIColor(rgb: (98, 100, 104))
        public static var level8 = UIColor(rgb: (78, 80, 84))
        public static var level9 = UIColor(rgb: (58, 60, 64))
    }
    
    struct NKTheme {
        public static var Grapefruit = UIColor(rgb: (239, 83, 98))
        public static var Bittersweet = UIColor(rgb: (254, 109, 75))
        public static var Sunflower = UIColor(rgb: (255, 207, 71))
        public static var Grass = UIColor(rgb: (159, 214, 97))
        public static var Mint = UIColor(rgb: (63, 208, 173))
        public static var Aqua = UIColor(rgb: (49, 189, 243))
        public static var BlueJeans = UIColor(rgb: (90, 154, 239))
        public static var Lavender = UIColor(rgb: (172, 143, 239))
        public static var PinkRose = UIColor(rgb: (238, 133, 193))
        public static var Dark = UIColor(rgb: (33, 110, 251))
    }
}
