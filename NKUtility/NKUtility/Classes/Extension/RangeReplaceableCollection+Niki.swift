//
//  RangeReplaceableCollection+Niki.swift
//  FireFly
//
//  Created by Hunt on 2020/12/6.
//

import Foundation

extension RangeReplaceableCollection where Self: StringProtocol {
    var digits: Self { filter(\.isWholeNumber) }
    
    var digitsAndPeriods: Self { filter(\.isDecimalOrPeriod) }

    mutating func removeAllNonNumeric() {
        removeAll { !$0.isWholeNumber }
    }
}
