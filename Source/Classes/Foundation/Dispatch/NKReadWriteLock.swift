//
//  NKReadWriteLock.swift
//  Alamofire
//
//  Created by Hunt on 2021/2/6.
//

import Foundation


/// from https://github.com/peterprokop/SwiftConcurrentCollections
public final class NKReadWriteLock {
    private var lock: pthread_rwlock_t
    
    // MARK: Lifecycle
    deinit {
        pthread_rwlock_destroy(&lock)
    }
    
    public init() {
        lock = pthread_rwlock_t()
        pthread_rwlock_init(&lock, nil)
    }
    
    // MARK: Public
    public func writeLock() {
        pthread_rwlock_wrlock(&lock)
    }
    
    public func readLock() {
        pthread_rwlock_rdlock(&lock)
    }
    
    public func unlock() {
        pthread_rwlock_unlock(&lock)
    }
}
