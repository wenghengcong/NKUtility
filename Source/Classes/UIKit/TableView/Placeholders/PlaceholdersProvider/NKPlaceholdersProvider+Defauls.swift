//
//  NKPlaceholdersProvider+Defauls.swift
//  Pods
//
//  Created by Hamza Ghazouani on 20/07/2017.
//
//

import Foundation
import UIKit

extension NKPlaceholdersProvider {
    
    /// The default2 provider has the same placeholders as default, but with different images
    public static var default2: NKPlaceholdersProvider {
        let style = NKPlaceholderStyle()
        
        var loading = NKPlaceholder(data: .loading, style: style, key: .loadingKey)
        loading.data?.image = NKPlaceholdersProvider.image(named: "hg_default2-loading")
        
        var error = NKPlaceholder(data: .error, style: style, key: .errorKey)
        error.data?.image = NKPlaceholdersProvider.image(named: "hg_default2-error")
        
        var noResults = NKPlaceholder(data: .noResults, style: style, key: .noResultsKey)
        noResults.data?.image =  NKPlaceholdersProvider.image(named: "hg_default2-no_results")
        
        var noConnection = NKPlaceholder(data: .noConnection, style: style, key: .noConnectionKey)
        noConnection.data?.image = NKPlaceholdersProvider.image(named: "hg_default2-error")
        
        let placeholdersProvider = NKPlaceholdersProvider(loading: loading, error: error, noResults: noResults, noConnection: noConnection)
        
        return placeholdersProvider
    }
    
    /// The default provider has 4 placeholders: loading, error, noResults, and no internet conntection
    public static var `default`: NKPlaceholdersProvider {
        let style = NKPlaceholderStyle()
        
        let loading = NKPlaceholder(data: .loading, style: style, key: .loadingKey)
        let error = NKPlaceholder(data: .error, style: style, key: .errorKey)
        let noResults = NKPlaceholder(data: .noResults, style: style, key: .noResultsKey)
        let noConnection = NKPlaceholder(data: .noConnection, style: style, key: .noConnectionKey)
        
        let placeholdersProvider = NKPlaceholdersProvider(loading: loading, error: error, noResults: noResults, noConnection: noConnection)
        return placeholdersProvider
    }
    
    /// The basic provider has the same placeholders as default, but without any images
    public static var basic: NKPlaceholdersProvider {
        let style = NKPlaceholderStyle()
        
        var loading = NKPlaceholder(data: .loading, style: style, key: .loadingKey)
        loading.data?.image = nil
        
        var error = NKPlaceholder(data: .error, style: style, key: .errorKey)
        error.data?.image = nil
        
        var noResults = NKPlaceholder(data: .noResults, style: style, key: .noResultsKey)
        noResults.data?.image = nil
        
        var noConnection = NKPlaceholder(data: .noConnection, style: style, key: .noConnectionKey)
        noConnection.data?.image = nil
        
        let placeholdersProvider = NKPlaceholdersProvider(loading: loading, error: error,
                                                        noResults: noResults, noConnection: noConnection)
        return placeholdersProvider
    }
    
    /// The halloween provider has the same placeholders as default, but with different images and style (for fun :))
    public static var halloween: NKPlaceholdersProvider {
        
        var commonStyle = NKPlaceholderStyle()
        commonStyle.backgroundColor = HGColor.violet
        commonStyle.actionBackgroundColor = .black
        commonStyle.actionTitleColor = HGColor.violet
        commonStyle.isAnimated = false
        
        var loadingStyle = commonStyle
        loadingStyle.actionBackgroundColor = .clear
        loadingStyle.actionTitleColor = .gray
        
        var loadingData: NKPlaceholderData = .loading
        loadingData.image = NKPlaceholdersProvider.image(named:"halloween-loading")
        let loading = NKPlaceholder(data: loadingData, style: loadingStyle, key: .loadingKey)
        
        var errorData: NKPlaceholderData = .error
        errorData.image = NKPlaceholdersProvider.image(named:"halloween-error")
        let error = NKPlaceholder(data: errorData, style: commonStyle, key: .errorKey)
        
        var noResultsData: NKPlaceholderData = .noResults
        noResultsData.image = NKPlaceholdersProvider.image(named:"halloween-no_results")
        let noResults = NKPlaceholder(data: noResultsData, style: commonStyle, key: .noResultsKey)
        
        var noConnectionData: NKPlaceholderData = .noConnection
        noConnectionData.image = NKPlaceholdersProvider.image(named:"halloween-no_network")
        let noConnection = NKPlaceholder(data: noConnectionData, style: commonStyle, key: .noConnectionKey)
        
        let placeholdersProvider = NKPlaceholdersProvider(loading: loading, error: error, noResults: noResults, noConnection: noConnection)
        
        return placeholdersProvider
    }
}

// MARK: images Utilities
extension NKPlaceholdersProvider {
    
    static func image(named name: String) -> UIImage? {
        let image = UIImage(named: name) ?? UIImage(named: name, in: Bundle.nikiFrameworkBundle(), compatibleWith: nil)
        
        return image
    }
}

struct HGColor {
    static let violet = UIColor(red: 250.0/255.0, green: 222.0/255.0, blue: 251.0/255.0, alpha: 1.0)
}
