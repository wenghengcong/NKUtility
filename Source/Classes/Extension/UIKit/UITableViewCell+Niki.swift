//
//  UITableViewCell+Niki.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/5/24.
//

import Foundation
import UIKit

public extension UITableViewCell {
    public func separator(hide: Bool) {
        //        separatorInset.left = hide ? bounds.size.width : 0
        separatorInset = UIEdgeInsets(top: 0, left: max(UIScreen.main.bounds.width, UIScreen.main.bounds.height), bottom: 0, right: 0)
    }
}
