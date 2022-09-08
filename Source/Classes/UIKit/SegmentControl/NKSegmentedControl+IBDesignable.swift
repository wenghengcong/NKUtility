//
//  NKSegmentedControl+IBDesignable.swift
//  Alamofire
//
//  Created by Nemo on 2022/9/7.
//

#if canImport(UIKit)

import UIKit

extension NKSegmentedControl {
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setDefaultColorsIfNeeded()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        setDefaultColorsIfNeeded()
    }
    private func setDefaultColorsIfNeeded() {
        if #available(iOS 13.0, *) {
            if backgroundColor == UIColor.systemBackground || backgroundColor == nil {
                backgroundColor = .appleSegmentedControlDefaultControlBackground
            }
            if indicatorViewBackgroundColor == UIColor.systemBackground || indicatorViewBackgroundColor == nil {
                indicatorViewBackgroundColor = .appleSegmentedControlDefaultIndicatorBackground
            }
        } else {
            if backgroundColor == nil {
                backgroundColor = .appleSegmentedControlDefaultControlBackground
            }
            if indicatorViewBackgroundColor == nil {
                indicatorViewBackgroundColor = .appleSegmentedControlDefaultIndicatorBackground
            }
        }
    }
}

#endif
