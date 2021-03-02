//
//  NKPlaceholderConstants.swift
//  FireFly
//
//  Created by Hunt on 2020/12/4.
//

import Foundation

fileprivate extension String {
    var localizedInPlaceholder: String {
        let outString = localizedInside(using: "NKPlaceholderLocaliziable")
        return outString
    }
}

struct NKPlaceholderConstants {
    
    static let l10nStringFile = "NKPlaceholderLocaliziable"
    struct Error {
        static let title = "Whoops!".localizedInPlaceholder
        static let subtitle = "We tried, but something went\nteriblly wrong".localizedInPlaceholder
        static let actionTitle = "Try Again".localizedInPlaceholder
    }
    
    struct NoConnection {
        static let title = "Whoops!".localizedInPlaceholder
        static let subtitle = "Slow or no internet connections.\nPlease check your internet settings".localizedInPlaceholder
        static let actionTitle = "Try Again".localizedInPlaceholder
    }
    
    struct Loading {
        static let title = NKStringGlobal.Sentence.Loading_
        static let subtitle = "The bits are flowing\nslowly today".localizedInPlaceholder
        static let actionTitle = NKStringGlobal.Word.Cancel
    }
    
    struct NoResults {
        static let title = "No results founds".localizedInPlaceholder
        static let subtitle = "We can’t find what\nyou’re looking for.".localizedInPlaceholder
        static let actionTitle = "Try Again".localizedInPlaceholder
    }
}
