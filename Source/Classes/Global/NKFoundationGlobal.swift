//
//  NKFoundationGlobal.swift
//  FireFly
//
//  Created by Hunt on 2020/11/24.
//

import UIKit

func iOSVersionIsEqual(to version: String) -> Bool {
    return NKDevice.SysVersion.isEqual(to: version)
}

func iOSVersionIsEqualOrLater(to version: String) -> Bool {
    return NKDevice.SysVersion.isEqualOrLater(to: version)
}

func iOSVersionIsLater(to version: String) -> Bool {
    return NKDevice.SysVersion.isEqual(to: version)
}

func iOSVersionIsEarlier(to version: String) -> Bool {
    return NKDevice.SysVersion.isEarlier(to: version)
}

func iOSVersionIsEqualOrEarlier(to version: String) -> Bool {
    return NKDevice.SysVersion.isEqualOrEarlier(to: version)
}


