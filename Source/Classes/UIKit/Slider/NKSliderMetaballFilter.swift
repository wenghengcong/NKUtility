//
//  Filters.swift
//  Fluid
//
//  Created by Dmitry Nesterenko on 18/10/2017.
//  Copyright Ramotion Inc. All rights reserved.
//

import UIKit
import CoreImage

@objc(FLDNKSliderThresholdFilter)
class NKSliderThresholdFilter: CIFilter {
    
    private class Constructor : NSObject, CIFilterConstructor {
        func filter(withName name: String) -> CIFilter? {
            if name == "FLDNKSliderThresholdFilter" {
                return NKSliderThresholdFilter()
            }
            return nil
        }
    }
    
    @objc
    var inputImage : CIImage?
    
    @objc
    var threshold: CGFloat = 0.75
    
    private let filterKernel = CIColorKernel(source: """
kernel vec4 NKSliderThresholdFilter(__sample image, float threshold) {
    float luma = (image.r * 0.2126) + (image.g * 0.7152) + (image.b * 0.0722);
    return (luma > threshold) ? vec4(1.0, 1.0, 1.0, 1.0) : vec4(0.0, 0.0, 0.0, 0.0);
}
"""
    )
    
    class func register() {
        CIFilter.registerName("FLDNKSliderThresholdFilter", constructor: Constructor(), classAttributes: [:])
    }

    override var outputImage : CIImage? {
        guard let inputImage = inputImage, let filterKernel = filterKernel else { return nil }
        return filterKernel.apply(extent: inputImage.extent, arguments: [inputImage, threshold])
    }
    
}

class NKSliderMetaballFilter : CIFilter {
    
    @objc
    var inputImage : CIImage?
    
    var blurRadius: CGFloat = 12
    var threshold: CGFloat = 0.75
    var backgroundColor: UIColor?
    var antialiasingRadius: CGFloat = UIScreen.main.scale / 2
    
    override var outputImage : CIImage? {
        guard let inputImage = inputImage else { return nil }

        // color
        var image = CIFilter(name: "CIColorControls", parameters: [kCIInputBrightnessKey: 1, kCIInputSaturationKey: 0, kCIInputContrastKey: 0, kCIInputImageKey: inputImage])?.outputImage
        
        // blur
        image = image?.applyingGaussianBlur(sigma: Double(blurRadius))
        
        // threshold
        NKSliderThresholdFilter.register()
        image = image?.applyingFilter("FLDNKSliderThresholdFilter", parameters: ["threshold": threshold])

        // invert
        if let backgroundColor = backgroundColor {
            image = image?.applyingFilter("CIFalseColor", parameters: ["inputColor0": CIColor(color: .white), "inputColor1": CIColor(color: backgroundColor)])
        }

        // antialiasing
//        image = image?.applyingFilter("CIDiskBlur", parameters: [kCIInputRadiusKey: antialiasingRadius])

        return image
    }
    
}
