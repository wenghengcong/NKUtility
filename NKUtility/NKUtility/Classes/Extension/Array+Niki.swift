//
//  Array+Ext.swift
//  FireFly
//
//  Created by Hunt on 2020/11/9.
//

import Foundation

public extension Array {
    /**
     Load a Plist file from the app bundle into a new array
     
     :param: File name
     :throws: EHError : Nil
     :return: Dictionary<String, AnyObject>?
     */
    static func readPlist(_ filename: String) throws -> [String : AnyObject] {
        guard let path = Bundle.appBundle.path(forResource: filename, ofType: "plist")  else {
            throw PlistError.nil("[EasyHelper][readPList] (pathForResource) The file could not be located\nFile : '\(filename).plist'")
        }
        guard let plistDict = NSDictionary(contentsOfFile: path) as? [String : AnyObject] else {
            throw PlistError.nil("[EasyHelper][readPList] (NSDictionary) There is a file error or if the contents of the file are an invalid representation of a dictionary. File : '\(filename)'.plist")
        }

        return plistDict
    }
}
