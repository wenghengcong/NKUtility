//
//  NKPlaceholderTableViewCell.swift
//  Pods
//
//  Created by Hamza Ghazouani on 20/07/2017.
//
//

import UIKit

/// The default cell used for table view placeholders (takes the size of the table view)
open class NKPlaceholderTableViewCell: UITableViewCell {
   
    var onActionButtonTap: (() -> Void)?
    
    // MARK: Properties 
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var subtitleLabel: UILabel?
    @IBOutlet weak var placeholderImageView: UIImageView?
    @IBOutlet weak var actionButton: UIButton?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    var cellView: UIView {
        return self
    }
    
    //  MARK: - User interaction
    
    @IBAction func sendNKPlaceholderAction(_ sender: Any) {
        onActionButtonTap?()
        NKlogger.debug("NKPlaceholder action button tapped")
    }
}

extension NKPlaceholderTableViewCell: NKUINibLoadable {}
extension NKPlaceholderTableViewCell: NKUIReusable {}
extension NKPlaceholderTableViewCell: NKCellPlaceholding {}


