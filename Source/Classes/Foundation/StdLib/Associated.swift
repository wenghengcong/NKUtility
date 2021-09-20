//
//  Associated.swift
//  NKUtility
//
//  Created by Hunt on 2021/9/19.
//

import Foundation

private class Associated<T>: NSObject {
    let value: T
    init(_ value: T) {
        self.value = value
    }
}

public protocol Associable {}

public extension Associable where Self: AnyObject {
    
    public func getAssociatedObject<T>(_ key: UnsafeRawPointer) -> T? {
        return (objc_getAssociatedObject(self, key) as? Associated<T>).map { $0.value }
    }
    
    public func setAssociatedObject<T>(_ key: UnsafeRawPointer, _ value: T?) {
        objc_setAssociatedObject(self, key, value.map { Associated<T>($0) }, .OBJC_ASSOCIATION_RETAIN)
    }
    
}

extension NSObject: Associable {}
