//
//  NKTSwiftRaterHelper.swift
//  NKUtility
//
//  Created by Nemo on 2022/9/28.
//

import Foundation
import UIKit

#if canImport(SwiftRater)
import SwiftRater
#endif

public struct NKTSwiftRaterHelper {
    public static let shared = NKTSwiftRaterHelper()

    public func launched() {
#if canImport(SwiftRater)
        SwiftRater.appID = GlobalApp.APPID
        SwiftRater.daysUntilPrompt = 7
        SwiftRater.usesUntilPrompt = 10
        SwiftRater.significantUsesUntilPrompt = 3
        SwiftRater.daysBeforeReminding = 1
        SwiftRater.showLaterButton = true

        // 审核注意关闭调试开关
//        SwiftRater.debugMode = true
        SwiftRater.appLaunched()
#endif
    }

    public func check() {
#if canImport(SwiftRater)
        SwiftRater.check()
#endif
    }
}
