//
//  NKSegmentedControl+Options.swift
//  Alamofire
//
//  Created by Nemo on 2022/9/7.
//

#if canImport(UIKit)

import UIKit

public extension NKSegmentedControl {
    enum Option {
        /* Selected segment */
        case indicatorViewBackgroundColor(UIColor)
        case indicatorViewInset(CGFloat)
        case indicatorViewBorderWidth(CGFloat)
        case indicatorViewBorderColor(UIColor)
        
        /* Behavior */
        case alwaysAnnouncesValue(Bool)
        case announcesValueImmediately(Bool)
        case panningDisabled(Bool)
        
        /* Animation */
        case animationDuration(TimeInterval)
        case animationSpringDamping(CGFloat)
        
        /* Other */
        case backgroundColor(UIColor)
        case cornerRadius(CGFloat)
    }
}

#endif
