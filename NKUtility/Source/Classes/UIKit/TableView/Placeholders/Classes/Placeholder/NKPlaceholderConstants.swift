//
//  NKPlaceholderConstants.swift
//  FireFly
//
//  Created by Hunt on 2020/12/4.
//

import Foundation

struct NKPlaceholderConstants {
    
    static let l10nStringFile = "NKPlaceholderLocaliziable"
    struct Error {
        static let title = "Whoops!".l10n(resource: l10nStringFile)
        static let subtitle = "We tried, but something went\nteriblly wrong".l10n(resource: l10nStringFile)
        static let actionTitle = "Try Again".l10n(resource: l10nStringFile)
    }
    
    struct NoConnection {
        static let title = "Whoops!".l10n(resource: l10nStringFile)
        static let subtitle = "Slow or no internet connections.\nPlease check your internet settings".l10n(resource: l10nStringFile)
        static let actionTitle = "Try Again".l10n(resource: l10nStringFile)
    }
    
    struct Loading {
        static let title = NKStringGlobal.Sentence.Loading_
        static let subtitle = "The bits are flowing\nslowly today".l10n(resource: l10nStringFile)
        static let actionTitle = NKStringGlobal.Word.Cancel
    }
    
    struct NoResults {
        static let title = "No results founds".l10n(resource: l10nStringFile)
        static let subtitle = "We can’t find what\nyou’re looking for.".l10n(resource: l10nStringFile)
        static let actionTitle = "Try Again".l10n(resource: l10nStringFile)
    }
}
