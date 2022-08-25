//
//  UIFont+Extension.swift
//  DuZi
//
//  Created by Nemo on 2022/8/24.
//

import Foundation
import UIKit

extension UIFont {
    /// Create a UIFont object with a `Font` enum
    public convenience init?(font: NKBuiltInFont, size: CGFloat) {
        let fontIdentifier: String = font.rawValue
        self.init(name: fontIdentifier, size: size)
    }
}
