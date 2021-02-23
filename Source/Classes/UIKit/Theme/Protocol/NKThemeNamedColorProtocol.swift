//
//  ThemeGlobalColorProtocol.swift
//  FireFly
//
//  Created by Hunt on 2020/10/26.
//

import Foundation
import UIKit

/// 全局使用的颜色协议：用于在 NKThemeConfigProtocol 继承，NKThemeConfigProtocol 继承类需要实现这些颜色
public protocol NKThemeNamedColorProtocol {
    // MARK:  - 全局颜色 Global Color
    static var clearColor: UIColor { get }
    static var whiteColor: UIColor { get }
    static var blackColor: UIColor { get  }
    static var grayColor: UIColor { get  }
    static var grayDarkenColor: UIColor { get  }
    static var grayLightenColor: UIColor { get  }
    static var redColor: UIColor { get  }
    static var greenColor: UIColor { get  }
    static var blueColor: UIColor { get  }
    static var yellowColor: UIColor { get  }
    static var linkColor: UIColor { get  }
    static var disabledColor: UIColor { get  }
    static var backgroundColor: UIColor { get  }
    static var maskDarkColor: UIColor { get  }
    static var maskLightColor: UIColor { get  }
    static var separatorColor: UIColor { get  }
    static var separatorDashedColor: UIColor { get  }
    static var placeholderColor: UIColor { get  }
    
    static var testColorRed: UIColor { get  }
    static var testColorGreen: UIColor { get  }
    static var testColorBlue: UIColor { get  }
}
