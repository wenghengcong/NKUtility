//
//  NKCommonCellProtocol.swift
//  NKUtility
//
//  Created by Hunt on 2021/3/8.
//

import Foundation
import UIKit


public protocol NKCommonCellProtocol: class {
    
    
    
    /// for switch value changed
    /// - Parameters:
    ///   - cell: <#cell description#>
    ///   - value: <#value description#>
    func switchUpdate(in cell:NKSwitchCell,with value: Bool)
}


public extension NKCommonCellProtocol {
    func switchUpdate(in cell:NKSwitchCell,with value: Bool) {
        
    }
}
