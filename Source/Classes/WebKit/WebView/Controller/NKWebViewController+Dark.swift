//
//  NKWebViewController+Dark.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/7.
//

import Foundation
import WebKit

extension NKWebViewController {

    func execuNoImageModeChanage() {
        //            contentBlocker?.noImageMode(enabled: noImageMode)
        UserScriptManager.shared.injectUserScriptsIntoTab(self, nightMode: nightMode, noImageMode: noImageMode)
    }
    
    func execuDarkModeChanage() {
        webView.evaluateJavascriptInDefaultContentWorld("window.__firefox__.NightMode.setEnabled(\(nightMode))"){ object, error in
            print("启用暗黑模式")
        }
        // For WKWebView background color to take effect, isOpaque must be false,
        // which is counter-intuitive. Default is true. The color is previously
        // set to black in the WKWebView init.
        webView.isOpaque = !nightMode
        //            UserScriptManager.shared.injectUserScriptsIntoTab(self, nightMode: nightMode, noImageMode: noImageMode)
    }
}
