//
//  NKUITableView.swift
//  FireFly
//
//  Created by Hunt on 2020/11/4.
//

import UIKit

open class NKUITableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
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
        
        separatorColor = UIColor.clear
        separatorStyle = .none
        theme_backgroundColor = .viewBackgroundColor
    }
    
    func register() {
        NKCommonCellProvider.shared.register(tableView: self)
    }
}
