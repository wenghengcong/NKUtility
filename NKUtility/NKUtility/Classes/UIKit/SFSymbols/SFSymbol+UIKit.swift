//
//  SFSymbol+UIKit.swift
//  FireFly
//
//  Created by Hunt on 2020/11/22.
//

import Foundation
import UIKit


@available(iOS 13.0, *)
public extension SFSymbol {
    var image: UIImage {
        UIImage(systemName: rawValue)!
    }
    func image(textStyle: UIFont.TextStyle) -> UIImage {
        UIImage(symbolName: rawValue, pointSize: nil, font: nil, weight: nil, scale: nil, textStyle: textStyle, tintColor: nil)!
    }
    
    func image(font: UIFont) -> UIImage {
        UIImage(symbolName: rawValue, pointSize: nil, font: font, weight: nil, scale: nil, textStyle: nil, tintColor: nil)!
    }
    var ultraLightWeight: UIImage {
        image.ultraLightWeight
    }
    var thinWeight: UIImage {
        image.thinWeight
    }
    var lightWeight: UIImage {
        image.lightWeight
    }
    var regularWeight: UIImage {
        image.regularWeight
    }
    var mediumWeight: UIImage {
        image.mediumWeight
    }
    var semiboldWeight: UIImage {
        image.semiboldWeight
    }
    var boldWeight: UIImage {
        image.boldWeight
    }
    var heavyWeight: UIImage {
        image.heavyWeight
    }
    var blackWeight: UIImage {
        image.blackWeight
    }
    
    var smallScale: UIImage {
        image.smallScale
    }
    var mediumScale: UIImage {
        image.mediumScale
    }
    var largeScale: UIImage {
        image.largeScale
    }
}

@available(iOS 13.0, *)
public extension UIImage {
    
    var ultraLightWeight: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(weight: .ultraLight))!
    }
    var thinWeight: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(weight: .thin))!
    }
    var lightWeight: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(weight: .light))!
    }
    var regularWeight: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(weight: .regular))!
    }
    var mediumWeight: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(weight: .medium))!
    }
    var semiboldWeight: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(weight: .semibold))!
    }
    var boldWeight: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(weight: .bold))!
    }
    var heavyWeight: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(weight: .heavy))!
    }
    var blackWeight: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(weight: .black))!
    }

    var smallScale: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(scale: .small))!
    }
    var mediumScale: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(scale: .medium))!
    }
    var largeScale: UIImage {
        return applyingSymbolConfiguration(SymbolConfiguration(scale: .large))!
    }
}
