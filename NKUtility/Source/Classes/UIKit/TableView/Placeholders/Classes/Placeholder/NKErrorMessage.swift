//
//  ErrorMessage.swift
//  Pods
//
//  Created by Hamza Ghazouani on 29/09/2017.
//
//

import UIKit

enum NKErrorText {
    case loadingNKPlaceholder
    case noResultNKPlaceholder
    case errorNKPlaceholder
    case noConnectionNKPlaceholder
    case customNKPlaceholder(key: String)
    
    var text: String {
        var key: String
        switch self {
        case .loadingNKPlaceholder:
            key = "NKPlaceholderKey.loadingKey"
        case .noResultNKPlaceholder:
            key = "NKPlaceholderKey.noResultsKey"
        case .errorNKPlaceholder:
            key = "NKPlaceholderKey.errorKey"
        case .noConnectionNKPlaceholder:
            key = "NKPlaceholderKey.noConnectionKey"
        case .customNKPlaceholder(let customKey):
            key = customKey
        }
        
        return "Your placeholdersProvider is not configured correctly, no placeholder with key: \(key) found!"
    }
}
