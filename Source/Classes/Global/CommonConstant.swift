//
//  CommonConstant.swift
//  FireFly
//
//  Created by Hunt on 2020/11/9.
//

import Foundation
import UIKit

enum AppLanguage: String {
    case en = "en"
    case cn = "zh-Hans"
}

enum PlistError: Error {
    case `nil`(String)
    case nsData(String)
    case json(String)
}
