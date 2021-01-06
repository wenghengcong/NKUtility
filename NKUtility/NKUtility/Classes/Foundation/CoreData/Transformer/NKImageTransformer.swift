//
//  FFImageTransformer.swift
//  FireFly
//
//  Created by Hunt on 2020/9/25.
//

import Foundation
import UIKit

class NKImageTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }
        
        return UIImage(data: data)
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else {
            return nil
        }
        return image.pngData()
    }
}
