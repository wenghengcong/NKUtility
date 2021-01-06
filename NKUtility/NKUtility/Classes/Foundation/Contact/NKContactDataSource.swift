//
//  NKContactDataSource.swift
//  FireFly
//
//  Created by Hunt on 2020/11/2.
//

import Foundation
import Contacts

public typealias ContactDataFetchCompletion = (_ needsReload: Bool) -> Void

@objc protocol NKContactDataSource: class {
    func titleForHeaderInSection(section: Int) -> String?
    func sectionIndexTitles() -> [String]?
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func viewModelForRowAt(indexPath: IndexPath) -> ContactCellViewModel
    var dataCompletion: ContactDataFetchCompletion? { get set }
    
    @objc optional func requestAccesIfNeeded()
    @discardableResult @objc optional func addContactWith(contact: CNMutableContact) -> CNContact?
    @objc optional func deleteContactAtIndexPath(indexPath: IndexPath)
    @objc optional func updateContact(updatedContact: CNContact)
}
