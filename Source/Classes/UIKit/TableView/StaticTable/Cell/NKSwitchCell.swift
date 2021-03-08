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
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var switchControl: UISwitch!
        
    public override var data: NKCommonCellData? {
        didSet {
            fillData()
        }
    }
    
    public override func fillData() {
        setup(icon: data!.icon, title: data!.title, on: data!.on)
    }
    
    func setup(icon: String?, title: String, on: Bool?) {
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
        
        if let switchOn = on {
            switchControl.isOn = switchOn
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
