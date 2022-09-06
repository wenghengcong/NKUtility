//
//  NKCoreDataShare.swift
//  NKUtility
//
//  Created by Nemo on 2022/9/2.
//

import Foundation
import CoreData
import CloudKit

protocol NKRenderableUserIdentity {
    var nameComponents: PersonNameComponents? { get }
    var contactIdentifiers: [String] { get }
}

protocol NKRenderableShareParticipant {
    var renderableUserIdentity: NKRenderableUserIdentity { get }
    var role: CKShare.ParticipantRole { get }
    var permission: CKShare.ParticipantPermission { get }
    var acceptanceStatus: CKShare.ParticipantAcceptanceStatus { get }
}

protocol NKRenderableShare {
    var renderableParticipants: [NKRenderableShareParticipant] { get }
}

extension CKUserIdentity: NKRenderableUserIdentity {}

extension CKShare.Participant: NKRenderableShareParticipant {
    var renderableUserIdentity: NKRenderableUserIdentity {
        return userIdentity
    }
}

extension CKShare: NKRenderableShare {
    var renderableParticipants: [NKRenderableShareParticipant] {
        return participants
    }
}

protocol NKSharingProvider {
    func isShared(object: NSManagedObject) -> Bool
    func isShared(objectID: NSManagedObjectID) -> Bool
    func participants(for object: NSManagedObject) -> [NKRenderableShareParticipant]
    func shares(matching objectIDs: [NSManagedObjectID]) throws -> [NSManagedObjectID: NKRenderableShare]
    func canEdit(object: NSManagedObject) -> Bool
    func canDelete(object: NSManagedObject) -> Bool
}

// Mark - Sharing
extension NKCoreDataStack: NKSharingProvider {
    func isShared(object: NSManagedObject) -> Bool {
        return isShared(objectID: object.objectID)
    }

    func isShared(objectID: NSManagedObjectID) -> Bool {
        var isShared = false
        if let persistentStore = objectID.persistentStore {
            if persistentStore == sharedPersistentStore {
                isShared = true
            } else {
                let container = persistentContainer
                do {
                    if #available(iOS 15.0, *) {
                        let shares = try container.fetchShares(matching: [objectID])
                        if nil != shares.first {
                            isShared = true
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                   
                } catch let error {
                    print("Failed to fetch share for \(objectID): \(error)")
                }
            }
        }
        return isShared
    }
    
    func participants(for object: NSManagedObject) -> [NKRenderableShareParticipant] {
        var participants = [CKShare.Participant]()
        do {
            let container = persistentContainer
            if #available(iOS 15.0, *) {
                let shares = try container.fetchShares(matching: [object.objectID])
                if let share = shares[object.objectID] {
                    participants = share.participants
                }
            } else {
                // Fallback on earlier versions
            }
            
        } catch let error {
            print("Failed to fetch share for \(object): \(error)")
        }
        return participants
    }
    
    func shares(matching objectIDs: [NSManagedObjectID]) throws -> [NSManagedObjectID: NKRenderableShare] {
        if #available(iOS 15.0, *) {
            return try persistentContainer.fetchShares(matching: objectIDs)
        } else {
            // Fallback on earlier versions
        }
        return [:]
    }
    
    func canEdit(object: NSManagedObject) -> Bool {
        if #available(iOS 14.0, *) {
            return persistentContainer.canUpdateRecord(forManagedObjectWith: object.objectID)
        } else {
            // Fallback on earlier versions
        }
        return false
    }
        
    func canDelete(object: NSManagedObject) -> Bool {
        if #available(iOS 14.0, *) {
            return persistentContainer.canDeleteRecord(forManagedObjectWith: object.objectID)
        } else {
            // Fallback on earlier versions
        }
        return false
    }
}
