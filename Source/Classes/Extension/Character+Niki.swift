//
//  Character+Niki.swift
//  FireFly
//
//  Created by Hunt on 2020/12/6.
//

import Foundation


public extension Character {
    var isDecimalOrPeriod: Bool { "0"..."9" ~= self || self == "." }
}
