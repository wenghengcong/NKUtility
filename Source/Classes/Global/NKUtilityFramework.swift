//
//  NKUtilityFramework.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/8.
//

import Foundation

public class NKBundleToken {}

public class NKUtilityFramework: NSObject {
    
    @objc public static var bundle: Bundle { return Bundle(for: self) }
    @objc public static let resourceBundle: Bundle = {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        guard let url = bundle.resourceURL?.appendingPathComponent("NKUtilityResource.bundle", isDirectory: true), let bundle = Bundle(url: url) else {
            preconditionFailure("FluentUI resource bundle is not found")
        }
        return bundle
#endif
    }()
    
    @objc public static let colorsBundle: Bundle = {
        #if SWIFT_PACKAGE
        return SharedResources.colorsBundle
        #else
        return resourceBundle
        #endif
    }()
}
