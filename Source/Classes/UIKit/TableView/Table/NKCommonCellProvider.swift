//
//  NKCommonCellProvider.swift
//  NKUtility
//
//  Created by Hunt on 2021/3/8.
//

import Foundation
import UIKit

public struct NKCommonCellProvider {
    public static var shared = NKCommonCellProvider()
    
    public func register(tableView: UITableView) {
        tableView.register(cellType: NKLabelCell.self)
        tableView.register(cellType: NKSwitchCell.self)
        tableView.register(cellType: NKCheckmarkCell.self)
    }
    
   public func cell<T: NKUITableViewCell>(data: NKCommonCellData,
                                    tableView: UITableView,
                                    indexPath: IndexPath) -> T {
        let type = data.type
        switch type {
        case .checkmark:
            var cell:NKCheckmarkCell = tableView.dequeueReusableCell(for: indexPath)
            cell.data = data
            return cell as! T
        case .switch:
            var cell:NKSwitchCell = tableView.dequeueReusableCell(for: indexPath)
            cell.data = data
            return cell as! T
        case .label:
            var cell:NKLabelCell = tableView.dequeueReusableCell(for: indexPath)
            cell.data = data
            return cell as! T
        default:
            var defaultCell = NKUITableViewCell() as! T
            return defaultCell
        }
    }
}
