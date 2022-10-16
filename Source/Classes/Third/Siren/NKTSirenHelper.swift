//
//  NKTSirenHelper.swift
//  NKUtility
//
//  Created by Nemo on 2022/9/28.
//

import Foundation
#if canImport(Siren)
import Siren
#endif

public struct NKTSirenHelper {
    
    public static let shared = NKTSirenHelper()
    
    public func setup() {
#if canImport(Siren)
        Siren.shared.wail()
#endif
    }
    
}
