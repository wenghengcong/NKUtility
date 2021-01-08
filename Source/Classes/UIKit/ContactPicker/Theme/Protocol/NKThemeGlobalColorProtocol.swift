//
//  ThemeGlobalColorProtocol.swift
//  FireFly
//
//  Created by Hunt on 2020/10/26.
//

import Foundation
import UIKit

public protocol NKThemeGlobalColorProtocol {
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
