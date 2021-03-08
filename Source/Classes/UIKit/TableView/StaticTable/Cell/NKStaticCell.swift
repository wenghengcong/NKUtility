//
//  NKStaticCell.swift
//  NKUtility
//
//  Created by Hunt on 2021/3/8.
//

import Foundation
import UIKit

open class NKStaticCell: NKUITableViewCell {
  
    public static var cellHeight: CGFloat = NKDesignByW375(44.0)
    
    public var data: NKCommonCellData? {
        didSet {
            fillData()
        }
    }
    
    open func fillData() {
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupSubviews()
    }
    
    func setupSubviews() {
        contentView.theme_backgroundColor = .tableCellBackgroundColor
        theme_tintColor = .titleColor
        
        selectionStyle = .none
    }
    
    
}
