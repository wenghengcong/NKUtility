//
//  NKContactStore.swift
//  FireFly
//
//  Created by Hunt on 2020/11/26.
//

import Foundation
import Contacts
import ContactsUI
/// @_exported 表示，当引入自定义模块时，也会自动引入@_exported指定的模块
@_exported import Contacts
import Foundation

#if os(OSX)
import Cocoa
import CoreTelephony
#elseif os(iOS)
import CoreTelephony
import UIKit
#endif


public typealias NKContactDataCompletion = (_ conatcts: [CNContact], _ error: Error?) -> Void
public typealias NKContactOperationCompletion = (_ conatcts: CNMutableContact?, _ error: Error?) -> Void
public typealias NKContactBoolCompletion = (_ sucess: Bool, _ error: Error?) -> Void

// TODO: 1.将大部分请求添加到 queue 中
// TODO: 2.CNContainer 代表账户
public class NKContactService {
    public static let shared = NKContactService()
    
    let store = CNContactStore()
    var contacts: [CNContact] = []
    
    var contactChangeCompletion:[String: NKContactDataCompletion] = [:]
    var responseContactChange: Bool {
        return contactChangeCompletion.keys.count > 0
    }
    
    private init(){ }
    
    private let queue = DispatchQueue(label: "NKContactServiceQueue")
    
    func performOnQueue(_ handler: @escaping () -> Void) {
        queue.async(execute: handler)
    }
    
    func performOnMainQueue(_ handler: @escaping () -> Void) {
        DispatchQueue.main.async(execute: handler)
    }
    
    // PRAGMA MARK: - Contacts Authorization -
    /// Requests access to the user's contacts
    ///
    /// - Parameter completionHandler: completion hanlder
    func requestAcces(completionHandler: NKContactBoolCompletion?) {
        store.requestAccess(for: .contacts) { [weak self](sucess, error) in
            guard let weakSelf = self else { return }
            weakSelf.isAuthorized()
            completionHandler?(sucess, error)
        }
    }
    
    
    /// has authorized
    /// - Returns: authorized
    @discardableResult func isAuthorized() -> Bool{
        return CNContactStore.authorizationStatus(for: .contacts) == .authorized
    }
    
    
    /// Returns the current authorization status to access the contact data.
    ///
    /// - Parameter requestStatus: Result as CNAuthorizationStatus
    public func authorizationStatus(_ requestStatus: @escaping (CNAuthorizationStatus) -> Void) {
        requestStatus(CNContactStore.authorizationStatus(for: .contacts))
    }
    
    
    // PRAGMA MARK: - Fetch Contacts -
    
    func fetchContact(with identifier: String, completionHandler: NKContactDataCompletion?) {
        queue.async { [weak self] in
            guard let `self` = self else {
                return
            }
            do {
                var contacts:[CNContact] = []
                let contact = try self.store.unifiedContact(withIdentifier: identifier, keysToFetch: NKContactConstants.FetchKeys.all)
                contacts.append(contact)
                self.performOnQueue {
                    completionHandler?(contacts, nil)
                }
            } catch let error as NSError {
                self.performOnMainQueue {
                    completionHandler?([], error)
                }
            }
            
        }
    }
    
    
    func fetchContacts(completionHandler: NKContactDataCompletion?) {
        fetchContacts(keysToFetch: NKContactConstants.FetchKeys.all, completionHandler: completionHandler)
    }
    
    /// Fetching Contacts from phone
    ///
    /// - Parameter completionHandler: Returns Either [CNContact] or Error.
    public func fetchContacts(keysToFetch: [CNKeyDescriptor] = [ CNContactVCardSerialization.descriptorForRequiredKeys()],
                              completionHandler: NKContactDataCompletion?) {
        fetchContacts(keysToFetch: keysToFetch, order: nil, completionHandler: completionHandler)
    }
    
    
    /// Fetching Contacts from phone with specific sort order.
    ///
    /// - Parameters:
    ///   - sortOrder: To return contacts in a specific sort order.
    ///   - completionHandler: Result Handler
    @available(iOS 10.0, *)
    public func fetchContacts(keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
                              order: CNContactSortOrder?,
                              completionHandler: NKContactDataCompletion?) {
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        fetchRequest.unifyResults = true
        if order != nil {
            fetchRequest.sortOrder = order!
        }
        fetchContacts(fetchRequest: fetchRequest, completionHandler: completionHandler)
    }
    
