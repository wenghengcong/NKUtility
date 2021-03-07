//
//  LKCheckmarkCell.swift
//  Lark
//
//  Created by Hunt on 2021/3/7.
//

import UIKit
import SwiftTheme

open class NKCheckmarkCell: NKUITableViewCell {
    public static var cellHeight: CGFloat = NKDesignByW375(44.0)
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    public var data: NKCommonCellData? {
        didSet {
            fillData()
        }
    }
    
    func fillData() {
        setup(icon: data!.icon, title: data!.title, check: data!.on)
        
        setNeedsDisplay()
    }
    
    func setup(icon: String?, title: String, check: Bool?) {
        if let iconString = icon {
            if let image = UIImage(named: iconString) {
                iconImageView.image = image
            } else {
                if let url = URL(string: iconString) {
                    iconImageView.kf.setImage(with: url)
                }
            }
        }
        
        titleLabel.text = title
        
        if let on = check {
            checkMarkImageView.isHidden = !on
        }
        setNeedsDisplay()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupSubviews()
    }
    
    func setupSubviews() {
        backView.theme_backgroundColor = .tableCellBackgroundColor
        titleLabel.theme_textColor = .titleColor
        contentView.theme_backgroundColor = .tableCellBackgroundColor
        theme_tintColor = .titleColor
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkMarkImageView.isHidden = !selected
    }

    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if iconImageView.image == nil {
            iconImageView.isHidden = true
            iconImageView.snp.updateConstraints { (make) in
                make.left.equalTo(0)
                make.width.height.equalTo(0)
            }
            
        } else {
            iconImageView.isHidden = false
            iconImageView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(NKDesignByW375(30))
                make.left.equalTo(15)
                make.centerY.equalTo(0)
            }
        }
    }
    
}
