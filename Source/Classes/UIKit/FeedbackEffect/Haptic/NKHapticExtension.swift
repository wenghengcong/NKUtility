//
//  NKHapticExtension.swift
//  NKUtility
//
//  Created by Hunt on 2021/9/19.
//

import Foundation
import UIKit

extension UIControl.Event: Hashable {
    public var hashValue: Int {
        return Int(rawValue)
    }
}

func == (lhs: UIControl.Event, rhs: UIControl.Event) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

extension OperationQueue {
    static var serial: OperationQueue {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }
}
