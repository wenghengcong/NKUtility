//
//  CNContact+Niki.swift
//  FireFly
//
//  Created by Hunt on 2020/11/27.
//

import Foundation
import Contacts
import ContactsUI

extension CNContact {
    /// The first name of the contact.
    public var firstName: String {
        return givenName
    }
    
    /// The last name of the contact.
    public var lastName: String {
        return familyName
    }
    
    open var displayName: String {
        return firstName + " " + lastName
    }
    
    /// The name of the company the contact works for.
    public var company: String {
        return organizationName
    }
    
    /// A thumbnail image to be displayed on a `UITableViewCell`
    public var thumbnailProfileImage: UIImage? {
        let thumbnailImg: UIImage?
        if let thumbnailImageData = thumbnailImageData {
            thumbnailImg = UIImage(data:thumbnailImageData)
        } else {
            thumbnailImg = nil
        }
        return thumbnailImg
    }
    
    /// The image to be displayed when the contact is selected.
    public var profileImage: UIImage? {
        var profileImg: UIImage?
        if let imageData = imageData {
            profileImg = UIImage(data:imageData)
        } else {
            profileImg = nil
        }
        return profileImg
    }
    
    /// The contact's birthday.
    public var birthdayDate: Date? {
        if let validBirthday = birthday {
            let date = Calendar(identifier: Calendar.Identifier.gregorian).date(from: validBirthday)
            return date
        }
        return nil
    }
    
    public var birthdayCalendarIdentifier: String? {
        if let validBirthday = birthday, let calendar = validBirthday.calendar {
            let iden = calendar.description
            return iden
        }
        return nil
    }
    
    public var nonGregorianBirthdayDate: Date? {
        if let validBirthday = nonGregorianBirthday, let calendar = validBirthday.calendar {
            let date = Calendar(identifier: calendar.identifier).date(from: validBirthday)
            return date
        }
        return nil
    }
    
    public var nonGregorianBirthdayCalendarIdentifier: String? {
        if let validBirthday = nonGregorianBirthday, let calendar = validBirthday.calendar {
            let iden = calendar.description
            return iden
        }
        return nil
    }
    
    
    /// The contact's birthday stored as a string.
    public var birthdayString: String? {
        let birthdayString: String?
        if let birthday = birthdayDate {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = NKContactConstants.Strings.birthdayDateFormat
            //Example Date Formats:  Oct 4, Sep 18, Mar 9
            birthdayString = dateFormatter.string(from: birthday)
            
        } else {
            birthdayString = nil
        }
        return birthdayString
    }
    
    /// The unique identifier for the contact in the phone database.
    public var contactId: String? {
        return identifier
    }
    
    /// An array of the phone numbers associated with the contact.
    public var phoneNums: [(phoneNumber: String, phoneLabel: String)] {
        var numbers: [(String, String)] = []
        for phoneNumber in phoneNumbers {
            let phoneLabel = phoneNumber.label ?? ""
            let phone = phoneNumber.value.stringValue
            
            numbers.append((phone,phoneLabel))
        }
        return  numbers
    }
    
    /// An array of emails associated with the contact,
    public var emails: [(email: String, emailLabel: String )] {
        var emails: [(String, String)] = []
        for emailAddress in emailAddresses {
            let emailLabel = emailAddress.label ?? ""
            let email = emailAddress.value as String
            
            emails.append((email,emailLabel))
        }
        return emails
    }
        
    /// First Letter of name
    /// if firstName not null , get it's first character, or will read lastName's
    open var initials: String {
        var initials: String = ""
        
        if let firstNameFirstChar = firstName.first {
            initials.append(firstNameFirstChar)
        }
        
        if let lastNameFirstChar = lastName.first {
            initials.append(lastNameFirstChar)
        }
        
        return initials
    }
}
