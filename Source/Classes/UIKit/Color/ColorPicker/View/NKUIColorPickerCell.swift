//
// Copyright (c) 2017 iGenius Srl
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

/**
 Color Picker from [IGColorPicker](https://github.com/iGenius-Srl/IGColorPicker)
 Usage example
 ```
 colorPickerView.delegate = self
 colorPickerView.layoutDelegate = self
 colorPickerView.isSelectedColorTappable = false
 colorPickerView.style = .square
 colorPickerView.selectionStyle = .check
 colorPickerView.backgroundColor = .clear
 
 func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
     self.view.backgroundColor = colorPickerView.colors[indexPath.item]
 }
 
 // MARK: - ColorPickerViewDelegateFlowLayout
 
 func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
     return CGSize(width: 100, height: 100)
 }
 
 func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     return 0
 }
 
 func colorPickerView(_ colorPickerView: ColorPickerView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     return 0
 }
 
 func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets {
     return UIEdgeInsets.zero
 }
 ```
 */
class NKUIColorPickerCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// The reuse identifier used to register the UICollectionViewCell to the UICollectionView
    static let cellIdentifier = String(describing: NKUIColorPickerCell.self)
    /// The checkbox use to show the tip on the cell
    var checkbox = M13Checkbox()
    
    //MARK: - Initializer
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    fileprivate func commonInit() {
        
        // Setup of checkbox
        checkbox.isUserInteractionEnabled = false
        checkbox.backgroundColor = .clear
        checkbox.hideBox = true
        checkbox.setCheckState(.unchecked, animated: false)
        
        self.addSubview(checkbox)
        
        // Setup constraints to checkbox
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: checkbox, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: checkbox, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: checkbox, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: checkbox, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
    }
    
}
