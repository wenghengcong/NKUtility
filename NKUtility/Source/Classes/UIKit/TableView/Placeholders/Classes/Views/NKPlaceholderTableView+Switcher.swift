//
//  NKPlaceholderTableView+Switcher.swift
//  Pods
//
//  Created by Hamza Ghazouani on 29/09/2017.
//
//

import UIKit

// MARK: Utilities methods to switch to placeholders
extension NKPlaceholderTableView: NKPlaceholdersSwitcher {
    
    public func showLoadingPlaceholder() {
        guard let dataSource = placeholdersProvider.loadingDataSource() else {
            assertionFailure(NKErrorText.loadingNKPlaceholder.text)
            return
        }
        self.switchTo(dataSource: dataSource, delegate: dataSource)
    }
    
    public func showNoResultsPlaceholder() {
        guard let dataSource = placeholdersProvider.noResultsDataSource() else {
            assertionFailure(NKErrorText.noResultNKPlaceholder.text)
            return
        }
        self.switchTo(dataSource: dataSource, delegate: dataSource)
    }
    
    public func showErrorPlaceholder() {
        guard let dataSource = placeholdersProvider.errorDataSource() else {
            assertionFailure(NKErrorText.errorNKPlaceholder.text)
            return
        }
        self.switchTo(dataSource: dataSource, delegate: dataSource)
    }
    
    public func showNoConnectionPlaceholder() {
        guard let dataSource = placeholdersProvider.noConnectionDataSource() else {
            assertionFailure(NKErrorText.noConnectionNKPlaceholder.text)
            return
        }
        self.switchTo(dataSource: dataSource, delegate: dataSource)
    }
    
    public func showCustomPlaceholder(with key: NKPlaceholderKey) {
        guard let dataSource = placeholdersProvider.dataSourceAndDelegate(with: key) else {
            assertionFailure(NKErrorText.customNKPlaceholder(key: key.value).text)
            return
        }
        self.switchTo(dataSource: dataSource, delegate: dataSource)
    }
    
    public func showDefault() {
        self.switchTo(dataSource: defaultDataSource, delegate: defaultDelegate)
    }
    
}
