//
//  NKStringGlobal.swift
//  FireFly
//
//  Created by Hunt on 2020/12/7.
//

import Foundation

fileprivate extension String {
    var localizedInCommonString: String {
        let outString = localizedInside(using: "NKCommonString")
        return outString
    }
}

public struct NKStringGlobal {

    
    public struct Word {
        public static let `default` =  "default".localizedInCommonString
        public static let Success = "Success".localizedInCommonString
        public static let Failure = "Failure".localizedInCommonString
        public static let OK = "OK".localizedInCommonString
        public static let Cancel = "Cancel".localizedInCommonString
        public static let Sure = "Sure".localizedInCommonString
    }
    
    public struct Action {
        public static let Add = "Add".localizedInCommonString
        public static let New = "New".localizedInCommonString
        public static let Delete = "Delete".localizedInCommonString
    }
    
    public struct Place {
        public static let home = "home".localizedInCommonString
        public static let work = "work".localizedInCommonString
        public static let school = "school".localizedInCommonString
    }
    
    public struct Object {
        public static let email = "email".localizedInCommonString
        public static let E_mail = "E-mail".localizedInCommonString
        public static let school = "school".localizedInCommonString
    }
    
    public struct Brand {
        public static let iCloud = "iCloud".localizedInCommonString
        public static let Google = "Google".localizedInCommonString
        public static let QQ = "QQ".localizedInCommonString
        public static let _163 = "163".localizedInCommonString
    }
    
    public struct Address {
        public static let Street = "Street".localizedInCommonString
        public static let State = "State".localizedInCommonString
        public static let City = "City".localizedInCommonString
        public static let Country = "Country".localizedInCommonString
        public static let Zipcode = "Zip code".localizedInCommonString
    }
    
    public struct PersonInfo {
        public static let Birthday = "Birthday".localizedInCommonString
        public static let Avatar = "Avatar".localizedInCommonString
        public static let Nickname = "Nickname".localizedInCommonString
    }
    
    public struct Sentence {
        public static let Loading_ = "Loading...".localizedInCommonString
    }
}
