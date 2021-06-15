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
        guard let url = bundle.resourceURL?.appendingPathComponent("NKUtility.bundle", isDirectory: true), let bundle = Bundle(url: url) else {
            preconditionFailure("NKUtility resource bundle is not found")
        }
        return bundle
    }()
}
