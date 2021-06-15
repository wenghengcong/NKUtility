//
//  Bundle+Niki.swift
//  FireFly
//
//  Created by Hunt on 2020/11/9.
//

import UIKit

public extension Bundle {
    /// 中文Bundle
    class var cnBundle: Bundle {
        return langBundle(AppLanguage.cn.rawValue)
    }

    /// 英文Bundle
    class var enBundle: Bundle {
        return langBundle(AppLanguage.en.rawValue)
    }

    /// APP语言Bundle
    class var appBundle: Bundle {
        let appLang = NKLanguage.appLanguage
        return langBundle(appLang)
    }

    /// 根据语言返回Bundle
    ///
    /// - Parameter language: <#language description#>
    /// - Returns: <#return value description#>
    class func langBundle(_ language: String) -> Bundle {
        if language.isEmpty {
            return Bundle.main
        } else {
            if let pathR = Bundle.main.path(forResource: language, ofType: "lproj") {
                let bundle = Bundle(path: pathR)!
                return bundle
            } else {
                return Bundle.main
            }
        }
    }

}

public extension Bundle {

    // This is copied method from SPM generated Bundle.module for CocoaPods support
    static func frameworkBundle(bundleNames: [String]) -> Bundle {
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            // Bundle should be present here when the package is linked into a framework.
            NKUtilityFramework.bundle.resourceURL,
            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for bundleName in bundleNames {
            for candidate in candidates {
                let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
                if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                    return bundle
                }
            }
        }
        // Return whatever bundle this code is in as a last resort.
        return NKUtilityFramework.bundle
    }
}
