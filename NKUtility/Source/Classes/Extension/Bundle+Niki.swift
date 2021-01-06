//
//  Bundle+Ext.swift
//  FireFly
//
//  Created by Hunt on 2020/11/9.
//

import UIKit

extension Bundle {

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
