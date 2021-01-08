//
//  NSAttributedString+Niki.swift
//  FireFly
//
//  Created by Hunt on 2020/11/9.
//

import Foundation
import UIKit

public extension NSAttributedString {

    func height(with width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return boundingBox.height
    }

    func width(with height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return boundingBox.width
    }

}
