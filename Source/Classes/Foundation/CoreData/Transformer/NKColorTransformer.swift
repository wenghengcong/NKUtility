//
//  NKCDColorTransformer.swift
//  FireFly
//
//  Created by Hunt on 2020/11/5.
//

import Foundation
import UIKit

class NKColorTransformer: ValueTransformer {

    // Here we indicate that our converter supports two-way conversions.
    // That is, we need  to convert UICOLOR to an instance of NSData and back from an instance of NSData to an instance of UIColor.
    // Otherwise, we wouldn't be able to beth save and retrieve values from the persistent store.
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    // Takes a UIColor, returns an NSData
    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }

        guard let components: [CGFloat] = color.cgColor.components else { return nil }

        let colorAsString: String = String(format: "%f,%f,%f,%f", components[0], components[1], components[2], components[3])

        return colorAsString.data(using: .utf8)
    }

    // Takes an NSData, returns a UIColor
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }

        guard let colorAsString = String(data: data, encoding: .utf8) else { return nil }

        let componets: [String] = colorAsString.components(separatedBy: ",")

        var values: [Float] = []

        for component in componets {
            guard let value = Float(component) else { return nil }
            values.append(value)
        }

        let red: CGFloat = CGFloat(values[0])
        let green: CGFloat = CGFloat(values[1])
        let blue: CGFloat = CGFloat(values[2])
        let alpha: CGFloat = CGFloat(values[3])

       return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
