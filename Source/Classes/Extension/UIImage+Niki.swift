//
//  UIImage+Niki.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/21.
//

import Foundation
import UIKit


public extension UIImage {
    convenience init?(bundledNamed: String, bundleNames: [String]) {
        let bundle = Bundle.frameworkBundle(bundleNames: bundleNames)
        self.init(named: bundledNamed, in: bundle, compatibleWith: nil)
        
    }
    
    class func bundledImage(named: String, bundleNames: [String]) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            let bundle = Bundle.frameworkBundle(bundleNames: bundleNames)
            let bundleImage = UIImage(named: named, in: bundle, compatibleWith: nil)
            return bundleImage
        }
        return image
    }
}

// MARK: - Only for NKUtility
public extension UIImage {
    
    convenience init?(nkBundleNamed: String) {
        self.init(named: nkBundleNamed, in: Bundle.nikiFrameworkBundle(), compatibleWith: nil)
    }
    
    class func nkBundleImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            let bundleImage = UIImage(named: named, in: Bundle.nikiFrameworkBundle(), compatibleWith: nil)
            return bundleImage
        }
        return image
    }
}
