//
//  ColorSwatchView.swift
//  EurekaColorPicker
//
//  Created by Mark Alldritt on 2017-04-22.
//  Copyright © 2017 Late Night Software Ltd. All rights reserved.
//

import UIKit

public class ColorSwatchView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    public var isCircular = false {
        didSet {
            setNeedsDisplay()
        }
    }
    public var color : UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    public var isSelected = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func draw(_ rect: CGRect) {
        if let color = color {
            let swatchRect = bounds.insetBy(dx: 1.0, dy: 1.0)
            let path = isCircular ? UIBezierPath(ovalIn: swatchRect) : UIBezierPath(roundedRect: swatchRect, cornerRadius: CGFloat(Int(swatchRect.width * 0.2)))
            
            color.setFill()
            path.fill()
            
            if isSelected {
                let frameColor = color.blackOrGrayContrastingColor()
                let selectRect = bounds.insetBy(dx: 2.0, dy: 2.0)
                let selectPath = isCircular ? UIBezierPath(ovalIn: selectRect) : UIBezierPath(roundedRect: selectRect, cornerRadius: CGFloat(Int(selectRect.width * 0.2)))

                frameColor.setStroke()
                selectPath.lineWidth = 3.0
                selectPath.stroke()
                
                if frameColor == UIColor.white && false {
                    let outlinePath = isCircular ? UIBezierPath(ovalIn: bounds) : UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(Int(bounds.width * 0.2)))
                    UIColor.black.setStroke()
                    outlinePath.lineWidth = 0.5
                    outlinePath.stroke()
                }
            }
        }
    }
}
