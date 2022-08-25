//
//  NKFontManager.swift
//  DuZi
//
//  Created by Nemo on 2022/8/24.
//

import Foundation
import UIKit

// MARK: - 全局共用字体方法
public func NKRegularFont(ofSize: CGFloat, scale: Bool = true) -> UIFont {
    return NKFontManager.shared.regular(of: ofSize, scale: scale)
}

public func NKLightFont(ofSize: CGFloat, scale: Bool = true) -> UIFont {
    return NKFontManager.shared.light(of: ofSize, scale: scale)
}

public func NKBoldFont(ofSize: CGFloat, scale: Bool = true) -> UIFont {
    return NKFontManager.shared.bold(of: ofSize, scale: scale)
}

// MARK: - SystemFont
public let NKSysFont5 = NKRegularFont(ofSize: NKDesignByW375(5.0))
public let NKSysFont6 = NKRegularFont(ofSize: NKDesignByW375(6.0))
public let NKSysFont7 = NKRegularFont(ofSize: NKDesignByW375(7.0))
public let NKSysFont8 = NKRegularFont(ofSize: NKDesignByW375(8.0))
public let NKSysFont9 = NKRegularFont(ofSize: NKDesignByW375(9.0))
public let NKSysFont10 = NKRegularFont(ofSize: NKDesignByW375(10.0))
public let NKSysFont11 = NKRegularFont(ofSize: NKDesignByW375(11.0))
public let NKSysFont12 = NKRegularFont(ofSize: NKDesignByW375(12.0))
public let NKSysFont13 = NKRegularFont(ofSize: NKDesignByW375(13.0))
public let NKSysFont14 = NKRegularFont(ofSize: NKDesignByW375(14.0))
public let NKSysFont15 = NKRegularFont(ofSize: NKDesignByW375(15.0))
public let NKSysFont16 = NKRegularFont(ofSize: NKDesignByW375(16.0))
public let NKSysFont17 = NKRegularFont(ofSize: NKDesignByW375(17.0))
public let NKSysFont18 = NKRegularFont(ofSize: NKDesignByW375(18.0))
public let NKSysFont19 = NKRegularFont(ofSize: NKDesignByW375(19.0))
public let NKSysFont20 = NKRegularFont(ofSize: NKDesignByW375(20.0))
public let NKSysFont21 = NKRegularFont(ofSize: NKDesignByW375(21.0))
public let NKSysFont22 = NKRegularFont(ofSize: NKDesignByW375(22.0))
public let NKSysFont23 = NKRegularFont(ofSize: NKDesignByW375(23.0))
public let NKSysFont24 = NKRegularFont(ofSize: NKDesignByW375(24.0))
public let NKSysFont25 = NKRegularFont(ofSize: NKDesignByW375(25.0))
public let NKSysFont26 = NKRegularFont(ofSize: NKDesignByW375(26.0))
public let NKSysFont27 = NKRegularFont(ofSize: NKDesignByW375(27.0))
public let NKSysFont28 = NKRegularFont(ofSize: NKDesignByW375(28.0))
public let NKSysFont29 = NKRegularFont(ofSize: NKDesignByW375(29.0))
public let NKSysFont30 = NKRegularFont(ofSize: NKDesignByW375(30.0))
public let NKSysFont31 = NKRegularFont(ofSize: NKDesignByW375(31.0))
public let NKSysFont32 = NKRegularFont(ofSize: NKDesignByW375(32.0))

public let NKBoldSysFont8 = NKBoldFont(ofSize: NKDesignByW375(8.0))
public let NKBoldSysFont9 = NKBoldFont(ofSize: NKDesignByW375(9.0))
public let NKBoldSysFont10 = NKBoldFont(ofSize: NKDesignByW375(10.0))
public let NKBoldSysFont11 = NKBoldFont(ofSize: NKDesignByW375(11.0))
public let NKBoldSysFont12 = NKBoldFont(ofSize: NKDesignByW375(12.0))
public let NKBoldSysFont13 = NKBoldFont(ofSize: NKDesignByW375(13.0))
public let NKBoldSysFont14 = NKBoldFont(ofSize: NKDesignByW375(14.0))
public let NKBoldSysFont15 = NKBoldFont(ofSize: NKDesignByW375(15.0))
public let NKBoldSysFont16 = NKBoldFont(ofSize: NKDesignByW375(16.0))
public let NKBoldSysFont17 = NKBoldFont(ofSize: NKDesignByW375(17.0))
public let NKBoldSysFont18 = NKBoldFont(ofSize: NKDesignByW375(18.0))
public let NKBoldSysFont19 = NKBoldFont(ofSize: NKDesignByW375(19.0))
public let NKBoldSysFont20 = NKBoldFont(ofSize: NKDesignByW375(20.0))
public let NKBoldSysFont21 = NKBoldFont(ofSize: NKDesignByW375(21.0))
public let NKBoldSysFont22 = NKBoldFont(ofSize: NKDesignByW375(22.0))
public let NKBoldSysFont23 = NKBoldFont(ofSize: NKDesignByW375(23.0))
public let NKBoldSysFont24 = NKBoldFont(ofSize: NKDesignByW375(24.0))
public let NKBoldSysFont25 = NKBoldFont(ofSize: NKDesignByW375(25.0))
public let NKBoldSysFont26 = NKBoldFont(ofSize: NKDesignByW375(26.0))
public let NKBoldSysFont27 = NKBoldFont(ofSize: NKDesignByW375(27.0))
public let NKBoldSysFont28 = NKBoldFont(ofSize: NKDesignByW375(28.0))
public let NKBoldSysFont29 = NKBoldFont(ofSize: NKDesignByW375(29.0))
public let NKBoldSysFont30 = NKBoldFont(ofSize: NKDesignByW375(30.0))
public let NKBoldSysFont31 = NKBoldFont(ofSize: NKDesignByW375(31.0))
public let NKBoldSysFont32 = NKBoldFont(ofSize: NKDesignByW375(32.0))


// MARK: - 字体系列

enum FontSerise {
    case system
    case wenkai
}

/// 全局字体管理
struct NKFontManager {
    static let shared = NKFontManager()
    
    /// 当前字体系列
    var current: FontSerise = .wenkai
    
    /// 更改字体系列
    mutating func change(_ serise: FontSerise) {
        current = serise
    }
    
    
    /// light字体
    func light(of size: CGFloat, scale: Bool = true) -> UIFont {
        let scaleSize = scale ? NKDesignByW375(size) : size
        var font = NKSystemFont.light.ofSize(scaleSize)
        switch current {
        case .wenkai:
            font = XGWWenKaiFont.light.ofSize(scaleSize)
        case .system:
            font = NKSystemFont.light.ofSize(scaleSize)
        }
        return font
    }
    
    ///  regular 字体
    func regular(of size: CGFloat, scale: Bool = true) -> UIFont {
        let scaleSize = scale ? NKDesignByW375(size) : size
        var font = NKSystemFont.regular.ofSize(scaleSize)
        switch current {
        case .wenkai:
            font = XGWWenKaiFont.regular.ofSize(scaleSize)
        case .system:
            font = NKSystemFont.regular.ofSize(scaleSize)
        }
        return font
    }
    
    /// bold 字体
    func bold(of size: CGFloat, scale: Bool = true) -> UIFont {
        let scaleSize = scale ? NKDesignByW375(size) : size
        var font = NKSystemFont.bold.ofSize(scaleSize)
        switch current {
        case .wenkai:
            font = XGWWenKaiFont.bold.ofSize(scaleSize)
        case .system:
            font = NKSystemFont.bold.ofSize(scaleSize)
        }
        return font
    }
}

