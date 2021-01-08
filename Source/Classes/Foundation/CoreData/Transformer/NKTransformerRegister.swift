//
//  NKCDTransformerRegister.swift
//  FireFly
//
//  Created by Hunt on 2020/11/5.
//

import Foundation


public struct NKValueTransformer {
    public static func registe() {
        DispatchQueue.once(token: "com.vectorform.test") {
            let transformer = NKImageTransformer()
            ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "NKImageTransformer"))
            
            let colortransformer = NKColorTransformer()
            ValueTransformer.setValueTransformer(colortransformer, forName: NSValueTransformerName(rawValue: "NKColorTransformer"))
        }
    }
}
