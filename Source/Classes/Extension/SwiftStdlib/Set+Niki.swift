//
//  Set+Niki.swift
//  NKUtility
//
//  Created by Nemo on 2022/9/2.
//

import Foundation

extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}
