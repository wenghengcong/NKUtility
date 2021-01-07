//
//  NSManagedObject+Niki.swift
//  FireFly
//
//  Created by Hunt on 2020/11/29.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    class var entityName: String! {
        get {
            let classString = NSStringFromClass(self)
                    // The entity is the last component of dot-separated class name:
                    let components = classString.components(separatedBy:".")
            let name = components.last ?? classString
            return name
        }
    }

    // MARK: -  Init
    convenience init(entityName: String, insertInto context: NSManagedObjectContext?) {
        guard !entityName.isEmpty, context != nil else {
            self.init(context: (context ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)))
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context!)
        self.init(entity: entity!, insertInto: context)
    }
    
    convenience init(insertInto context: NSManagedObjectContext?) {
        guard context != nil else {
            self.init(context: (context ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)))
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: context!)
        self.init(entity: entity!, insertInto: context)
    }
    
    // MARK: -  Action
    public static func insertNewObject(inContext moc: NSManagedObjectContext) -> NSManagedObject {
        let newObject = NSEntityDescription.insertNewObject(forEntityName: entityName , into: moc)
        return newObject
    }
    
    /**
     Returns a new managed object with the given entity name in the given managed object context.
     
     :param: entityName The name of the entity to create.
     :param: context The context in which to create the entity.
     
     :returns: A new managed object context inserted in the given context.
     */
    class func insertNewObject(entityName: String, context: NSManagedObjectContext) -> NSManagedObject {
        let newObject = NSEntityDescription.insertNewObject(forEntityName: entityName , into: context)
        return newObject
    }
    
    
    public func delete() {
        self.managedObjectContext?.delete(self)
     }
     
     public func refresh(mergeChanges : Bool) {
        self.managedObjectContext?.refresh(self, mergeChanges: mergeChanges)
     }
}
