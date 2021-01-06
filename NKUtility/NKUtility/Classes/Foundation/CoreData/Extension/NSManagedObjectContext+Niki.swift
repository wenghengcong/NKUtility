//
//  NSManagedObjectContext+Extension.swift
//  FireFly
//
//  Created by Hunt on 2020/9/25.
//

import Foundation
import CoreData

/// Describes the result type for saving a managed object context.
public typealias NKCDCompletionHandler = (Result<NSManagedObjectContext, Error>) -> Void


// MARK: - Save
extension NSManagedObjectContext {
    
    /// Describes a child managed object context.
    public typealias ChildContext = NSManagedObjectContext
    
    /// Attempts to **asynchronously** commit unsaved changes to registered objects in the context.
    /// This function is performed in a block on the context's queue. If the context has no changes,
    /// then this function returns immediately and the completion block is not called.
    ///
    /// - Parameter completion: The closure to be executed when the save operation completes.
    public func saveAsync(completion:NKCDCompletionHandler? = nil) {
        _save(wait: false, completion: completion)
    }
    
    /// Attempts to **synchronously** commit unsaved changes to registered objects in the context.
    /// This function is performed in a block on the context's queue. If the context has no changes,
    /// then this function returns immediately and the completion block is not called.
    ///
    /// - Parameter completion: The closure to be executed when the save operation completes.
    public func saveSync(completion:NKCDCompletionHandler? = nil) {
        _save(wait: true, completion: completion)
    }
    
    /// Attempts to commit unsaved changes to registered objects in the context.
    ///
    /// - Parameter wait: If `true`, saves synchronously. If `false`, saves asynchronously.
    /// - Parameter completion: The closure to be executed when the save operation completes.
    private func _save(wait: Bool, completion:NKCDCompletionHandler? = nil) {
        let block = {
//            guard self.hasChanges else { return }
            do {
                try self.save()
                completion?(.success(self))
            } catch {
                completion?(.failure(error))
            }
        }
        wait ? performAndWait(block) : perform(block)
    }
    
    public func find(objectMatchingPredicate predicate: NSPredicate) -> NSManagedObject? {
        for object in self.registeredObjects where !object.isFault {
            if predicate.evaluate(with: object) {
                return object
            }
        }
        
        return nil
    }
    
    func insertNewEntity(entityName: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self)
    }
    
    func getObjectsForEntity(entityName: String, sortArray: [String: Bool]?) throws -> [AnyObject]? {
        return try searchObjectsForEntity(entityName: entityName, predicate: nil, sortArray: sortArray)
    }
    
    func searchObjectsForEntity(entityName: String, predicate: NSPredicate?, sortArray: [String: Bool]?) throws -> [AnyObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        if let sortArray = sortArray {
            var sortDescriptorArray = [NSSortDescriptor]()
            for (key, value) in sortArray {
                sortDescriptorArray.append(NSSortDescriptor(key: key, ascending: value))
            }
            fetchRequest.sortDescriptors = sortDescriptorArray
        }
        
        return try fetch(fetchRequest)
    }
    
    func countForEntity(entityName: String) throws -> Int {
        return try countForEntity(entityName: entityName, predicate: nil)
    }
    
    func countForEntity(entityName: String, predicate: NSPredicate?) throws -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        return try count(for: fetchRequest)
    }
    
    func deleteObjectForEntity(managedObject: NSManagedObject) -> Bool {
        delete(managedObject)
        return true
    }
    
    func deleteLastObjectsForEntity(entityName: String) throws -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        
        do {
            let fetchResultArray = try fetch(fetchRequest)
            guard let lastResult = fetchResultArray.last as? NSManagedObject else {
                return false
            }
            delete(lastResult)
            return true
        } catch {
            return false
        }
    }
    
    func deleteAllObjectsForEntity(entityName: String) throws -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        
        do {
            let fetchResultArray = try fetch(fetchRequest)
            guard let resultArray = fetchResultArray as? [NSManagedObject] else {
                return false
            }
            resultArray.forEach { delete($0) }
            return true
        } catch {
            return false
        }
    }
}

