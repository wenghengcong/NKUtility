//
//  NKUITableViewCell.swift
//  FireFly
//
//  Created by Hunt on 2020/11/4.
//

import UIKit

class NKUITableViewCell: SwipeTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupBaseCell()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupBaseCell() {
        selectedBackgroundView = nil
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
