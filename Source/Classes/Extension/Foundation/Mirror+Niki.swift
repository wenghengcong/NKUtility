//
//  Mirror+Niki.swift
//  NKUtility
//
//  Created by Hunt on 2021/2/24.
//

import Foundation

/*
 //将对象进行反射
 let hMirror = Mirror(reflecting: theme)
 NKlogger.debug("对象类型：\(hMirror.subjectType)")
 NKlogger.debug("对象子元素个数：\(hMirror.children.count)")
 NKlogger.debug("--- 对象子元素的属性名和属性值分别如下 ---")
 for case let (label?, value) in hMirror.children {
 NKlogger.debug("属性：\(label)     值：\(value)")
 }
 
 https://stackoverflow.com/a/38424653/4124634
 注意：反射不用用于计算属性，只能用于存储属性
 */

/// 反射协议
public protocol NKPropertyReflectableProtocol { }

/// 反射协议
public extension NKPropertyReflectableProtocol {
    public subscript(key: String) -> Any? {
        let m = Mirror(reflecting: self)
        for child in m.children {
            if child.label == key { return child.value }
        }
        return nil
    }
}

protocol _Optional {
    var isNil: Bool { get }
}

extension Optional: _Optional {
    var isNil: Bool { return self == nil }
}

public extension Mirror {
    public static func isOptional(any: Any) -> Bool {
        guard let style = Mirror(reflecting: any).displayStyle,
              style == .optional else { return false }
        return true
    }
    
    public static func isNil (_ input: Any) -> Bool {
        return (input as? _Optional)?.isNil ?? false
    }
}

public extension Mirror.DisplayStyle {
    public  func equals(displayCase: Mirror.DisplayStyle) -> Bool {
        return self == displayCase
    }
}
