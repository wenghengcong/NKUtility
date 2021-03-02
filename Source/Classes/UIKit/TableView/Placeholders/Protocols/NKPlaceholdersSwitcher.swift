//
//  NKPlaceholdersShowing.swift
//  Pods
//
//  Created by Hamza Ghazouani on 25/07/2017.
//
//

import UIKit

/// Protocol allows to switch between the different placehodlers used by NKPlaceholderCollectionView and NKPlaceholderTableView
public protocol NKPlaceholdersSwitcher {

    /// Shows loading placeholder, if you call this method and placeholdersProvider does not contains loading placeholder, assertionFailure is called
    func showLoadingPlaceholder()
    
    /// Shows no results placeholder, if you call this method and placeholdersProvider does not contains loading placeholder, assertionFailure is called...
    func showNoResultsPlaceholder()
    
    /// Shows error placeholder, if you call this method and placeholdersProvider does not contains error placeholder, assertionFailure is called...
    func showErrorPlaceholder()
    
    /// Shows no internet connection placeholder, if you call this method and placeholdersProvider does not contains no internet connection placeholder, assertionFailure is called
    func showNoConnectionPlaceholder()
    
    /// Shows a custom placeholder
    /// If you call this method and placeholdersProvider does not contains this custom placeholder, assertionFailure is called
    /// - Parameter key: the key of the custom placeholder
    func showCustomPlaceholder(with key: NKPlaceholderKey)
    
    /// Shows the default data of the collection view
    func showDefault()
}
