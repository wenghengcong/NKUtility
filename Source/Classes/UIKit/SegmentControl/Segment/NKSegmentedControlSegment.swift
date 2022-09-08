//
//  NKSegmentedControlSegment.swift
//  Alamofire
//
//  Created by Nemo on 2022/9/7.
//

#if canImport(UIKit)

import UIKit

/// A segment is comprised of a normal state view and a selected state view. These need to be separate view instances.
public protocol NKSegmentedControlSegment {
    /// If provided, `NKSegmentedControl` will use its value to calculate an `intrinsicContentSize` based on this.
    var intrinsicContentSize: CGSize? { get }
    
    /// The view to be shown for the normal or unselected state.
    var normalView: UIView { get }
    
    /// The view to be shown for the active or selected state.
    var selectedView: UIView { get }
}

#endif
