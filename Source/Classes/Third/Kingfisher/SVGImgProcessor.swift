//
//  SVGImgProcessor.swift
//  NKUtility
//
//  Created by Hunt on 2021/7/24.
//

import Foundation
import UIKit
import Kingfisher
import SVGKit

/// SVG 支持
public struct SVGImgProcessor:ImageProcessor {
    
    public init() {
        
    }
    
    public var identifier: String = "com.chuang.niki.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}

public extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    @discardableResult
    public func setSVGImage(
        with resource: Resource?,
        placeholder: Placeholder? = nil,
        options: KingfisherOptionsInfo? = nil,
        completionHandler: ((Swift.Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask?
    {
        var resultOptions = options
        if let url = resource?.downloadURL,
           url.absoluteString.contains(".svg") {
            if options == nil {
                resultOptions = [.processor(SVGImgProcessor())]
            } else {
                resultOptions = options! + [.processor(SVGImgProcessor())]
            }
        }
        
        return setImage(
            with: resource,
            placeholder: placeholder,
            options: resultOptions,
            progressBlock: nil,
            completionHandler: completionHandler
        )
    }
}
