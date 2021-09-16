//
//  NKNameDescribable.swift
//  NKUtility
//
//  Created by Hunt on 2021/9/17.
//

import Foundation

protocol NKNameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension NKNameDescribable {
    var typeName: String {
        return String(describing: type(of: self))
    }

    static var typeName: String {
        return String(describing: self)
    }
}

// Extend with class/struct/enum...
extension NSObject: NKNameDescribable {}
extension Array: NKNameDescribable {}
extension UIBarStyle: NKNameDescribable { }
