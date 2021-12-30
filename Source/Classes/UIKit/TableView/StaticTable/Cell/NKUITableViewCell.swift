//
//  NKUITableViewCell.swift
//  FireFly
//
//  Created by Hunt on 2020/11/4.
//

import UIKit
import FluentUI

open class NKUITableViewCodeCell: UITableViewCell, NKUIReusable {
    
    /// MARK: - 骨架图相关字段

    /// 先要将 backView 赋值该 tag
    public let backViewTag = 10223932842
    public var shouldShowSkeleton = true
    
    public var excludedViews: [UIView] = []
    public var shimmerStyle: ShimmerStyle = .revealing
    
    open weak var commonDelegate: NKCommonCellProtocol?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseCell()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func setupBaseCell() {
        shouldShowSkeleton = true

        selectedBackgroundView = nil
        selectionStyle = .none
//        layoutMargins = UIEdgeInsets.zero
//        separatorInset = UIEdgeInsets.zero
//        preservesSuperviewLayoutMargins = false
//        contentView.isSkeletonable = true
    }
    
    open func qingFillData() {
//        DispatchQueue.main.asyncAfter(delay: 5.0) {
//            self.hiddenShimmerView()
//        }
        self.hiddenShimmerView()
    }
    
    open func showShimmerView(synchronizer: AnimationSynchronizerProtocol) {
        if shouldShowSkeleton {
            _shimmer(synchronizer: synchronizer)
        }
    }
    
    open func hiddenShimmerView() {
        _removeShimmerView()
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension NKUITableViewCodeCell {
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


open class NKUITableViewCell: UITableViewCell, NKUINibReusable {
    
    /// MARK: - 骨架图相关字段

    /// 先要将 backView 赋值该 tag
    public let backViewTag = 10223932842
    public var shouldShowSkeleton = true
    
    public var excludedViews: [UIView] = []
    public var shimmerStyle: ShimmerStyle = .revealing
    
    open weak var commonDelegate: NKCommonCellProtocol?

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupBaseCell()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseCell()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func setupBaseCell() {
        shouldShowSkeleton = true
        selectedBackgroundView = nil
        selectionStyle = .none
//        layoutMargins = UIEdgeInsets.zero
//        separatorInset = UIEdgeInsets.zero
//        preservesSuperviewLayoutMargins = false
//        contentView.isSkeletonable = true
        
    }
    
    open func qingFillData() {
//        DispatchQueue.main.asyncAfter(delay: 5.0) {
//            self.hiddenShimmerView()
//        }
        self.hiddenShimmerView()
    }

    open func showShimmerView(synchronizer: AnimationSynchronizerProtocol) {
        if shouldShowSkeleton {
            _shimmer(synchronizer: synchronizer)
        }
    }
    
    open func hiddenShimmerView() {
        _removeShimmerView()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension NKUITableViewCell {
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
