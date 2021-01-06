//
//  NKPlaceholdersProvider.swift
//  Pods
//
//  Created by Hamza Ghazouani on 20/07/2017.
//
//

import Foundation
import UIKit

/// This class is responsible for generating placeholders for the table view 
/// Takes a list of NKPlaceholders object and generate for everyone the data source and delegate 
/// A placeholder view is a table view with one cell
final public class NKPlaceholdersProvider {
    
    // MARK: properties
    
    /// The dictionary of placeholders data
    private var placeholdersDictionary = [NKPlaceholderKey: NKPlaceholderDataSourceDelegate]()
    
    // MARK: init methods
    
    
    /// Create and return NKPlaceholdersProvider object with the specified placeholder
    /// By Default, you have 4 placeholders: loading, error, no results, and no internet connection
    /// - Parameters:
    ///   - loading: the loading placeholder
    ///   - error: the placeholder to show when an error occured
    ///   - noResults: the placeholer to show when no results is avaible
    ///   - noConnection: the placeholder of no internet connection
    public init(loading: NKPlaceholder, error: NKPlaceholder, noResults: NKPlaceholder, noConnection: NKPlaceholder) {
        
        placeholdersDictionary = [
            loading.key : NKPlaceholderDataSourceDelegate(placeholder: loading),
            error.key: NKPlaceholderDataSourceDelegate(placeholder: error),
            noResults.key: NKPlaceholderDataSourceDelegate(placeholder: noResults),
            noConnection.key: NKPlaceholderDataSourceDelegate(placeholder: noConnection),
        ]
    }
    
    
    /// Create and return NKPlaceholdersProvider object with the specified (custom) placeholders
    ///
    /// - Parameter placeholders: the placeholders
    public init(placeholders: NKPlaceholder...) {
        placeholders.forEach {
            placeholdersDictionary[$0.key] = NKPlaceholderDataSourceDelegate(placeholder: $0)
        }
    }
    
    /// Allows you to add new placeholders
    public func add(placeholders: NKPlaceholder...) {
        placeholders.forEach {
            placeholdersDictionary[$0.key] = NKPlaceholderDataSourceDelegate(placeholder: $0)
        }
    }
    
    // MARK: utilities methods
    
    
    /// Returns an instance of NKPlaceholderDataSourceDelegate
    /// returns nil of no placeholder found with this key
    /// - Parameter key: the key of the placeholder
    /// - Returns: the NKPlaceholderDataSourceDelegate object with the searched key
    func dataSourceAndDelegate(with key: NKPlaceholderKey) -> NKPlaceholderDataSourceDelegate? {
        return placeholdersDictionary[key]
    }
    
    
    
    /// Returns an instance of NKPlaceholderDataSourceDelegate of default loading key
    /// - Returns: returns NKPlaceholderDataSourceDelegate instance, nil of no placeholder found with this key
    func loadingDataSource() -> NKPlaceholderDataSourceDelegate? {
        return dataSourceAndDelegate(with: .loadingKey)
    }
    
    /// Returns an instance of NKPlaceholderDataSourceDelegate of default error key
    /// - Returns: returns NKPlaceholderDataSourceDelegate instance, nil of no placeholder found with this key
    func errorDataSource() -> NKPlaceholderDataSourceDelegate? {
        return dataSourceAndDelegate(with: .errorKey)!
    }
    
    /// Returns an instance of NKPlaceholderDataSourceDelegate of default no results key
    /// - Returns: returns NKPlaceholderDataSourceDelegate instance, nil of no placeholder found with this key
    func noResultsDataSource() -> NKPlaceholderDataSourceDelegate? {
        return dataSourceAndDelegate(with: .noResultsKey)!
    }
    
    /// Returns an instance of NKPlaceholderDataSourceDelegate of default no connection key
    /// - Returns: returns NKPlaceholderDataSourceDelegate instance, nil of no placeholder found with this key
    func noConnectionDataSource() -> NKPlaceholderDataSourceDelegate? {
        return dataSourceAndDelegate(with: .noConnectionKey)
    }
}

