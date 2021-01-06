//
//  NKPlaceholderData.swift
//  Pods
//
//  Created by Hamza Ghazouani on 20/07/2017.
//
//

import UIKit

/// Contains the placeholder data: texts, image, etc 
public struct NKPlaceholderData {
    
    // MARK: properties
    
    /// The placeholder image, if the image is nil, the placeholder image view will be hidden
    public var image: UIImage?
    
    /// the placeholder title
    public var title: String?
    
    /// The placeholder subtitle
    public var subtitle: String?
    
    /// The placehlder action title, if the action title is nil, the placeholder action button will be hidden
    public var action: String?
    
    /// Should shows the activity indicator of the placeholder or not
    public var showsLoading = false
    
    // MARK: init methods
    
    
    /// Create and return NKPlaceholderData object
    public init() {}
    
    // MARK: Defaults placeholders data
    
    /// The default data (texts, image, ...) of the default no results placeholder
    public static var noResults: NKPlaceholderData {
        var noResultsStyle = NKPlaceholderData()
        noResultsStyle.image = NKPlaceholdersProvider.image(named: "hg_default-no_results")
        noResultsStyle.title = NKPlaceholderConstants.NoResults.title
        noResultsStyle.subtitle = NKPlaceholderConstants.NoResults.subtitle
        noResultsStyle.action = NKPlaceholderConstants.NoResults.actionTitle
        
        return noResultsStyle
    }
    
    /// The default data (texts, image, ...) of the default loading placeholder
    public static var loading: NKPlaceholderData {
        var loadingStyle = NKPlaceholderData()
        loadingStyle.image = NKPlaceholdersProvider.image(named: "hg_default-loading")
        loadingStyle.title = NKPlaceholderConstants.NoResults.title
        loadingStyle.subtitle = NKPlaceholderConstants.NoResults.subtitle
        loadingStyle.action = NKPlaceholderConstants.NoResults.actionTitle
        loadingStyle.showsLoading = true
        
        return loadingStyle
    }
    
    /// The default data (texts, image, ...) of the default error placeholder
    public static var error: NKPlaceholderData {
        var errorStyle = NKPlaceholderData()
        errorStyle.image = NKPlaceholdersProvider.image(named: "hg_default-error")
        errorStyle.title = NKPlaceholderConstants.NoResults.title
        errorStyle.subtitle = NKPlaceholderConstants.NoResults.subtitle
        errorStyle.action = NKPlaceholderConstants.NoResults.actionTitle
        
        return errorStyle
    }
    
    /// The default data (texts, image, ...) of the default no connecton placeholder
    public static var noConnection: NKPlaceholderData {
        var noConnectionStyle = NKPlaceholderData()
        noConnectionStyle.image = NKPlaceholdersProvider.image(named: "hg_default-no_connection")
        noConnectionStyle.title = NKPlaceholderConstants.NoResults.title
        noConnectionStyle.subtitle = NKPlaceholderConstants.NoResults.subtitle
        noConnectionStyle.action = NKPlaceholderConstants.NoResults.actionTitle
        
        return noConnectionStyle
    }
}
