//
//  NKFont+Extension.swift
//  DuZi
//
//  Created by Nemo on 2022/8/24.
//

import Foundation
import CoreGraphics
import SwiftUI
import UIKit

/// SwiftUI 支持
#if canImport(SwiftUI)

@available(tvOS 13.0, iOS 13.0, *)
extension Font {
    /// Create a UIFont object with a `Font` enum
    init(font: NKBuiltInFont, size: CGFloat) {
        self = Font.custom(font.rawValue, size: size)
    }
}
#endif
