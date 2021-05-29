//
//  NSManagedObject+NKQuery.swift
//  FireFly
//
//  Created by Hunt on 2020/12/3.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    /// create fetch request with key and value
    /// - Parameters:
    ///   - key: object's property
    ///   - value: the value of the key
    /// - Returns: fetch request
    public static func fetchRequest(key: String, value: String) -> NSFetchRequest<NSFetchRequestResult>? {
        guard key.isEmpty || value.isEmpty else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", key, value)
        
        return fetchRequest
    }
    
    ///  获取所有 entity
    /// - Parameter moc: <#moc description#>
    /// - Returns: <#description#>
    public static func findAll(context moc:NSManagedObjectContext) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let objects = try moc.fetch(fetchRequest) as! [NSManagedObject]
            return objects
        } catch let error {
            //NKlogger.debug(error)
        }
        
        return []
    }
    
    ///  根据条件查询
    /// - Parameters:
    ///   - sortBy: <#sortBy description#>
    ///   - moc: <#moc description#>
    ///   - w: <#w description#>
    /// - Returns: <#description#>
    public static func find(sortBy:[NSSortDescriptor]? = nil,context moc:NSManagedObjectContext, where w:NSPredicate? = nil) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = w
        request.sortDescriptors = sortBy
        do {
            let result = try moc.fetch(request) as! [NSManagedObject]
            return result
        } catch let error as NSError {
            NKlogger.debug(error)
            return []
        }
    }
    
    /// 根据条件查询对应的
    /// - Parameters:
    ///   - limit: <#limit description#>
    ///   - sortBy: <#sortBy description#>
    ///   - moc: <#moc description#>
    ///   - w: <#w description#>
    /// - Returns: <#description#>
    public static func findLimited(limit:Int, sortBy:[NSSortDescriptor]? = nil, context moc:NSManagedObjectContext, where w:NSPredicate? = nil) -> [Any] {
        return findLimited(limit: limit, offset: 0, sortBy: sortBy, context: moc, where: w)
    }
    
    public static func findLimited(limit:Int, offset: Int, sortBy:[NSSortDescriptor]? = nil, context moc:NSManagedObjectContext, where w:NSPredicate? = nil) -> [Any] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = w
        request.fetchLimit = limit
        request.fetchOffset = offset
        request.sortDescriptors = sortBy
        do {
           let result = try moc.fetch(request)
            return result
        } catch let error as NSError {
            NKlogger.debug(error)
        }
        return []
    }
    
    
    /// 查找，未查询到就创建一个 entity
    /// - Parameters:
    ///   - predicate: <#predicate description#>
    ///   - moc: <#moc description#>
    /// - Returns: <#description#>
    public static func findOrCreate(predicate: NSPredicate, context moc: NSManagedObjectContext) -> NSManagedObject {
        //First we should fetch an existing object in the context as a performance optimization
        guard let existingObject = moc.find(objectMatchingPredicate: predicate, entityName: entityName) else {
            return fetchOrCreate(objectMatchingPredicate: predicate, context: moc)
        }
        return existingObject
    }
    
    
    /// 根据 identifier 进行查找，未找到就创建一个
    /// - Parameters:
    ///   - identifier: 标识符
    ///   - moc: <#moc description#>
    /// - Returns: <#description#>
    public static func findOrCreate(identifier: String, context moc: NSManagedObjectContext) -> NSManagedObject {
        let obj = fetchOrCreate(objectMatchingPredicate: NSPredicate(format: "identifier == %@", identifier), context: moc) 
        obj.setValue(identifier, forKey: "identifier")
        return obj
    }
    
    public static func findOne(sortBy:[NSSortDescriptor]? = nil, context moc:NSManagedObjectContext, where w:NSPredicate? = nil) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.fetchLimit = 1
        request.predicate = w
        request.sortDescriptors = sortBy
        var result: NSManagedObject?
        do {
            let ret = try moc.fetch(request)
            result = ret.last as? NSManagedObject
        } catch let error as NSError {
            NKlogger.debug(error)
            result = nil
        }
        return result
    }

    private static func fetchOrCreate(objectMatchingPredicate predicate: NSPredicate,
                                     context moc: NSManagedObjectContext) -> NSManagedObject {
        //if it's not in memory, we should execute a fetch to see if it exists
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let objects = try moc.fetch(fetchRequest)
            if objects.count > 0 {
                return objects.first as! NSManagedObject
            }
        } catch let error {
            NKlogger.debug(error)
        }
        
        //If it didn't exist in memory and wasn't fetched, we should create a new object
        return insertNewObject(inContext: moc)
        
    }
}
