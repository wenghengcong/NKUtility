//
//  NKSegmentedControl+PredefinedStyles.swift
//  Alamofire
//
//  Created by Nemo on 2022/9/7.
//

#if canImport(UIKit)

import UIKit

public extension NKSegmentedControl {
     class func appleStyled(frame: CGRect, titles: [String]) -> NKSegmentedControl {
        let control = NKSegmentedControl(
            frame: frame,
            segments: NKLabelSegment.segments(withTitles: titles),
            options: [.cornerRadius(8)])
        control.indicatorView.layer.shadowColor = UIColor.black.cgColor
        control.indicatorView.layer.shadowOpacity = 0.1
        control.indicatorView.layer.shadowOffset = CGSize(width: 1, height: 1)
        control.indicatorView.layer.shadowRadius = 2
        
        return control
    }
}

#endif
