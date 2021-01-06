//
//  NKCoreDataEntityProtocol.swift
//  FireFly
//
//  Created by Hunt on 2020/11/29.
//

import Foundation
import CoreData

/// Describes an entity in Core Data.
public protocol NKCoreDataEntityProtocol: AnyObject {

    /// The name of the entity.
    static var entityName: String { get }

    /// The default sort descriptors for a fetch request.
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension NKCoreDataEntityProtocol where Self: NSManagedObject {

    /// Returns a default entity name for this managed object based on its class name.
    public static var entityName: String {
        "\(Self.self)"
    }

    /// Returns a new fetch request with `defaultSortDescriptors`.
    public static var fetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request as! NSFetchRequest<Self>
    }

    /// Returns the entity with the specified name from the managed object model associated
    /// with the specified managed object context’s persistent store coordinator.
    ///
    /// - parameter context: The managed object context to use.
    ///
    /// - returns: Returns the entity description for this managed object.
    public static func entity(context: NSManagedObjectContext) -> NSEntityDescription {
        NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }
}