    func fetchContacts(fetchRequest: CNContactFetchRequest,
                       completionHandler: NKContactDataCompletion?) {
        do {
            var resultsSet = [CNContact]()
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                resultsSet.append(contact)
            })
            self.contacts = resultsSet
            self.performOnMainQueue {
                completionHandler?(resultsSet, nil)
            }
        }
        catch let error as NSError {
            self.performOnMainQueue {
                completionHandler?([], error)
            }
        }
    }
    
    /// Fetching Contacts from phone
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func fetchContactsOnBackgroundThread(keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
                                                completionHandler: NKContactDataCompletion?) {
        DispatchQueue.global(qos: .userInitiated).async { () -> Void in
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            var contacts = [CNContact]()
            CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
            if #available(iOS 10.0, *) {
                fetchRequest.mutableObjects = false
            } else {
                // Fallback on earlier versions
            }
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .userDefault
            do {
                try self.store.enumerateContacts(with: fetchRequest) { (contact, _) -> Void in
                    contacts.append(contact)
                }
                self.contacts = contacts
                self.performOnMainQueue {
                    completionHandler?(contacts, nil)
                }
            } catch let error as NSError {
                self.performOnMainQueue {
                    completionHandler?([], error)
                }
            }
        }
    }
    
    
    // PRAGMA MARK: - Search Contacts -
    /// Search Contact from phone
    /// - parameter string: Search String.
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func searchContact(searchString string: String, completionHandler: NKContactDataCompletion?) {
        var contacts = [CNContact]()
        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: string)
        do {
            contacts = try store.unifiedContacts(matching: predicate, keysToFetch: NKContactConstants.FetchKeys.all)
            self.performOnMainQueue {
                completionHandler?(contacts, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?([], error)
            }
        }
    }
    
    
    // Get CNContact From Identifier
    /// Get CNContact From Identifier
    /// - parameter identifier: A value that uniquely identifies a contact on the device.
    /// - parameter completionHandler: Returns Either CNContact or Error.
    public func getContactFromID(identifires identifiers: [String], completionHandler: NKContactDataCompletion?) {
        var contacts = [CNContact]()
        let predicate: NSPredicate = CNContact.predicateForContacts(withIdentifiers: identifiers)
        do {
            contacts = try store.unifiedContacts(matching: predicate, keysToFetch: NKContactConstants.FetchKeys.all)
            self.performOnMainQueue {
                completionHandler?(contacts, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?([], error)
            }
        }
    }
    
    
    /// get the name who has the number
    /// - Parameter number: contact number
    /// - Returns:  contact name
    func nameFromNumber(number: String) -> String {
        var name = number
        let contact = contacts.filter { (item) -> Bool in
            return item.phoneNumbers.first?.value.stringValue == number
        }
        name = ((contact.first?.givenName ?? "")  + (contact.first?.familyName ?? ""))
        return name.isEmpty ? number : name
    }
    
    
    // PRAGMA MARK: - Contact Operations
    // Add Contact
    /// Add new Contact.
    /// - parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
    /// - parameter completionHandler: Returns Either Bool or Error.
    #if os(iOS) || os(OSX)
    public func addContact(contact mutableContact: CNMutableContact,
                           completionHandler: NKContactOperationCompletion?
    ) -> CNMutableContact? {
        var createdContact: CNMutableContact?
        let request = CNSaveRequest()
        request.add(mutableContact, toContainerWithIdentifier: nil)
        do {
            try store.execute(request)
            createdContact = mutableContact
            self.performOnMainQueue {
                completionHandler?(createdContact, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?(createdContact, error)
            }
        }
        return createdContact
    }
    
    #endif
    
    /// Adds the specified contact to the contact store.
    /// - parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
    /// - parameter identifier: The unique identifier for a contacts container on the device.
    /// - parameter completionHandler: Returns Either Bool or Error.
    #if os(iOS) || os(OSX)
    public func addContactInContainer(contact mutContact: CNMutableContact,
                                      containerIdentifier identifier: String,
                                      completionHandler: NKContactBoolCompletion?) {
        let request = CNSaveRequest()
        request.add(mutContact, toContainerWithIdentifier: identifier)
        do {
            try store.execute(request)
            completionHandler?(true, nil)
        } catch {
            completionHandler?(false, error)
        }
    }
    
    // Update Contact
    /// Updates an existing contact in the contact store.
    /// - parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
    /// - parameter completionHandler: Returns Either CNContact or Error.
    public func updateContact(contact mutContact: CNMutableContact, completionHandler: NKContactBoolCompletion?) {
        let request = CNSaveRequest()
        request.update(mutContact)
        do {
            try store.execute(request)
            self.performOnMainQueue {
                completionHandler?(true, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?(false, error)
            }
        }
    }
    
    // Delete Contact
    /// Deletes a contact from the contact store.
    /// - parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
    /// - parameter completionHandler: Returns Either CNContact or Error.
    public func deleteContact(contact mutContact: CNMutableContact, completionHandler: NKContactBoolCompletion?) {
        let request = CNSaveRequest()
        request.delete(mutContact)
        do {
            try store.execute(request)
            self.performOnMainQueue {
                completionHandler?(true, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?(false, error)
            }
        }
    }
    #endif
    
    // PRAGMA MARK: - Groups Methods -
    /// Fetch list of Groups from the contact store.
    /// - parameter completionHandler: Returns Either [CNGroup] or Error.
    public func fetchGroups(completionHandler: @escaping (_ result: Result<[CNGroup], Error>) -> Void) {
        do {
            let groups: [CNGroup] = try store.groups(matching: nil)
            completionHandler(.success(groups))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    /// Adds a group to the contact store.
    /// - parameter name: Name of the group.
    /// - parameter completionHandler: Returns Either Bool or Error.
    #if os(iOS) || os(OSX)
    public func createGroup(groupName name: String, completionHandler: NKContactBoolCompletion?) {
        let request = CNSaveRequest()
        let group = CNMutableGroup()
        group.name = name
        request.add(group, toContainerWithIdentifier: nil)
        do {
            try store.execute(request)
            self.performOnMainQueue {
                completionHandler?(true, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?(false, error)
            }
        }
    }
    
    /// Adds a group to the contact store.
    /// - parameter name: Name of the group.
    /// - parameter identifire: The identifier of the container to add the new group. To add the new group to the default container, set identifier to nil.
    /// - parameter completionHandler: Returns Either Bool or Error.
    public func createGroupInContainer(groupName name: String,
                                       containerIdentifire identifire: String,
                                       completionHandler: NKContactBoolCompletion?) {
        let request = CNSaveRequest()
        let group = CNMutableGroup()
        group.name = name
        request.add(group, toContainerWithIdentifier: identifire)
        do {
            try store.execute(request)
            self.performOnMainQueue {
                completionHandler?(true, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?(false, error)
            }
        }
    }
    
    /// Remove an existing group in the contact store.
    /// - parameter group: The group to delete.
    /// - parameter completionHandler: Returns Either Bool or Error.
    public func removeGroup(group: CNGroup,
                            completionHandler: NKContactBoolCompletion?) {
        let request = CNSaveRequest()
        if let mutableGroup: CNMutableGroup = group.mutableCopy() as? CNMutableGroup {
            request.delete(mutableGroup)
        }
        do {
            try store.execute(request)
            self.performOnMainQueue {
                completionHandler?(true, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?(false, error)
            }
        }
    }
    
    /// Update an existing group in the contact store.
    /// - parameter group: The group to update.
    /// - parameter completionHandler: Returns Either Bool or Error.
    public func updateGroup(group: CNGroup, newGroupName name: String, completionHandler: NKContactBoolCompletion?) {
        let request = CNSaveRequest()
        if let mutableGroup: CNMutableGroup = group.mutableCopy() as? CNMutableGroup {
            mutableGroup.name = name
            request.update(mutableGroup)
        }
        do {
            try store.execute(request)
            self.performOnMainQueue {
                completionHandler?(true, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?(false, error)
            }
        }
    }
    
    /// Adds a contact as a member of a group.
    /// - parameter group: The group to add member in.
    /// - parameter completionHandler: Returns Either Bool or Error.
    public func addContactToGroup(group: CNGroup, contact: CNContact, completionHandler: NKContactBoolCompletion?) {
        let request = CNSaveRequest()
        request.addMember(contact, to: group)
        do {
            try store.execute(request)
            self.performOnMainQueue {
                completionHandler?(true, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?(false, error)
            }
        }
    }
    
    /// Remove a contact as a member of a group.
    /// - parameter group: The group to Remove member from.
    /// - parameter completionHandler: Returns Either Bool or Error.
    public func removeContactFromGroup(group: CNGroup,
                                       contact: CNContact,
                                       completionHandler: NKContactBoolCompletion?) {
        let request = CNSaveRequest()
        request.removeMember(contact, from: group)
        do {
            try store.execute(request)
            self.performOnMainQueue {
                completionHandler?(true, nil)
            }
        } catch {
            self.performOnMainQueue {
                completionHandler?(false, error)
            }
        }
    }
    #endif
    
    /// Fetch all contacts in a group.
    /// - parameter group: The group.
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func fetchContactsInGorup(group: CNGroup,
                                     completionHandler: NKContactDataCompletion?) {
        var contacts = [CNContact]()
        do {
            let predicate: NSPredicate = CNContact.predicateForContactsInGroup(withIdentifier: group.name)
            let keysToFetch: [String] = [CNContactGivenNameKey]
            contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
            self.performOnMainQueue {
                
                completionHandler?(contacts, nil)
            }
        } catch {
            self.performOnMainQueue {
                
                completionHandler?([], error)
            }
        }
    }
    
    /// Fetch all contacts in a group.
    /// - parameter group: The group.
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func fetchContactsInGorup2(group: CNGroup,
                                      completionHandler: NKContactDataCompletion?) {
        let contacts = [CNContact]()
        do {
            var predicate: NSPredicate!
            let allGroups: [CNGroup] = try store.groups(matching: nil)
            for item in allGroups {
                if item.name == group.name {
                    predicate = CNContact.predicateForContactsInGroup(withIdentifier: group.identifier)
                }
            }
            let keysToFetch: [String] = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey, CNContactUrlAddressesKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactNoteKey, CNContactImageDataKey]
            if predicate != nil {
                var contacts: [CNContact] = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
                for contact in contacts {
                    contacts.append(contact)
                }
            }
            self.performOnMainQueue {
                
                completionHandler?(contacts, nil)}
        } catch {
            self.performOnMainQueue {
                
                completionHandler?([], error)}
        }
    }
    
    // PRAGMA MARK: - Converter Methods -
    // CSV Converter
    // Convert [CNContacts] TO CSV
    /// Returns the vCard representation of the specified contacts.
    /// - parameter contacts: Array of contacts.
    /// - parameter completionHandler: Returns Either Data or Error.
    public func contactsToVCardConverter(contacts: [CNContact],
                                         completionHandler: @escaping (_ result: Result<Data, Error>) -> Void) {
        var vcardFromContacts = Data()
        do {
            try vcardFromContacts = CNContactVCardSerialization.data(with: contacts)
            completionHandler(.success(vcardFromContacts))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    // Convert CSV TO [CNContact]
    /// Returns the contacts from the vCard data.
    /// - parameter data: Data having contacts.
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func VCardToContactConverter(data: Data,
                                        completionHandler: NKContactDataCompletion?) {
        var contacts = [CNContact]()
        do {
            try contacts = CNContactVCardSerialization.contacts(with: data) as [CNContact]
            self.performOnMainQueue {
                
                completionHandler?(contacts, nil)}
        } catch {
            self.performOnMainQueue {
                
                completionHandler?([], error)}
        }
    }
    
    // Archive Unarchive Contacts
    /// Returns the NSKeyedArchiver.archivedData representation of the specified contacts.
    /// - parameter contacts: Array of contacts.
    /// - parameter completionHandler: Returns Either Data or Error.
    public func archiveContacts(contacts: [CNContact], completionHandler: @escaping (_ result: Data) -> Void) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: contacts)
        self.performOnMainQueue {
            
            completionHandler(encodedData)
        }
    }
    
    /// Returns the contacts from the NSKeyedArchiver.archivedData.
    /// - parameter data: Data having contacts.
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func unarchiveConverter(data: Data, completionHandler: @escaping (_ result: [CNContact]) -> Void) {
        let decodedData: Any? = NSKeyedUnarchiver.unarchiveObject(with: data)
        if let contacts: [CNContact] = decodedData as? [CNContact] {
            self.performOnMainQueue {
                
                completionHandler(contacts)
            }
        }
    }
    
    #if os(OSX)
    
    /// Convert CNPhoneNumber To digits
    /// - parameter CNPhoneNumber: Phone number.
    public func CNPhoneNumberToString(phoneNumber: CNPhoneNumber) -> String {
        if let result: String = phoneNumber.value(forKey: "digits") as? String {
            return result
        }
        return ""
    }
    
    /// Make call to given number.
    /// - parameter CNPhoneNumber: Phone number.
    public func makeCall(phoneNumber: CNPhoneNumber) {
        if let phoneNumber: String = phoneNumber.value(forKey: "digits") as? String {
            guard let url = URL(string: "tel://" + "\(phoneNumber)") else {
                print("Error in Making Call")
                return
            }
            NSWorkspace.shared.open(url)
        }
    }
    
    #elseif os(iOS)
    // PRAGMA MARK: - CoreTelephonyCheck
    /// Check if iOS Device supports phone calls
    /// - parameter completionHandler: Returns Bool.
    public func isCapableToCall(completionHandler: @escaping (_ result: Bool) -> Void) {
        if UIApplication.shared.canOpenURL(NSURL(string: "tel://")! as URL) {
            // Check if iOS Device supports phone calls
            // User will get an alert error when they will try to make a phone call in airplane mode
            if let mnc: String = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode, !mnc.isEmpty {
                // iOS Device is capable for making calls
                completionHandler(true)
            } else {
                // Device cannot place a call at this time. SIM might be removed
                completionHandler(false)
            }
        } else {
            // iOS Device is not capable for making calls
            completionHandler(false)
        }
    }
    
    /// Check if iOS Device supports sms
    /// - parameter completionHandler: Returns Bool.
    public func isCapableToSMS(completionHandler: @escaping (_ result: Bool) -> Void) {
        if UIApplication.shared.canOpenURL(NSURL(string: "sms:")! as URL) {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    /// Convert CNPhoneNumber To digits
    /// - parameter CNPhoneNumber: Phone number.
    public func CNPhoneNumberToString(phoneNumber: CNPhoneNumber) -> String {
        if let result: String = phoneNumber.value(forKey: "digits") as? String {
            return result
        }
        return ""
    }
    
    /// Make call to given number.
    /// - parameter CNPhoneNumber: Phone number.
    public func makeCall(phoneNumber: CNPhoneNumber) {
        if let number: String = phoneNumber.value(forKey: "digits") as? String {
            guard let url = URL(string: "tel://" + "\(number)") else {
                print("Error in Making Call")
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    #endif
    
    
    // PRAGMA MARK: - Notification
    /**
     添加变化监听
     */
    public func addStoreDidChangeNotification(key: String, completionHandler: NKContactDataCompletion?) {
        NotificationCenter.default.addObserver(self, selector: #selector(__contactDidChange(_:)), name: NSNotification.Name.CNContactStoreDidChange, object: nil)
        if key.isNotEmpty && completionHandler != nil {
            contactChangeCompletion[key] = completionHandler!
        }
    }
    
    /// 移除监听变化某个 key 对应 handler
    /// - Parameter key: <#key description#>
    public func removeStoreDidChangeHanlder(key: String) {
        contactChangeCompletion.removeValue(forKey: key)
    }
    
    
    /// 移除监听
    public func removeStoreDidChangeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.CNContactStoreDidChange, object: nil)
        contactChangeCompletion.removeAll()
    }
    
    /// 通讯录变更
    /// - Parameter notification: 通知
    @objc public func __contactDidChange(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard userInfo != nil else {
            return
        }
        
        /// change outside of the app
        let externChange = userInfo!["CNNotificationOriginationExternally"]
        if let isExtenralChanges = externChange as? Bool, isExtenralChanges == true {
            // delegate refetch contacts
            let changeIden = userInfo!["CNNotificationSaveIdentifiersKey"]
            if let changedContactIdentifiers = changeIden as?  [String] {
                var saveContacts: [CNContact] = []
                var fetchError: Error? = nil
                do {
                    for iden in changedContactIdentifiers {
                        let contact = try store.unifiedContact(withIdentifier: iden, keysToFetch: NKContactConstants.FetchKeys.all)
                        saveContacts.append(contact)
                    }
                    
                } catch {
                    fetchError = error
                    
                }
                
                for completion in contactChangeCompletion.values {
                    self.performOnMainQueue {
                        completion(saveContacts, fetchError)
                    }
                }
                
            }
        } else { /// in app changes
            let changeIden = userInfo!["CNNotificationSaveIdentifiersKey"]
            if let changedContactIdentifiers = changeIden as?  [String] {
                var saveContacts: [CNContact] = []
                var fetchError: Error? = nil
                do {
                    for iden in changedContactIdentifiers {
                        let contact = try store.unifiedContact(withIdentifier: iden, keysToFetch: NKContactConstants.FetchKeys.all)
                        saveContacts.append(contact)
                    }
                    
                } catch {
                    fetchError = error
                    
                }
                
                for completion in contactChangeCompletion.values {
                    self.performOnMainQueue {
                        completion(saveContacts, fetchError)
                    }
                }
                
            }
            /// tipicaly one item of store
            //let contactStores = userInfo["CNNotificationSourcesKey"] as? [CNContactStore]
            
        }
    }
}


