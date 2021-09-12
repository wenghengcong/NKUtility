//
//  LKLabelCell.swift
//  Lark
//
//  Created by Hunt on 2021/3/8.
//

import UIKit

open class NKLabelCell: NKStaticCell {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    open var desc: String? {
        didSet {
            data?.desc = desc
            qingFillData()
        }
    }

    open var title: String? {
        didSet {
            if let titleString = title {
                data?.title = titleString
                qingFillData()
            }
        }
    }

    var hasDesc = false
    
    public override var data: NKCommonCellData? {
        didSet {
            qingFillData()
        }
    }
    
    open override func qingFillData() {
        super.qingFillData()
        if let realData = data {
            if let iconString = realData.icon, iconString.isNotEmpty {
                if let image = UIImage(named: iconString) {
                    iconImageView.image = image
                } else {
                    if let url = URL(string: iconString) {
                        iconImageView.kf.setImage(with: url)
                    }
                }
            }
            
            if let desc = realData.desc, desc.isNotEmpty {
                hasDesc = true
                descLabel.text = desc
            } else {
                hasDesc = false
                descLabel.text = ""
            }

            let detailImage = NKThemeProvider.shared.isNight() ? UIImage(nkBundleNamed: "nk_cell_arrow_right_white") : UIImage(nkBundleNamed: "nk_cell_arrow_right")
            detailImageView.image = detailImage
            detailImageView.isHidden = !realData.hasDetail
            titleLabel.text = realData.title
            setNeedsDisplay()
        }
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
        descLabel.theme_textColor = .subTitleColor
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
                make.width.height.equalTo(25)
                make.left.equalTo(17)
                make.centerY.equalTo(backView.snp.centerY).offset(0)
            }
        }
        
        if detailImageView.isHidden {
            detailImageView.snp.remakeConstraints { (make) in
                make.right.equalTo(0)
                make.width.height.equalTo(0)
                make.centerY.equalTo(0)
            }
        } else {
            detailImageView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(20)
                make.right.equalTo(right)
                make.centerY.equalTo(backView.snp.centerY).offset(0)
            }
        }
        
        let titleLeft = iconImageView.isHidden ? left : 5
        descLabel.isHidden = !hasDesc
        if hasDesc {
            titleLabel.font = UIFont.systemFont(ofSize: 15.0)
            descLabel.font =  UIFont.systemFont(ofSize: 12.0)
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(iconImageView.snp.right).offset(titleLeft)
                make.right.equalTo(detailImageView.snp.left).offset(-5)
                make.top.equalTo(3)
                make.height.equalTo(20)
            }
        } else {
            titleLabel.font =  UIFont.systemFont(ofSize: 17.0)
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(iconImageView.snp.right).offset(titleLeft)
                make.right.equalTo(detailImageView.snp.left).offset(-5)
                make.top.equalTo(0)
                make.height.equalTo(backView.height)
            }
        }
        
        descLabel.snp.remakeConstraints { make in
            make.left.equalTo(titleLabel.snp.left).offset(1)
            make.right.equalTo(titleLabel.snp.right).offset(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.height.equalTo(15)
        }
    }
}
