//
//  NKUICollectionViewCell.swift
//  Alamofire
//
//  Created by Hunt on 2021/3/25.
//

import UIKit

open class NKUICollectionViewCell: UICollectionViewCell, NKUINibReusable {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupBaseCell()
    }

    func setupBaseCell() {
        selectedBackgroundView = nil
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
}
