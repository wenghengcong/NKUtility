//
//  NKCommonCellData.swift
//  NKUtility
//
//  Created by Hunt on 2021/3/8.
//

import Foundation
import UIKit


///  底部横线的样式
public enum NKCommonCellSeperator {
    case none
    case inset  // 有一定间距
    case full
}

public enum NKCommonCellCellType {
    case `switch`
    case checkmark
    case label
}

public class NKStaticHeaderFooterData {
    open var title: String?
    open var desc: String?
    open var icon: String?
    
    public convenience init(title: String?) {
        self.init()
        self.title = title
    }
    
    public func height() -> CGFloat {
        var height: CGFloat = NKStaticHeaderFooterView.headerHeight
        var hasDesc = false
        if let des = desc, des.isNotEmpty{
            hasDesc = true
        }
        
        if title != nil && desc != nil, let de = desc {
            let left = NKDesignByW375(12.0)
            let width = NKSCREEN_WIDTH-2*left
            let descHeight = de.height(with: width, font: NKSysFont13) + 7
            height = height + descHeight
        }
        else  if let t =  title, t.isNotEmpty, !hasDesc {
            // 只有 title
        }
        return height
    }
}

public class NKCommonSectionData {
    
    public var tag: Int?
    public var header: NKStaticHeaderFooterData?
    public var footer: NKStaticHeaderFooterData?
    public var cells: [NKCommonCellData] = []
    public var count: Int {
        return cells.count
    }
    
    public init() {
        
    }
    
    public init(header: String?, footer: String?) {
        if let tit = header, tit.isNotEmpty {
            self.header = NKStaticHeaderFooterData(title: header)
        }
        if let tit = footer, tit.isNotEmpty {
            self.footer = NKStaticHeaderFooterData(title: footer)
        }
    }
    
    public init(header: NKStaticHeaderFooterData?,
                footer: NKStaticHeaderFooterData?) {
        self.header = header
        self.footer = footer
    }
}

public class NKCommonCellData {
    public var type: NKCommonCellCellType = .label
    public var identifier: String = "nk_default_cell_identifier"

    public var icon: String?
    public var title: String
    public var indexPath: IndexPath?
    public var desc: String?
    
    /// 对应 url
    public var url: String?
    
    // switch 是否开关
    // label 无意义
    // check 是否选中
    public var on: Bool? = false
    
    
    /// 是否有 > 详情箭头
    public var hasDetail: Bool = false
    
    public init() {
        self.icon = ""
        self.title = ""
    }
    
    public init(type: NKCommonCellCellType,
                icon: String? = nil,
                title: String,
                desc: String? = nil,
                on: Bool? = false,
                hasDetail: Bool = false) {
        self.type = type
        self.icon = icon
        self.title = title
        self.desc = desc
        self.on = on
        self.hasDetail = hasDetail
    }
}
