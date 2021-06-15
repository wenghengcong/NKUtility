//
//  NKWebViewWarmUp.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/10.
//

import Foundation
import WebKit
import UIKit

public protocol NKWarmUpable {
    func warmUp()
}

public class NKWarmUper<Object: NKWarmUpable> {
    
    private let creationClosure: () -> Object
    private var warmedUpObjects: [Object] = []
    public var numberOfWamedUpObjects: Int = 5 {
        didSet {
            prepare()
        }
    }
    
    public init(creationClosure: @escaping () -> Object) {
        self.creationClosure = creationClosure
        prepare()
    }
    
    public func prepare() {
        while warmedUpObjects.count < numberOfWamedUpObjects {
            let object = creationClosure()
            object.warmUp()
            warmedUpObjects.append(object)
        }
    }
    
    private func createObjectAndWarmUp() -> Object {
        let object = creationClosure()
        object.warmUp()
        return object
    }
    
    public func dequeue() -> Object {
        let warmedUpObject: Object
        if let object = warmedUpObjects.first {
            warmedUpObjects.removeFirst()
            warmedUpObject = object
        } else {
            warmedUpObject = createObjectAndWarmUp()
        }
        prepare()
        return warmedUpObject
    }
    
}

extension WKWebView: NKWarmUpable {
    public func warmUp() {
        loadHTMLString("", baseURL: nil)
    }
}

public typealias NKWKWebViewWarmUper = NKWarmUper<WKWebView>

public extension NKWarmUper where Object == WKWebView {
    static let shared = NKWKWebViewWarmUper(creationClosure: {
        WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    })
}
