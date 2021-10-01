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
    
    /*
    问题说明：在使用WKWebview时遇到一个问题，在h5页面A中存储的数据，在h5页面B中拿不到这个存储的数据。

    原因：WKWebView Cookie 问题在于 WKWebView 发起的请求不会自动带上存储于 NSHTTPCookieStorage 容器中的 Cookie。

    解决方案：
     通过让所有WKWebView 共享同一个 WKProcessPool 实例，可以实现多个 WKWebView 之间共享 Cookie（session Cookie and persistent Cookie）数据
     */
    //定义一个processPool单例
    public static let sharedProcessPool: WKProcessPool = {
        let instance = WKProcessPool()
        return instance
    }()
    
    public static let sharedPreference: WKPreferences = {
        let pref = WKPreferences()
        pref.javaScriptCanOpenWindowsAutomatically = true
        pref.javaScriptEnabled = true
        return pref
    }()
}



public typealias NKWKWebViewWarmUper = NKWarmUper<WKWebView>

public extension NKWarmUper where Object == WKWebView {
    static let shared = NKWKWebViewWarmUper(creationClosure: {
        let config = WKWebViewConfiguration()
        config.processPool = WKWebView.sharedProcessPool
        config.preferences = WKWebView.sharedPreference
        config.allowsAirPlayForMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = .all
        
        let webview = WKWebView(frame: .zero, configuration: config)
        return webview
    })
}
