//
//  String+Niki.swift
//  FireFly
//
//  Created by Hunt on 2020/11/29.
//

import Foundation

extension String {
    
    /// 是否是空的
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    var digits: String {
         return components(separatedBy: CharacterSet.decimalDigits.inverted)
             .joined()
     }
    
    var alphaNumeric: String {
            return components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        }
    
    /**
        remove characters

        used filter to remove

     - Parameter retainChars: the character set will be retain
     - Returns: the result
        ~~~
        let character = "1Vi234s56a78l9"
        let alphaNumericSet = character.removeCharacters(from: CharacterSet.decimalDigits.inverted)
        print(alphaNumericSet) // will print: 123456789
        ~~~
    */
    func removeCharacters(from retainChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !retainChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    /**
        remove characters

        used filter to remove

     - Parameter from: the characters will be removed
     - Returns: the result
        ~~~
        let character = "1Vi234s56a78l9"
        let alphaNumericCharacterSet = character.removeCharacters(from: "0123456789")
        print("no digits",alphaNumericCharacterSet) // will print: Vishal
        ~~~
    */
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
}
