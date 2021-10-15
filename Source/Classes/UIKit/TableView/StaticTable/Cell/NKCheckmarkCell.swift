//
//  LKCheckmarkCell.swift
//  Lark
//
//  Created by Hunt on 2021/3/7.
//

import UIKit
import SwiftTheme

open class NKCheckmarkCell: NKStaticCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    open var check: Bool = false {
        didSet {
            data?.on = check
            checkMarkImageView.isHidden = !check
        }
    }
    
    public override var data: NKCommonCellData? {
        didSet {
            qingFillData()
        }
    }
    
    open override func qingFillData() {
        super.qingFillData()
        if let iconString = data?.icon, iconString.isNotEmpty {
            if let image = UIImage(named: iconString) {
                iconImageView.image = image
            } else {
                if let url = URL(string: iconString) {
                    iconImageView.kf.setImage(with: url)
                }
            }
        }
        
        titleLabel.text = data?.title
        if let on = data?.on {
            checkMarkImageView.isHidden = !on
        }
                
        setNeedsDisplay()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupSubviews()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        backView.theme_backgroundColor = .tableCellBackgroundColor
        titleLabel.theme_textColor = .titleColor
        checkMarkImageView.image = UIImage(nkBundleNamed: "nk_cell_checkmark")
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let left = 15.0
        let right = -12.0

        backView.snp.remakeConstraints { make in
            make.edges.equalTo(0)
        }
        
        if iconImageView.image == nil {
            iconImageView.isHidden = true
            iconImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(0)
                make.width.height.equalTo(0)
                make.centerY.equalTo(backView.snp.centerY).offset(0)
            }
            
        } else {
            iconImageView.isHidden = false
            iconImageView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(30)
                make.left.equalTo(17)
                make.centerY.equalTo(backView.snp.centerY).offset(0)
            }
        }
        
        checkMarkImageView.snp.remakeConstraints { make in
            make.width.height.equalTo(30)
            make.right.equalTo(backView.snp.right).offset(-10)
            make.centerY.equalTo(backView.snp.centerY).offset(0)
        }
        
        let titleLeft = iconImageView.isHidden ? left : 5
        titleLabel.font = UIFont.systemFont(ofSize: 17.0)
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(titleLeft)
            make.right.equalTo(checkMarkImageView.snp.left).offset(-10)
            make.top.bottom.equalTo(0)
        }
    }
    
}
