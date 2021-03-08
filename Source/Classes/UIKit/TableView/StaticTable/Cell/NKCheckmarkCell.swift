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
            fillData()
        }
    }
    
    open override func fillData() {
        setup(icon: data!.icon, title: data!.title, check: data!.on)
        
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
    
    override func setupSubviews() {
        super.setupSubviews()
        backView.theme_backgroundColor = .tableCellBackgroundColor
        titleLabel.theme_textColor = .titleColor
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let left = NKDesignByW375(15.0)

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
                make.left.equalTo(left)
                make.centerY.equalTo(0)
            }
        }
    }
    
}
