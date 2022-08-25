//
//  NKFont.swift
//  DuZi
//
//  Created by Nemo on 2022/8/24.
//

import Foundation
import SwiftUI
import UIKit
import NKUtility

public protocol NKFontRepresentable: RawRepresentable {}

extension NKFontRepresentable where Self.RawValue == String {
    /// An alternative way to get a particular `UIFont` instance from a `NKBuiltInFont`
    /// value.
    ///
    /// - parameter of size: The desired size of the font.
    ///
    /// - returns a `UIFont` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func ofSize(_ fontSize: CGFloat) -> UIFont {
        var font = UIFont(name: rawValue, size: fontSize)
        if font == nil {
            font = UIFont.systemFont(ofSize: fontSize)
        }
        return font!
    }
    
    // MARK: = textStyle
    public func forTextStyle(_ style: UIFont.TextStyle) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: style)
        return font
    }
    
    /**
     Creates a dynamic font object sized based on the given parameters.
     
     When used to set the text value of a label or text view, set `adjustsFontForContentSizeCategory` to `true`.
     
     - Important: The `adjustsFontForContentSizeCategory` property on `UILabel`, `UITextView`, etc. only works for the `preferred` weight with a nil `maxSize` value. In any other case, you will need to update the font either in `traitCollectionDidChange()` or by observing the `UIContentSizeCategoryDidChange` notification.
     
     - Parameters:
        - textStyle: The text style used to scale the text.
        - maxSize: Size which the text may not exceed.
     
     - Returns: A system font object corresponding to the given parameters.
     */
    public func forTextStyle(_ style: UIFont.TextStyle, maxSize: CGFloat? = nil) -> UIFont {
        if maxSize == nil {
            return forTextStyle(style)
        }
        
        let pointSize = UIFont.preferredFont(forTextStyle: style).pointSize
        
        if let maxSize = maxSize, pointSize > maxSize {
            return ofSize(maxSize)
        } else {
            return ofSize(pointSize)
        }
    }

    // MARK: - SwiftUI
    @available(tvOS 13.0, iOS 13.0, *)
    public func of(_ size: CGFloat) -> Font {
        UIFont.preferredFont(forTextStyle: .body)
        return .custom(rawValue, size: size)
    }

    @available(tvOS 13.0, iOS 13.0, *)
    public func of(_ size: Double) -> Font {
        return .custom(rawValue, size: CGFloat(size))
    }
    
    
}
