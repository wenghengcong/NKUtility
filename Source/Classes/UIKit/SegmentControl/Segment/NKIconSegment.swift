//
//  NKIconSegment.swift
//  Alamofire
//
//  Created by Nemo on 2022/9/7.
//

#if canImport(UIKit)

import UIKit

open class NKIconSegment: NKSegmentedControlSegment {
    // MARK: Constants
    private struct DefaultValues {
        static let normalBackgroundColor: UIColor = .clear
        static let selectedBackgroundColor: UIColor = .clear
    }
    
    // MARK: Properties
    public var icon: UIImage
    public var iconSize: CGSize
    
    public var normalIconTintColor: UIColor
    public var normalBackgroundColor: UIColor
    
    public var selectedIconTintColor: UIColor
    public var selectedBackgroundColor: UIColor
    
    // MARK: Lifecycle
    public init(icon: UIImage,
                iconSize: CGSize,
                normalBackgroundColor: UIColor? = nil,
                normalIconTintColor: UIColor,
                selectedBackgroundColor: UIColor? = nil,
                selectedIconTintColor: UIColor) {
        self.icon = icon.withRenderingMode(.alwaysTemplate)
        self.iconSize = iconSize
        self.normalBackgroundColor = normalBackgroundColor ?? DefaultValues.normalBackgroundColor
        self.normalIconTintColor = normalIconTintColor
        self.selectedBackgroundColor = selectedBackgroundColor ?? DefaultValues.selectedBackgroundColor
        self.selectedIconTintColor = selectedIconTintColor
    }
    
    // MARK: NKSegmentedControlSegment
    public var intrinsicContentSize: CGSize? { nil }
    
    public lazy var normalView: UIView = {
        return createView(withIcon: icon,
                          iconSize: iconSize,
                          backgroundColor: normalBackgroundColor,
                          iconTintColor: normalIconTintColor)
    }()
    public lazy var selectedView: UIView = {
       return createView(withIcon: icon,
                         iconSize: iconSize,
                         backgroundColor: selectedBackgroundColor,
                         iconTintColor: selectedIconTintColor)
    }()
    private func createView(withIcon icon: UIImage,
                            iconSize: CGSize,
                            backgroundColor: UIColor,
                            iconTintColor: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        let imageView = UIImageView(image: icon)
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: iconSize.width,
                                 height: iconSize.height)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = iconTintColor
        imageView.autoresizingMask = [.flexibleTopMargin,
                                      .flexibleLeftMargin,
                                      .flexibleRightMargin,
                                      .flexibleBottomMargin]
        view.addSubview(imageView)
        return view
    }
}

public extension NKIconSegment {
    class func segments(withIcons icons: [UIImage],
                        iconSize: CGSize,
                        normalBackgroundColor: UIColor? = nil,
                        normalIconTintColor: UIColor,
                        selectedBackgroundColor: UIColor? = nil,
                        selectedIconTintColor: UIColor) -> [NKSegmentedControlSegment] {
        return icons.map {
            NKIconSegment(icon: $0,
                        iconSize: iconSize,
                        normalBackgroundColor: normalBackgroundColor,
                        normalIconTintColor: normalIconTintColor,
                        selectedBackgroundColor: selectedBackgroundColor,
                        selectedIconTintColor: selectedIconTintColor)
        }
    }
}

#endif
