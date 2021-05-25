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

public class NKCommonSectionData {
    
    public var tag: Int?
    public var header: String?
    public var footer: String?
    public var cells: [NKCommonCellData] = []
    public var count: Int {
        return cells.count
    }
    
    public init() {
        
    }
    
    public init(header: String?, footer: String?) {
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
