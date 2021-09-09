//
//  NKUICollectionViewCell.swift
//  Alamofire
//
//  Created by Hunt on 2021/3/25.
//

import UIKit

open class NKUICollectionViewCell: UICollectionViewCell, NKUINibReusable {
    
    /// 先要将 backView 赋值该 tag
    public let backViewTag = 10223932842
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupBaseCell()
    }
    
    public func showSkeletonInCell() {
        let backView = contentView.viewWithTag(backViewTag)
        backView?.subviews.forEach { view in
            view.isSkeletonable = true
            view.showAnimatedGradientSkeleton()
        }
    }
    
    public func hiddenSkeletonInCell() {
        let backView = contentView.viewWithTag(backViewTag)
        backView?.subviews.forEach { view in
            view.hideSkeleton()
        }
    }

    func setupBaseCell() {
        selectedBackgroundView = nil
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
}
