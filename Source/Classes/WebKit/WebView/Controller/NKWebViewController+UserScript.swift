//
//  NKWebViewController+UserScript.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/7.
//

import Foundation
import WebKit

extension NKWebViewController: WKScriptMessageHandler {
    
    func addUserScript() {
        UserScriptManager.shared
        let readerMode = ReaderMode(web: self)
        readerMode.delegate = self
        self.addContentScript(readerMode, name: ReaderMode.name())
        UserScriptManager.shared.injectUserScriptsIntoTab(self, nightMode: nightMode, noImageMode: noImageMode)
    }
    
    func addContentScript(_ helper: TabContentScript, name: String) {
        contentScriptManager.addContentScript(helper, name: name, forWebVc: self)
    }
    
    func getContentScript(name: String) -> TabContentScript? {
        return contentScriptManager.getContentScript(name)
    }
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //        NKlogger.debug("detect webview click ")
        delegate?.userContentController?(userContentController, didReceive: message)
    }
    
}
