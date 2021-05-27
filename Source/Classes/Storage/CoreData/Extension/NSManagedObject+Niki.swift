//
//  NSManagedObject+Niki.swift
//  FireFly
//
//  Created by Hunt on 2020/11/29.
//

import Foundation
import CoreData

public extension NSManagedObject {
    
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

    class public func deleteAll(entityName: String, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
        }
    }
    
    
    public func delete() {
        self.managedObjectContext?.delete(self)
    }

    public func refresh(mergeChanges : Bool) {
        self.managedObjectContext?.refresh(self, mergeChanges: mergeChanges)
    }
}

public extension NSManagedObject {


    /// 返回属性-值-类型信息
    /// - Returns: 元组列表
    public func propertyMapper() -> [(name: String, value: Any, type: String)] {
        var mapper: [(name: String, value: Any, type: String)] = []
        for (name, attr) in entity.attributesByName {
            let attrType = attr.attributeType // NSAttributeType enumeration for the property type
            let attrClass = attr.attributeValueClassName ?? "unknown"
            let value = value(forKey: name)
            //            print(name, "=", value, "type =", attrClass)
            let one = (name: name, value:value, type: attrClass)
            mapper.append(one)
        }
        return mapper
    }

    /// 返回属性-类型信息
    /// - Returns: 字典
    public func propertyTypeMapper() -> [String: String] {
        var typeMapper = [String: String]()
        for (name, attr) in entity.attributesByName {
            let attrType = attr.attributeType // NSAttributeType enumeration for the property type
            let attrClass = attr.attributeValueClassName ?? "unknown"
            typeMapper[name] = attrClass
        }
        return typeMapper
    }
    
    public func propertyJsonInsnake_case() -> Dictionary<String, Any> {
        var mappepJson = [String: Any]()
        for (name, attr) in entity.attributesByName {
            let attrType = attr.attributeType // NSAttributeType enumeration for the property type
            let attrClass = attr.attributeValueClassName ?? "unknown"
            let value = value(forKey: name)
            let namesnake_case = name.camelCaseTosnake_case()
            mappepJson[namesnake_case] = value
        }
        return mappepJson
    }
    
    public func propertyJsonInCamelCase() -> Dictionary<String, Any> {
        var mappepJson = [String: Any]()
        for (name, attr) in entity.attributesByName {
            let attrType = attr.attributeType // NSAttributeType enumeration for the property type
            let attrClass = attr.attributeValueClassName ?? "unknown"
            let value = value(forKey: name)
            let nameCamelCase = name.snake_caseToCamelCase()
            mappepJson[nameCamelCase] = value
        }
        return mappepJson
    }

    public func propertyJson() -> Dictionary<String, Any> {
        var mappepJson = [String: Any]()
        for (name, attr) in entity.attributesByName {
            let attrType = attr.attributeType // NSAttributeType enumeration for the property type
            let attrClass = attr.attributeValueClassName ?? "unknown"
            let value = value(forKey: name)
            mappepJson[name] = value
        }
        return mappepJson
    }
}
