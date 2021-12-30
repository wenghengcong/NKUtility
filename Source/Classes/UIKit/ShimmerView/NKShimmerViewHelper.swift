//
//  NKShimmerViewHelper.swift
//  Alamofire
//
//  Created by wenghengcong on 2021/12/30.
//

import Foundation
import FluentUI
import UIKit

class NKShimmerViewHelper {
    
    
    /// 返回 cell 的 shimmerView
    static func cellShimmerView(superView: UIView?,
                                shimmerOriginView: UIView? = nil,
                                excludedViews: [UIView] = [],
                                animationSynchronizer: AnimationSynchronizerProtocol? = nil,
                                shimmerStyle: ShimmerStyle = .revealing) -> ShimmerView? {
        guard let originView = shimmerOriginView else {
            return nil
        }
        
        let shimmerView = ShimmerView(containerView: originView, excludedViews: excludedViews, animationSynchronizer: animationSynchronizer, shimmerStyle: shimmerStyle)
        superView?.addSubview(shimmerView)
        shimmerView.frame = originView.frame
        // label 禁用自动高度，第一步，labelHeight 默认是 11，第二步 usesTextHeightForLabels是字体行高。两处禁用，才是设置的高度
        shimmerView.labelHeight = -1
        shimmerView.usesTextHeightForLabels = false
        shimmerView.cornerRadius = 5.0
        shimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return shimmerView
    }
    
}
