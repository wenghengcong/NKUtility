//
//  NKPlaceholderCollectionViewCell.swift
//  Pods
//
//  Created by Hamza Ghazouani on 25/07/2017.
//
//

import UIKit

/// The default cell used for collection view placeholders (takes the size of the collection view)
open class NKPlaceholderCollectionViewCell: UICollectionViewCell {
    
    var onActionButtonTap: (() -> Void)?

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

extension NKPlaceholderCollectionViewCell: NKUIReusable {}
extension NKPlaceholderCollectionViewCell: NKUINibLoadable {}
extension NKPlaceholderCollectionViewCell: NKCellPlaceholding {}
