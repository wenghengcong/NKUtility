//
//  NKStoreType.swift
//  FireFly
//
//  Created by Hunt on 2020/11/29.
//

import Foundation
import CoreData

/// Describes a Core Data persistent store type.
public enum NKStoreType: Equatable {

    /// The SQLite database store type. The associated file URL specifies the directory for the store.
    case sqlite(URL)

    /// The binary store type. The associated file URL specifies the directory for the store.
    case binary(URL)

    /// The in-memory store type.
    case inMemory

    // MARK: Properties

    /// Returns the type string description for the store type.
    public var type: String {
        switch self {
        case .sqlite: return NSSQLiteStoreType
        case .binary: return NSBinaryStoreType
        case .inMemory: return NSInMemoryStoreType
        }
    }

    // MARK: Methods

    /**
     - note: If the store is in-memory, then this value will be `nil`.
     - returns: The file URL specifying the directory in which the store is located.
     */
    public func storeDirectory() -> URL? {
        switch self {
        case let .sqlite(url): return url
        case let .binary(url): return url
        case .inMemory: return nil
        }
    }
}

extension NKStoreType: CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        self.type
    }
}
