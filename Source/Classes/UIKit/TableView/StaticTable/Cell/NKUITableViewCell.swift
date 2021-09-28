//
//  NKUITableViewCell.swift
//  FireFly
//
//  Created by Hunt on 2020/11/4.
//

import UIKit
import SkeletonView

open class NKUITableViewCell: UITableViewCell, NKUINibReusable {
    
    /// 先要将 backView 赋值该 tag
    public let backViewTag = 10223932842
    public var shouldShowSkeleton = true
    
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
        isSkeletonable = true
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        layoutMargins = UIEdgeInsets.zero
//        separatorInset = UIEdgeInsets.zero
//        preservesSuperviewLayoutMargins = false
//        contentView.isSkeletonable = true
    }
    
    open func qingFillData() {
        hiddenSkeletonInCell()
        
    }
    
    open func showSkeletonInCell() {
        layoutIfNeeded()
        let backView = contentView.viewWithTag(backViewTag)
        backView?.subviews.forEach { view in
            view.isSkeletonable = true
            view.showAnimatedGradientSkeleton()
        }
    }
    
    open func hiddenSkeletonInCell() {
        let backView = contentView.viewWithTag(backViewTag)
        backView?.subviews.forEach { view in
            view.hideSkeleton()
        }
        shouldShowSkeleton = false
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
}
