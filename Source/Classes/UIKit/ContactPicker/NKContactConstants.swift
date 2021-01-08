//
//  Constants.swift
//  JFContactsPicker
//

import UIKit
import Contacts
import ContactsUI
import L10n_swift

//Declare all the static constants here
public struct NKContactConstants {
    
    public struct FetchKeys {
        
        /// fetch all keys
        public static let all:[CNKeyDescriptor] = [
            CNContactNamePrefixKey as CNKeyDescriptor,
            CNContactPreviousFamilyNameKey as CNKeyDescriptor,
            CNContactNameSuffixKey as CNKeyDescriptor,
            CNContactNicknameKey as CNKeyDescriptor,
            CNContactOrganizationNameKey as CNKeyDescriptor,
            CNContactDepartmentNameKey as CNKeyDescriptor,
            CNContactJobTitleKey as CNKeyDescriptor,
            CNContactPhoneticGivenNameKey as CNKeyDescriptor,
            CNContactPhoneticMiddleNameKey as CNKeyDescriptor,
            CNContactPhoneticFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneticOrganizationNameKey as CNKeyDescriptor,
            CNContactBirthdayKey as CNKeyDescriptor,
            CNContactNonGregorianBirthdayKey as CNKeyDescriptor,
            CNContactNoteKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactTypeKey as CNKeyDescriptor,
            CNContactDatesKey as CNKeyDescriptor,
            CNContactUrlAddressesKey as CNKeyDescriptor,
            CNContactRelationsKey as CNKeyDescriptor,
            CNContactSocialProfilesKey as CNKeyDescriptor,
            CNContactInstantMessageAddressesKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor ,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactMiddleNameKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor,
            CNContactPostalAddressesKey as CNKeyDescriptor
        ]
        
        
        /// fetch required key descriptors for CNContactContentViewController
        public static let contactController: [CNKeyDescriptor] = [
            CNContactIdentifierKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactViewController.descriptorForRequiredKeys()
        ]
        
        /// fetch brief keys
        public static let brief:[CNKeyDescriptor] = [
            CNContactNamePrefixKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactOrganizationNameKey as CNKeyDescriptor,
            CNContactBirthdayKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactDatesKey as CNKeyDescriptor,
        ]
        
    }
    
    
    //MARK: String Constants
    public struct Strings {
        static let searchBarPlaceHloder = "Search".l10n(resource: "NKContactPicker")
        static let birthdayDateFormat = "MMM d"
        static let contactsTitle = "Contacts".l10n(resource: "NKContactPicker")
        static let phoneNumberNotAvaialable = "No phone numbers available".l10n(resource: "NKContactPicker")
        static let emailNotAvaialable = "No emails available".l10n(resource: "NKContactPicker")
        static let bundleIdentifier = "NKContactsPicker"
        static let cellNibIdentifier = "NKContactPickerCell"
    }
    
    //MARK: Color Constants
    public struct Colors {
        static let emerald = UIColor(red: (46/255), green: (204/255), blue: (113/255), alpha: 1.0)
        static let sunflower = UIColor(red: (241/255), green: (196/255), blue: (15/255), alpha: 1.0)
        static let pumpkin = UIColor(red: (211/255), green: (84/255), blue: (0/255), alpha: 1.0)
        static let asbestos = UIColor(red: (127/255), green: (140/255), blue: (141/255), alpha: 1.0)
        static let amethyst = UIColor(red: (155/255), green: (89/255), blue: (182/255), alpha: 1.0)
        static let peterRiver = UIColor(red: (52/255), green: (152/255), blue: (219/255), alpha: 1.0)
        static let pomegranate = UIColor(red: (192/255), green: (57/255), blue: (43/255), alpha: 1.0)
        
        static let all = [emerald, sunflower, pumpkin, asbestos, amethyst, peterRiver, pomegranate]
    }
}

public extension String {
    public func containsAlphabets() -> Bool {
        //Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains( where: {
            guard let unicode = UnicodeScalar($0) else { return false }
            return set.contains(unicode)
        })
    }
    
}

