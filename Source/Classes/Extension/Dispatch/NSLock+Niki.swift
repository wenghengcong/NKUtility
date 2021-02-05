//
//  NSLock+Niki.swift
//  Alamofire
//
//  Created by Hunt on 2021/2/6.
//

import Foundation

public extension NSLock {
    
    /// do task in lock closures
    /// from https://stackoverflow.com/a/62620203/4124634
    /// @discardableResult 是 Swift 用于禁止显示 Result unused 警告的一个属性。
    /// - Parameter block: <#block description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    @discardableResult
    func with<T>(_ block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
