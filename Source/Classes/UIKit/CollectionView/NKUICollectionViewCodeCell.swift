//
//  NKUICollectionCodeCell.swift
//  NKUtility
//
//  Created by Nemo on 2022/8/24.
//

import UIKit
import FluentUI

open class NKUICollectionViewCodeCell: UICollectionViewCell, NKUIReusable {
    /// MARK: - 骨架图相关字段

    /// 先要将 backView 赋值该 tag
    public let backViewTag = 10223932842
    public var shouldShowSkeleton = true
    
    public var excludedViews: [UIView] = []
    public var shimmerStyle: ShimmerStyle = .revealing

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseCell()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
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

extension NKUICollectionViewCodeCell {
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
            self.shimmerView = NKShimmerViewHelper.cellShimmerView(superView: contentView, shimmerOriginView: backView, excludedViews: excludedViews, animationSynchronizer: synchronizer, shimmerStyle: shimmerStyle)
        }
    }
}
