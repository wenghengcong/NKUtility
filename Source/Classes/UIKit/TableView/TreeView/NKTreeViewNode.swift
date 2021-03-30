//
//  NKTreeViewNode.swift
//  Alamofire
//
//  Created by Hunt on 2021/3/30.
//

import Foundation


public final class NKTreeViewNode: NSObject {
    public var parentNode:NKTreeViewNode?
    public var expand:Bool = true
    public var level:Int = 0
    public var item:AnyObject
    
    init(item:AnyObject) {
        self.item = item
    }
}
