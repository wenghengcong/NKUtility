//
//  NKFoundationGlobal.swift
//  FireFly
//
//  Created by Hunt on 2020/11/24.
//

import UIKit
import Foundation

public func isNsnullOrNil(object : Any?) -> Bool {
    if (object is NSNull) || (object == nil) {
        return true
    } else {
        return false
    }
}
