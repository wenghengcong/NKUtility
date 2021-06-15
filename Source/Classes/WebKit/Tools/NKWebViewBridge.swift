//
//  NKWebViewBridge.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/10.
//

import Foundation
import WebKit

public class NKWebViewBridge {
    public static let shared = NKWebViewBridge()
    
    var warmUp: NKWKWebViewWarmUper?
    
    public func prepare() {
        NKWKWebViewWarmUper.shared.prepare()
    }
    
    public func webView() -> WKWebView {
        let wkwebview =  NKWKWebViewWarmUper.shared.dequeue()
        NKUserScriptManager.shared.removeAllUserScripts(wkwebview)
        NKUserScriptMessageManager.shared.uninstall(webView: wkwebview)
        return wkwebview
    }
}
