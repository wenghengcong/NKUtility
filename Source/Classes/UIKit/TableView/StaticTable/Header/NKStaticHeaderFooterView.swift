//
//  NKStaticHeaderFooterView.swift
//  NKUtility
//
//  Created by Hunt on 2021/3/8.
//

import UIKit
import Foundation

open class NKStaticHeaderFooterView: UITableViewHeaderFooterView, NKUIReusable {
    
    public static var headerHeight: CGFloat = NKDesignByW375(44.0)
    
    open var titleLabel: UILabel = UILabel()
    open var descriptionLabel: UILabel = UILabel()

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupAllsubviews()
    }
    
    open var title: String? {
        didSet {
            titleLabel.text = title
            setNeedsDisplay()
        }
    }
    
    open var desc: String? {
        didSet {
            descriptionLabel.text = desc
            setNeedsDisplay()
        }
    }
    
    public init() {
        super.init(reuseIdentifier: "nk_header_footer")
        self.frame = CGRect(x: 0, y: 0, width: NKSCREEN_WIDTH, height: NKStaticHeaderFooterView.headerHeight)
        setupAllsubviews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupAllsubviews()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupAllsubviews()
    }
     
    fileprivate func setupAllsubviews() {
        theme_backgroundColor = .viewBackgroundColor
        contentView.theme_backgroundColor = .viewBackgroundColor //Or any color you want
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        titleLabel.theme_textColor = .titleColor
        titleLabel.font = NKBoldSysFont17
        contentView.addSubview(titleLabel)
        
        
        descriptionLabel.theme_textColor = .subTitleColor
        descriptionLabel.font = NKSysFont13
        contentView.addSubview(descriptionLabel)
        
        contentView.snp
    }
    
    open override func layoutSubviews() {
        
        let left = NKDesignByW375(15.0)
        
        if title != nil && desc != nil {
            titleLabel.sizeToFit()
            let titleHeight = titleLabel.height
            
            descriptionLabel.sizeToFit()
            let descHeight = descriptionLabel.height
            
            descriptionLabel.snp.makeConstraints { (make) in
                make.left.equalTo(left)
                make.right.equalTo(-left)
                make.bottom.equalTo(-7.0)
                make.height.equalTo(descHeight)
            }
            
            titleLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(descriptionLabel.snp.left)
                make.right.equalTo(descriptionLabel.snp.right)
                make.bottom.equalTo(descriptionLabel.snp.top).offset(-5)
                make.height.equalTo(titleHeight)
            })
            
        } else if title != nil {
            titleLabel.sizeToFit()
            let height = titleLabel.height
            titleLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(left)
                make.right.equalTo(left)
                make.bottom.equalTo(-5.0)
                make.height.equalTo(height)
            })
        }
    }
}
