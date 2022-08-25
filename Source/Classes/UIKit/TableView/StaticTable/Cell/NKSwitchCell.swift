//
//  LKSwitchCell.swift
//  Lark
//
//  Created by Hunt on 2021/3/7.
//

import UIKit
import Kingfisher
import NKUtility

open class NKSwitchCell: NKStaticCell {
    
    @IBOutlet weak var backView: UIView!
    
     @IBOutlet public weak var iconImageView: UIImageView!
    
     @IBOutlet public weak var titleLabel: UILabel!
    
     @IBOutlet public weak var switchControl: UISwitch!
        
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
        
        if let switchOn = data?.on {
            switchControl.isOn = switchOn
        }
        
        if let enable = data?.enable {
            switchControl.isEnabled = enable
        }
        setNeedsDisplay()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupSubviews()
        addControl()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        backView.theme_backgroundColor = .tableCellBackgroundColor
        titleLabel.theme_textColor = .titleColor
    }
    
    func addControl() {
        switchControl.addTarget(self, action: #selector(clickSwith(control:)), for: .valueChanged)
    }
    
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func clickSwith(control: UISwitch) {
        commonDelegate?.switchUpdate(in: self, with: switchControl.isOn)
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
        
        let titleLeft = iconImageView.isHidden ? left : 5
        titleLabel.font = NKRegularFont(ofSize: 17.0)
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(titleLeft)
            make.right.equalTo(backView.snp.right).offset(right)
            make.top.equalTo(0)
            make.height.equalTo(backView.height)
        }
    }
}
