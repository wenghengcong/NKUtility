//
//  ContactViewModel.swift
//  FireFly
//
//  Created by Hunt on 2020/11/2.
//

import UIKit
import Contacts

@objc public protocol ContactCellViewModel {
    var numberString: String { get }
    var timeString: String { get }
    var attibutedNameString: NSAttributedString { get }
    var image: UIImage { get }
    var isPrivusContact: Bool {get set}
}


open class ContactViewModel: ContactCellViewModel {
   
    internal let contact: CNContact
    open var isPrivusContact = false
    
    init(contactData: CNContact) {
        contact = contactData
    }
    
    var firstName: String {
        return contact.givenName
    }
    
    var lastName: String {
        return contact.familyName
    }
    
    open var attibutedNameString : NSAttributedString {
        let attrString = NSMutableAttributedString(string: contact.givenName,
                                                   attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)])
        
        attrString.append(NSMutableAttributedString(string: " " + contact.familyName,
                                                     attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)]))
        return attrString
    }
    
    open var numberString: String {
        return contact.phoneNumbers.first?.value.stringValue ?? ""
    }
    
    open var image: UIImage {
        var image: UIImage = UIImage(named: "unknown_dp")!
        if contact.imageDataAvailable {
            if let imageData = contact.thumbnailImageData ,let theImage = UIImage(data: imageData) {
                image = theImage
            }
        }
        return image
    }
    
    var largeImage: UIImage? {
        var image: UIImage = UIImage(named: "full_dp")!
        if contact.imageDataAvailable {
            if let imageData = contact.imageData ,let theImage = UIImage(data: imageData) {
                image = theImage
            }
        }
        return image
    }
    
    open var timeString: String = ""

}
