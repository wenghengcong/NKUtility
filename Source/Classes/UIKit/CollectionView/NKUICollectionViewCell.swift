//
//  NKUICollectionViewCell.swift
//  Alamofire
//
//  Created by Hunt on 2021/3/25.
//

import UIKit
import FluentUI

open class NKUICollectionViewCell: UICollectionViewCell, NKUINibReusable {
    
    /// 先要将 backView 赋值该 tag
    public let backViewTag = 10223932842
    public var shouldShowSkeleton = true

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupBaseCell()
    }
    
    open func qingFillData() {
        hiddenShimmerView()
    }
    
    open func showShimmerView(synchronizer: AnimationSynchronizerProtocol) {
        if shouldShowSkeleton {
            _shimmer(synchronizer: synchronizer)
        }
    }
    
    open func hiddenShimmerView() {
        _removeShimmerView()
    }

    open func setupBaseCell() {
        selectedBackgroundView = nil
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension NKUICollectionViewCell {
    /// associated object key for shimmer view
    private static var shimmerViewKey: UInt8 = 0

    var shimmerView: ShimmerView? {
        get {
            return objc_getAssociatedObject(self, &Self.shimmerViewKey) as? ShimmerView
        }
        set {
            objc_setAssociatedObject(self, &Self.shimmerViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private func _removeShimmerView() {
        self.shimmerView?.removeFromSuperview()
        self.shimmerView = nil
    }

    /// Start or reset the shimmer
    private func _shimmer(synchronizer: AnimationSynchronizerProtocol) {
        layoutIfNeeded()
        
        // because the cells have different layouts in this example, remove and re-add the shimmers
        shimmerView?.removeFromSuperview()

        if let backView = self.contentView.viewWithTag(self.backViewTag) {
            let shimmerView = ShimmerView(containerView: backView, animationSynchronizer: synchronizer)
            contentView.addSubview(shimmerView)
            shimmerView.frame = backView.frame
            shimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.shimmerView = shimmerView
        }
    }
}
