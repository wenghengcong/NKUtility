//
//  LKFakeSearchBar.swift
//  Lark
//
//  Created by Hunt on 2021/4/24.
//

import Foundation
import UIKit

open class NKFakeSearchBar: UIView {

    open override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }

    var title: String?
    var tapBlock: (() -> Void)?

    public init(frame: CGRect, title: String, tap: (() -> Void)? = nil) {
        super.init(frame: frame)

        self.title = title
        self.tapBlock = tap
        
        self.theme_backgroundColor = .backgroundColor
        self.layerCornerRadius = 15.0
        self.layer.masksToBounds = true

        let searchIconW: CGFloat = 22
        let searchImage = UIImageView(image: UIImage(named: "icon_search"))
        searchImage.frame = CGRect(x: 5, y: (self.height-searchIconW)/2.0, width: searchIconW, height: searchIconW)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapSearchBar))
        searchImage.isUserInteractionEnabled = true
        searchImage.addGestureRecognizer(tapGes)
        addSubview(searchImage)

        let btnX = searchImage.right + 5.0
        let btnW = self.width-btnX-5.0
        let searchBtn = UIButton(frame: CGRect(x: btnX, y: 0, width: btnW, height: self.height))
        searchBtn.setTitle(title, for: .normal)
        searchBtn.theme_setTitleColor(.subTitleColor, forState: .normal)
        searchBtn.titleLabel?.font = NKSysFont14
        searchBtn.titleLabel?.textAlignment = .left
        searchBtn.contentHorizontalAlignment = .left
        searchBtn.backgroundColor = .clear
        searchBtn.addTarget(self, action: #selector(tapSearchBar), for: .touchUpInside)
        addSubview(searchBtn)

    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapSearchBar() {
        if tapBlock != nil {
            tapBlock!()
        }
    }
}
