//
//  FFCoreDataStack.swift
//  FireFly
//
//  Created by Hunt on 2020/9/25.
//

import Foundation
import CoreData

/**
 An instance of `NKCoreDataStack` encapsulates the entire Core Data stack.
 It manages the managed object model, the persistent store coordinator, and managed object contexts.
 
 It is composed of a main context and a background context.
 These two contexts operate on the main queue and a private background queue, respectively.
 Both are connected to the persistent store coordinator and data between them is perpetually kept in sync.
 
 Changes to a child context are propagated to its parent context and eventually the persistent store when saving.
 
 See this [guide](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Conceptual/CoreData/IntegratingCoreData.html#//apple_ref/doc/uid/TP40001075-CH9-SW1) for more details.
 
 */
public class NKCoreDataStack {
    
    private let persistentContainerQueue = OperationQueue()
    
    // MARK: Typealiases
    
    /// Describes the initialization options for a persistent store.
    public typealias NKPersistentStoreDescriptions = [NSPersistentStoreDescription]
    
    
    /// The model for the stack that the factory produces.
    public let model: NKCoreDataModel
    
    /**
     A dictionary that specifies options for the store that the factory produces.
     The default value is `DefaultStoreOptions`.
     */
    public let descriptions: NKPersistentStoreDescriptions?
    
    private lazy var storeContainer: NSPersistentContainer = {
        assert(self.model.name.isNotEmpty, "model name can't be nil");
        var container = NSPersistentContainer(name: self.model.name)
        if #available(iOS 13.0, *) {
            container = NSPersistentCloudKitContainer(name: self.model.name)
        } else {
            // Fallback on earlier versions
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        if let descs = descriptions, descs.count > 0 {
            container.persistentStoreDescriptions = descs
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        
        // Pin the viewContext to the current generation token and set it to keep itself up to date with local changes.
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
        }
        return container
    }()
    
    // MARK: Initialization
    /**
     Constructs a new `CoreDataStackProvider` instance with the specified `model` and `options`.
     
     - parameter model:   The model describing the stack.
     - parameter options: Options for the persistent store.
     
     - returns: A new `CoreDataStackProvider` instance.
     */
    public init(model: NKCoreDataModel,
                descriptions: NKPersistentStoreDescriptions?) {
        self.model = model
        self.descriptions = descriptions
        let _ = self.storeContainer
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(_didReceiveMainContextDidSave(notification:)),
                                       name: .NSManagedObjectContextDidSave,
                                       object: mainContext)
        notificationCenter.addObserver(self,
                                       selector: #selector(_didReceiveBackgroundContextDidSave(notification:)),
                                       name: .NSManagedObjectContextDidSave,
                                       object: backgroundContext)
    }
    
    // MARK: - instance contexts
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let newBack = self.storeContainer.newBackgroundContext()
        return newBack
    }()
    
    lazy var childContext: NSManagedObjectContext = {
        let newChild = newChildContext()
        return newChild
    }()
    
    
    // MARK: - Create New Context
    
    /**
     子上下文用于创建对象，然后又未保存的场景，常见的 add new entity
     Creates a new child context with the specified `concurrencyType` and `mergePolicyType`.
     
     The parent context is either `mainContext` or `backgroundContext` dependending on the specified `concurrencyType`:
     * `.PrivateQueueConcurrencyType` will set `backgroundContext` as the parent.
     * `.MainQueueConcurrencyType` will set `mainContext` as the parent.
     
     Saving the returned context will propagate changes through the parent context and then to the persistent store.
     
     - parameter concurrencyType: The concurrency pattern to use. The default is `.MainQueueConcurrencyType`.
     - parameter mergePolicyType: The merge policy to use. The default is `.MergeByPropertyObjectTrumpMergePolicyType`.
     
     - returns: A new child managed object context.
     */
    public func newChildContext(concurrencyType: NSManagedObjectContextConcurrencyType = .mainQueueConcurrencyType,
                             mergePolicyType: NSMergePolicyType = .mergeByPropertyObjectTrumpMergePolicyType) -> NSManagedObjectContext.ChildContext {
        let childContext = NSManagedObjectContext(concurrencyType: concurrencyType)
        childContext.mergePolicy = NSMergePolicy(merge: mergePolicyType)
        
        switch concurrencyType {
        case .mainQueueConcurrencyType:
            childContext.parent = mainContext
            
        case .privateQueueConcurrencyType:
            childContext.parent = backgroundContext
            
        case .confinementConcurrencyType:
            fatalError("*** Error: ConfinementConcurrencyType is not supported because it is deprecated.")
        @unknown default:
            fatalError("*** Error: unsupported, unknown concurrency type \(concurrencyType).")
        }
        
        if let name = childContext.parent?.name {
            childContext.name = name + ".child"
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_didReceiveChildContextDidSave(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: childContext)
        return childContext
    }
    
    // MARK: - Save
    
    func saveMainContext(completion:NKCDCompletionHandler? = nil) {
        mainContext.saveSync(completion: completion)
    }
    
    func saveChildContext(completion:NKCDCompletionHandler? = nil) {
        childContext.saveSync(completion: completion)
    }
    
    func asyncSaveMainContext(completion:NKCDCompletionHandler? = nil) {
        mainContext.saveAsync(completion: completion)
    }
    
    func asyncSaveChildContext(completion:NKCDCompletionHandler? = nil) {
        childContext.saveAsync(completion: completion)
    }
    
    func enqueue(_ inContent: NSManagedObjectContext?,
                 completion: @escaping (_ context: NSManagedObjectContext) -> Void) {
        let context = inContent ?? self.backgroundContext
        persistentContainerQueue.addOperation {
            context.performAndWait {
                completion(context)
                try? context.save()
            }
        }
    }
    
    
    // MARK: Private
    
    @objc
    private func _didReceiveChildContextDidSave(notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext else {
            assertionFailure("*** Error: \(notification.name) posted from object of type "
                                + String(describing: notification.object.self)
                                + ". Expected \(NSManagedObjectContext.self) instead.")
            return
        }
        
        guard let parentContext = context.parent else {
            // have reached the root context, nothing to do
            return
        }
        
        parentContext.saveAsync(completion: nil)
    }
    
    @objc
    private func _didReceiveBackgroundContextDidSave(notification: Notification) {
        mainContext.perform {
            self.mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    @objc
    private func _didReceiveMainContextDidSave(notification: Notification) {
        backgroundContext.perform {
            self.backgroundContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
}
