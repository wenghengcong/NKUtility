//
//  TestAwarePersistentContainer.swift
//  DuZi
//
//  Created by Nemo on 2022/9/2.
//

import Foundation
import CoreData
import CloudKit

// MARK: Test Support
public class NKTestPersistentCloudKitContainer: NSPersistentCloudKitContainer {
    public override class func defaultDirectoryURL() -> URL {
        var url = super.defaultDirectoryURL()
        if NKCloudManager.shared.testingEnabled {
            url.appendPathComponent("TestStores")
        }
        return url
    }
}

public extension NKCoreDataStack {
    func prepareForTesting(_ container: NSPersistentContainer) {
        guard NKCloudManager.shared.testingEnabled else {
            fatalError("This method should only be used to ensure the tests always start from a known state.")
        }
        
        let url = type(of: container).defaultDirectoryURL()
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            fatalError("Failed to set up testing directory for stores: \(error)")
        }
    }
}
