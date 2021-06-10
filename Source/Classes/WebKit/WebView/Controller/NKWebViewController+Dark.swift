//
//  NKWebViewController+Dark.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/7.
//

import Foundation
import WebKit

extension NKWebViewController {
    
    open func execuNoImageModeChanage() {
        //            contentBlocker?.noImageMode(enabled: noImageMode)
        NKUserScriptManager.shared.injectUserScriptsIntoTab(self.webView, nightMode: nightMode, noImageMode: noImageMode)
    }
    
    open func execuDarkModeChanage(completion: ( ()->Void )? = nil) {
        webView?.evaluateJavascriptInDefaultContentWorld("window.__firefox__.NightMode.setEnabled(\(nightMode))"){ object, error in
            //            print("启用暗黑模式")
            if completion != nil {
                completion!()
            }
        }
        webView?.isOpaque = !nightMode
        // For WKWebView background color to take effect, isOpaque must be false,
        // which is counter-intuitive. Default is true. The color is previously
        // set to black in the WKWebView init.
        //            UserScriptManager.shared.injectUserScriptsIntoTab(self, nightMode: nightMode, noImageMode: noImageMode)
    }
}
