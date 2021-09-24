//
//  NKBadgeLabel.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/9/24.
//

import Foundation
import UIKit

/**
 
 Badge view control for iOS and tvOS.
 
 Project home: https://github.com/evgenyneu/swift-badge
 
 let badge = NKBadgeLabel()
 // Text
 badge.text = "2"
 // Insets
 badge.insets = CGSize(width: 12, height: 12)
 badge.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
 badge.textColor = UIColor.yellow
 
 // Badge color
 badge.badgeColor = UIColor.black
 
 // Shadow
 badge.shadowOpacityBadge = 0.5
 badge.shadowOffsetBadge = CGSize(width: 0, height: 0)
 badge.shadowRadiusBadge = 1.0
 badge.shadowColorBadge = UIColor.black
 
 // No shadow
 badge.shadowOpacityBadge = 0
 
 // Border width and color
 badge.borderWidth = 5.0
 badge.borderColor = UIColor.magenta
 */
@IBDesignable open class NKBadgeLabel: UILabel {
    
    /// Background color of the badge
    @IBInspectable open var badgeColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Width of the badge border
    @IBInspectable open var boardBorderWidth: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Color of the bardge border
    @IBInspectable open var boardBorderColor: UIColor = UIColor.white {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Badge insets that describe the margin between text and the edge of the badge.
    @IBInspectable open var insets: CGSize = CGSize(width: 5, height: 2) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: Badge shadow
    // --------------------------
    
    /// Opacity of the badge shadow
    @IBInspectable open var shadowOpacityBadge: CGFloat = 0.5 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacityBadge)
            setNeedsDisplay()
        }
    }
    
    /// Size of the badge shadow
    @IBInspectable open var shadowRadiusBadge: CGFloat = 0.5 {
        didSet {
            layer.shadowRadius = shadowRadiusBadge
            setNeedsDisplay()
        }
    }
    
    /// Color of the badge shadow
    @IBInspectable open var shadowColorBadge: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColorBadge.cgColor
            setNeedsDisplay()
        }
    }
    
    /// Offset of the badge shadow
    @IBInspectable open var shadowOffsetBadge: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffsetBadge
            setNeedsDisplay()
        }
    }
    
    /// Corner radius of the badge. -1 if unspecified. When unspecified, the corner is fully rounded. Default: -1.
    @IBInspectable open var badgeCornerRadius: CGFloat = -1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Initialize the badge view
    convenience public init() {
        self.init(frame: CGRect())
    }
    
    /// Initialize the badge view
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    /// Initialize the badge view
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    /// Add custom insets around the text
    override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        var insetsWithBorder = actualInsetsWithBorder()
        let rectWithDefaultInsets = rect.insetBy(dx: -insetsWithBorder.width, dy: -insetsWithBorder.height)
        
        // If width is less than height
        // Adjust the width insets to make it look round
        if rectWithDefaultInsets.width < rectWithDefaultInsets.height {
            insetsWithBorder.width = (rectWithDefaultInsets.height - rect.width) / 2
        }
        let result = rect.insetBy(dx: -insetsWithBorder.width, dy: -insetsWithBorder.height)
        
        return result
    }
    
    /// Draws the label with insets
    override open func drawText(in rect: CGRect) {
        if badgeCornerRadius >= 0 {
            layer.cornerRadius = badgeCornerRadius
        }else {
            // Use fully rounded corner if radius is not specified
            layer.cornerRadius = rect.height / 2
        }
        
        let insetsWithBorder = actualInsetsWithBorder()
        let insets = UIEdgeInsets(
            top: insetsWithBorder.height,
            left: insetsWithBorder.width,
            bottom: insetsWithBorder.height,
            right: insetsWithBorder.width)
        
        let rectWithoutInsets = rect.inset(by: insets)
        
        super.drawText(in: rectWithoutInsets)
    }
    
    /// Draw the background of the badge
    override open func draw(_ rect: CGRect) {
        let rectInset = rect.insetBy(dx: boardBorderWidth/2, dy: boardBorderWidth/2)
        
        let actualCornerRadius = badgeCornerRadius >= 0 ? badgeCornerRadius : rect.height/2
        
        var path: UIBezierPath?
        
        if actualCornerRadius == 0 {
            // Use rectangular path when corner radius is zero as a workaround
            // a glith in the left top corner with UIBezierPath(roundedRect).
            path = UIBezierPath(rect: rectInset)
        } else {
            path = UIBezierPath(roundedRect: rectInset, cornerRadius: actualCornerRadius)
        }
        
        badgeColor.setFill()
        path?.fill()
        
        if boardBorderWidth > 0 {
            boardBorderColor.setStroke()
            path?.lineWidth = boardBorderWidth
            path?.stroke()
        }
        
        super.draw(rect)
    }
    
    private func setup() {
        textAlignment = NSTextAlignment.center
        clipsToBounds = false // Allows shadow to spread beyond the bounds of the badge
    }
    
    /// Size of the insets plus the border
    private func actualInsetsWithBorder() -> CGSize {
        return CGSize(
            width: insets.width + boardBorderWidth,
            height: insets.height + boardBorderWidth
        )
    }
    
    /// Draw the stars in interface builder
    @available(iOS 8.0, *)
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
        setNeedsDisplay()
    }
}
