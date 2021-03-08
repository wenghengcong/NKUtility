//
//  NKUITableViewCell.swift
//  FireFly
//
//  Created by Hunt on 2020/11/4.
//

import UIKit

open class NKUITableViewCell: UITableViewCell, NKUINibReusable {

    open weak var commonDelegate: NKCommonCellProtocol?

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupBaseCell()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseCell()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupBaseCell() {
        selectedBackgroundView = nil
        
//        layoutMargins = UIEdgeInsets.zero
//        separatorInset = UIEdgeInsets.zero
//        preservesSuperviewLayoutMargins = false
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
