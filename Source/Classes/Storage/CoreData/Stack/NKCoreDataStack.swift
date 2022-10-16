//
//  FFCoreDataStack.swift
//  FireFly
//
//  Created by Hunt on 2020/9/25.
//

import Foundation
import CoreData
import CloudKit

/**
 An instance of `NKCoreDataStack` encapsulates the entire Core Data stack.
 It manages the managed object model, the persistent store coordinator, and managed object contexts.
 
 It is composed of a main context and a background context.
 These two contexts operate on the main queue and a private background queue, respectively.
 Both are connected to the persistent store coordinator and data between them is perpetually kept in sync.
 
 Changes to a child context are propagated to its parent context and eventually the persistent store when saving.
 
 See this [guide](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Conceptual/CoreData/IntegratingCoreData.html#//apple_ref/doc/uid/TP40001075-CH9-SW1) for more details.
 
 */

public let AppTransactionAuthorName = "NemoApp"

/// Core Data 栈
/// 1. 初始化可以传入descriptions，否则将默认启用 cloutkit
/// 2. 初始化可以传入 processHitory回调，可以处理上次的更改，也可以监听通知 didFindRelevantTransactions
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
    
    
    private var _privatePersistentStore: NSPersistentStore?
    public var privatePersistentStore: NSPersistentStore {
        return _privatePersistentStore!
    }
    
    private var _sharedPersistentStore: NSPersistentStore?
    public var sharedPersistentStore: NSPersistentStore {
        return _sharedPersistentStore!
    }
    
    private var _publicPersistentStore: NSPersistentStore?
    public var publicPersistentStore: NSPersistentStore {
        return _publicPersistentStore!
    }
    
    public typealias HistoryTransactionBlcok = ( (_ trans: [NSPersistentHistoryTransaction]) -> Void )?
    /// 处理历史的更改，要么在该回调，要么监听 didFindRelevantTransactions 通知
    public var processHistoryBlock: HistoryTransactionBlcok
    
    /**
     A persistent container that can load cloud-backed and non-cloud stores.
     */
    public lazy var persistentContainer: NKTestPersistentCloudKitContainer = {
        assert(self.model.name.isNotEmpty, "model name can't be nil");
        var container = NKTestPersistentCloudKitContainer(name: self.model.name)
        
        let cloudManager = NKCloudManager.shared
        if cloudManager.testingEnabled {
            prepareForTesting(container)
        }
        
        if let descs = descriptions, descs.count > 0 {
            container.persistentStoreDescriptions = descs
        } else {
            let privateStoreDescription = container.persistentStoreDescriptions.first!
            let storesURL = privateStoreDescription.url!.deletingLastPathComponent()
            privateStoreDescription.url = storesURL.appendingPathComponent("private.sqlite")
            privateStoreDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            privateStoreDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            
            if #available(iOS 15.0, *) {
                //Add Shared Database
                let sharedStoreURL = storesURL.appendingPathComponent("shared.sqlite")
                guard let sharedStoreDescription = privateStoreDescription.copy() as? NSPersistentStoreDescription else {
                    fatalError("Copying the private store description returned an unexpected value.")
                }
                sharedStoreDescription.url = sharedStoreURL
                
                // Add Public Database
                let publicStoreURL = storesURL.appendingPathComponent("public.sqlite")
                guard let publicStoreDescription = privateStoreDescription.copy() as? NSPersistentStoreDescription else {
                    fatalError("Copying the private store description returned an unexpected value.")
                }
                publicStoreDescription.url = publicStoreURL
                
                if cloudManager.allowCloudKitSync {
                    if let containerIdentifier = privateStoreDescription.cloudKitContainerOptions?.containerIdentifier {
                        // share
                        let sharedStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
                        if #available(iOS 15.0, *) {
                            sharedStoreOptions.databaseScope = .shared
                        } else {
                            // Fallback on earlier versions
                        }
                        sharedStoreDescription.cloudKitContainerOptions = sharedStoreOptions
                        // public
                        let publicStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
                        if #available(iOS 14.0, *) {
                            publicStoreOptions.databaseScope = .public
                        } else {
                            // Fallback on earlier versions
                        }
                        publicStoreDescription.cloudKitContainerOptions = publicStoreOptions
                    }
                } else {
                    sharedStoreDescription.cloudKitContainerOptions = nil
                    publicStoreDescription.cloudKitContainerOptions = nil
                }
                //Load the persistent stores.
                container.persistentStoreDescriptions.append(sharedStoreDescription)
                container.persistentStoreDescriptions.append(publicStoreDescription)
            } else {
                privateStoreDescription.cloudKitContainerOptions = nil
            }
        }
        
        container.loadPersistentStores(completionHandler: { (loadedStoreDescription, error) in
            if let loadError = error as NSError? {
                fatalError("###\(#function): Failed to load persistent stores:\(loadError)")
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                NKlogger.debug("Unresolved error \(loadError), \(loadError.userInfo)")
            } else if let cloudKitContainerOptions = loadedStoreDescription.cloudKitContainerOptions {
                if #available(iOS 14.0, *) {
                    if .private == cloudKitContainerOptions.databaseScope {
                        self._privatePersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                    } else if .shared == cloudKitContainerOptions.databaseScope {
                        self._sharedPersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                    } else if .public == cloudKitContainerOptions.databaseScope {
                        self._publicPersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                    }
                } else {
                    self._privatePersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                }
            } else if cloudManager.testingEnabled {
                if loadedStoreDescription.url!.lastPathComponent.hasSuffix("private.sqlite") {
                    self._privatePersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                } else if loadedStoreDescription.url!.lastPathComponent.hasSuffix("shared.sqlite") {
                    self._sharedPersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                } else if loadedStoreDescription.url!.lastPathComponent.hasSuffix("public.sqlite") {
                    self._publicPersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                }
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        container.viewContext.transactionAuthor = AppTransactionAuthorName
        
        // Pin the viewContext to the current generation token, and set it to keep itself up to date with local changes.
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
        }
        
        // Observe Core Data remote change notifications.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeRemoteChange(_:)),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: container.persistentStoreCoordinator)
        
        return container
    }()
    
    
    /**
     Track the last history token processed for a store, and write its value to file.
     
     The historyQueue reads the token when executing operations and updates it after processing is complete.
     */
    private var lastHistoryToken: NSPersistentHistoryToken? = nil {
        didSet {
            guard let token = lastHistoryToken,
                  let data = try? NSKeyedArchiver.archivedData( withRootObject: token, requiringSecureCoding: true) else { return }
            
            do {
                try data.write(to: tokenFile)
            } catch {
                print("###\(#function): Failed to write token data. Error = \(error)")
            }
        }
    }
    
    /**
     The file URL for persisting the persistent history token.
     */
    private lazy var tokenFile: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(self.model.name, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("###\(#function): Failed to create persistent container URL. Error = \(error)")
            }
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()
    
    
    /**
     An operation queue for handling history processing tasks: watching changes, deduplicating tags, and triggering UI updates if needed.
     */
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    
    // MARK: Initialization
    /**
     Constructs a new `CoreDataStackProvider` instance with the specified `model` and `options`.
     
     - parameter model:   The model describing the stack.
     - parameter options: Options for the persistent store.
     
     - returns: A new `CoreDataStackProvider` instance.
     */
    public init(model: NKCoreDataModel,
                descriptions: NKPersistentStoreDescriptions?,
                processHistoryBlock: HistoryTransactionBlcok) {
        self.model = model
        self.descriptions = descriptions
        self.processHistoryBlock = processHistoryBlock
        let _ = self.persistentContainer
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(_didReceiveMainContextDidSave(notification:)),
                                       name: .NSManagedObjectContextDidSave,
                                       object: mainContext)
        notificationCenter.addObserver(self,
                                       selector: #selector(_didReceiveBackgroundContextDidSave(notification:)),
                                       name: .NSManagedObjectContextDidSave,
                                       object: backgroundContext)
        
        // Load the last token from the token file.
        if let tokenData = try? Data(contentsOf: tokenFile) {
            do {
                lastHistoryToken = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData)
            } catch {
                print("###\(#function): Failed to unarchive NSPersistentHistoryToken. Error = \(error)")
            }
        }
    }
    
    // MARK: - instance contexts
    public lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    public lazy var backgroundContext: NSManagedObjectContext = {
        let newBack = self.persistentContainer.newBackgroundContext()
        newBack.transactionAuthor = AppTransactionAuthorName
        return newBack
    }()
    
    public lazy var childContext: NSManagedObjectContext = {
        let newChild = newChildContext()
        newChild.transactionAuthor = AppTransactionAuthorName
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
    
    public func saveMainContext(completion:NKCDCompletionHandler? = nil) {
        mainContext.saveSync(completion: completion)
    }
    
    public func saveChildContext(completion:NKCDCompletionHandler? = nil) {
        childContext.saveSync(completion: completion)
    }
    
    public func asyncSaveMainContext(completion:NKCDCompletionHandler? = nil) {
        mainContext.saveAsync(completion: completion)
    }
    
    public func asyncSaveChildContext(completion:NKCDCompletionHandler? = nil) {
        childContext.saveAsync(completion: completion)
    }
    
    public func enqueue(_ inContent: NSManagedObjectContext?,
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
            self.backgroundContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    @objc
    private func _didReceiveMainContextDidSave(notification: Notification) {
        backgroundContext.perform {
            self.mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
}


// MARK: - Notifications
extension NKCoreDataStack {
    /**
     Handle remote store change notifications (.NSPersistentStoreRemoteChange).
     */
    @objc
    func storeRemoteChange(_ notification: Notification) {
        // Process persistent history to merge changes from other coordinators.
        historyQueue.addOperation {
            self.processPersistentHistory()
        }
    }
    
    /**
     Process persistent history, posting any relevant transactions to the current view.
     */
    func processPersistentHistory() {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.performAndWait {
            
            // Fetch history received from outside the app since the last token
            let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest!
            historyFetchRequest.predicate = NSPredicate(format: "author != %@", AppTransactionAuthorName)
            let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
            request.fetchRequest = historyFetchRequest
            
            let result = (try? taskContext.execute(request)) as? NSPersistentHistoryResult
            guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
                  !transactions.isEmpty
            else { return }
            
            // Post transactions relevant to the current view.
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .CoreData.didFindRelevantTransactions, object: self, userInfo: ["transactions": transactions])
            }
            
            processHistoryBlock?(transactions)
            
            // Update the history token using the last transaction.
            lastHistoryToken = transactions.last!.token
        }
    }
}

