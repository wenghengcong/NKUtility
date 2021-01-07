//
//  ContactCell.swift
//  JFContactsPicker
//

import UIKit
import Contacts

protocol NKContactPickerCellDelegate: class {
    func clickInfo(cell: NKContactPickerCell, contact: CNContact?)
}

class NKContactPickerCell: UITableViewCell {

    @IBOutlet weak var contactTextLabel: UILabel!
    @IBOutlet weak var contactDetailTextLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactInitialLabel: UILabel!
    @IBOutlet weak var contactContainerView: UIView!
    
    weak var  delegate: NKContactPickerCellDelegate?
    var contact: CNContact?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCell.SelectionStyle.none
        contactContainerView.layer.masksToBounds = true
        contactContainerView.layer.cornerRadius = contactContainerView.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func clickInfoButton(_ sender: Any) {
        delegate?.clickInfo(cell: self, contact: contact)
    }
    
    func updateInitialsColorForIndexPath(_ indexpath: IndexPath) {
        //Applies color to Initial Label
        let colorArray = NKContactConstants.Colors.all
        let randomValue = (indexpath.row + indexpath.section) % colorArray.count
        contactInitialLabel.backgroundColor = colorArray[randomValue]
    }
 
    func updateContactsinUI(_ contact: CNContact, indexPath: IndexPath, subtitleType: SubtitleCellValue) {
        self.contact = contact
        //Update all UI in the cell here
        self.contactTextLabel?.text = contact.displayName
        updateSubtitleBasedonType(subtitleType, contact: contact)
        if contact.thumbnailProfileImage != nil {
            self.contactImageView?.image = contact.thumbnailProfileImage
            self.contactImageView.isHidden = false
            self.contactInitialLabel.isHidden = true
        } else {
            self.contactInitialLabel.text = contact.initials
            updateInitialsColorForIndexPath(indexPath)
            self.contactImageView.isHidden = true
            self.contactInitialLabel.isHidden = false
        }
    }
    
    func updateSubtitleBasedonType(_ subtitleType: SubtitleCellValue , contact: CNContact) {
        
        switch subtitleType {
            
        case SubtitleCellValue.phoneNumber:
            let phoneNumberCount = contact.phoneNums.count
            
            if phoneNumberCount == 1  {
                self.contactDetailTextLabel.text = "\(contact.phoneNums[0].phoneNumber)"
            }
            else if phoneNumberCount > 1 {
                self.contactDetailTextLabel.text = "\(contact.phoneNums[0].phoneNumber) and \(contact.phoneNums.count-1) more"
            }
            else {
                self.contactDetailTextLabel.text = NKContactConstants.Strings.phoneNumberNotAvaialable
            }
        case SubtitleCellValue.email:
            let emailCount = contact.emails.count
        
            if emailCount == 1  {
                self.contactDetailTextLabel.text = "\(contact.emails[0].email)"
            }
            else if emailCount > 1 {
                self.contactDetailTextLabel.text = "\(contact.emails[0].email) and \(contact.emails.count-1) more"
            }
            else {
                self.contactDetailTextLabel.text = NKContactConstants.Strings.emailNotAvaialable
            }
        case SubtitleCellValue.birthday:
            self.contactDetailTextLabel.text = contact.birthdayString
        case SubtitleCellValue.organization:
            self.contactDetailTextLabel.text = contact.company
        }
    }
}
