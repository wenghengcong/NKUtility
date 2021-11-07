//
//  NKUITableView.swift
//  FireFly
//
//  Created by Hunt on 2020/11/4.
//

import UIKit
import SwiftTheme

open class NKUITableView: UITableView {

    init() {
        super.init(frame: CGRect.zero, style: .plain)
        setupBaseTableView()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupBaseTableView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupBaseTableView() {
        register()
        
//        theme_separatorColor = ThemeColorPicker.pickerWithUIColors([UIColor.clear, UIColor.clear])
//        separatorStyle = .none
        theme_backgroundColor = .viewBackgroundColor
    }
    
    func register() {
        NKCommonCellProvider.shared.register(tableView: self)
    }
}
