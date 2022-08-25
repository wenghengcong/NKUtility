//
//  CustomFonts.swift
//  DuZi
//
//  Created by Nemo on 2022/8/24.
//

import UIKit

/// 自定义用户字体
/// 注意需要定义 enum 必须包含bold\light\regular
enum XGWWenKaiFont: String, NKFontRepresentable {
    case bold = "LXGWWenKaiMono-Bold"
    case light = "LXGWWenKaiMono-Light"
    case regular = "LXGWWenKaiMono-Regular"
}
