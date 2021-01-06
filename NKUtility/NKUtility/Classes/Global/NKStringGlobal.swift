//
//  NKStringGlobal.swift
//  FireFly
//
//  Created by Hunt on 2020/12/7.
//

import Foundation

struct NKStringGlobal {
    static let resouceTable = "NKCommonString"
    
    struct Word {
        static let `default` = "default".l10n(resource: resouceTable)
        static let Success = "Success".l10n(resource: resouceTable)
        static let Failure = "Failure".l10n(resource: resouceTable)
        static let OK = "OK".l10n(resource: resouceTable)
        static let Cancel = "Cancel".l10n(resource: resouceTable)
        static let Sure = "Sure".l10n(resource: resouceTable)
    }
    
    struct Action {
        static let Add = "Add".l10n(resource: resouceTable)
        static let New = "New".l10n(resource: resouceTable)
        static let Delete = "Delete".l10n(resource: resouceTable)
    }
    
    struct Place {
        static let home = "home".l10n(resource: resouceTable)
        static let work = "work".l10n(resource: resouceTable)
        static let school = "school".l10n(resource: resouceTable)
    }
    
    struct Object {
        static let email = "email".l10n(resource: resouceTable)
        static let E_mail = "E-mail".l10n(resource: resouceTable)
        static let school = "school".l10n(resource: resouceTable)
    }
    
    struct Brand {
        static let iCloud = "iCloud".l10n(resource: resouceTable)
        static let Google = "Google".l10n(resource: resouceTable)
        static let QQ = "QQ".l10n(resource: resouceTable)
        static let _163 = "163".l10n(resource: resouceTable)
    }
    
    struct Address {
        static let Street = "Street".l10n(resource: resouceTable)
        static let State = "State".l10n(resource: resouceTable)
        static let City = "City".l10n(resource: resouceTable)
        static let Country = "Country".l10n(resource: resouceTable)
        static let Zipcode = "Zip code".l10n(resource: resouceTable)
    }
    
    struct PersonInfo {
        static let Birthday = "Birthday".l10n(resource: resouceTable)
        static let Avatar = "Avatar".l10n(resource: resouceTable)
        static let Nickname = "Nickname".l10n(resource: resouceTable)
    }
    
    struct Sentence {
        static let Loading_ = "Loading...".l10n(resource: resouceTable)
    }
}
