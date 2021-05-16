//
//  XCGLogger.swift
//  Lark
//
//  Created by Hunt on 2021/5/15.
//

import Foundation
import XCGLogger

// see https://github.com/DaveWoodCom/XCGLogger
public let NKlogger: XCGLogger = {
    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: true)
    // Customize as needed
//    log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .debug)
    return log
}()

