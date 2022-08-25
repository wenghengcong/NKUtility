//
//  NKFontDefaultSize.swift
//  DuZi
//
//  Created by Nemo on 2022/8/24.

/**
 Default text sizes taken from Apple's Human Interface Guidelines ([iOS](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/), [watchOS](https://developer.apple.com/design/human-interface-guidelines/watchos/visual-design/typography/), [tvOS](https://developer.apple.com/design/human-interface-guidelines/tvos/visual-design/typography/)). These sizes correspond to the default category used by `UIFontMetrics` for dynamic type. It varies per OS and device.
 
  https://developer.apple.com/design/human-interface-guidelines/foundations/typography/
  Large (Default)
  Style          Weight      Size (points)    Leading (points)
  Large Title    Regular      34                 41
  Title 1        Regular      28                 34
  Title 2        Regular      22                 28
  Title 3        Regular      20                 25
  Headline       Semibold     17                 22
  Body           Regular      17                 22
  Callout        Regular      16                 21
  Subhead        Regular      15                 20
  Footnote       Regular      13                 18
  Caption 1      Regular      12                 16
  Caption 2      Regular      11                 13
  
 */


#if os(iOS)
import UIKit
@available(iOS 11.0, *)
internal let defaultFontSizes: [UIFont.TextStyle: CGFloat] =
    [.caption2: 11,
     .caption1: 12,
     .footnote: 13,
     .subheadline: 15,
     .callout: 16,
     .body: 17,
     .headline: 17,
     .title3: 20,
     .title2: 22,
     .title1: 28,
     .largeTitle: 34]
#endif


/*----tvos----*/
#if os(tvOS)
import UIKit

@available(tvOS 11.0, *)
internal let defaultFontSizes: [UIFont.TextStyle: CGFloat] =
    [.caption2: 23,
     .caption1: 25,
     .footnote: 29,
     .subheadline: 29,
     .body: 29,
     .callout: 31,
     .headline: 38,
     .title3: 48,
     .title2: 57,
     .title1: 76]
#endif

/*----watchOS----*/
#if os(watchOS)
import WatchKit

/**
 Default text sizes taken from Apple's Human Interface Guidelines ([iOS](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/), [watchOS](https://developer.apple.com/design/human-interface-guidelines/watchos/visual-design/typography/), [tvOS](https://developer.apple.com/design/human-interface-guidelines/tvos/visual-design/typography/)). These sizes correspond to the default category used by `UIFontMetrics` for dynamic type. It varies per OS and device.
 */
internal let defaultFontSizes: [UIFont.TextStyle: CGFloat] = {
    if #available(watchOS 5.0, *) {
        switch (WKInterfaceDevice.current().preferredContentSizeCategory) {
        case "UICTContentSizeCategoryS":
            return [.footnote: 12,
                    .caption2: 13,
                    .caption1: 14,
                    .body: 15,
                    .headline: 15,
                    .title3: 18,
                    .title2: 26,
                    .title1: 30,
                    .largeTitle: 32]
        case "UICTContentSizeCategoryL":
            return [.footnote: 13,
                    .caption2: 14,
                    .caption1: 15,
                    .body: 16,
                    .headline: 16,
                    .title3: 19,
                    .title2: 27,
                    .title1: 34,
                    .largeTitle: 36]
        case "UICTContentSizeCategoryXL":
            return [.footnote: 14,
                    .caption2: 15,
                    .caption1: 16,
                    .body: 17,
                    .headline: 17,
                    .title3: 20,
                    .title2: 30,
                    .title1: 38,
                    .largeTitle: 40]
        default:
            return [:]
        }
    } else {
        /// No `largeTitle` before watchOS 5
        switch (WKInterfaceDevice.current().preferredContentSizeCategory) {
        case "UICTContentSizeCategoryS":
            return [.footnote: 12,
                    .caption2: 13,
                    .caption1: 14,
                    .body: 15,
                    .headline: 15,
                    .title3: 18,
                    .title2: 26,
                    .title1: 30]
        case "UICTContentSizeCategoryL":
            return [.footnote: 13,
                    .caption2: 14,
                    .caption1: 15,
                    .body: 16,
                    .headline: 16,
                    .title3: 19,
                    .title2: 27,
                    .title1: 34]
        default:
            return [:]
        }
    }
}()
#endif
