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
        UserScriptManager.shared.injectUserScriptsIntoTab(self, nightMode: nightMode, noImageMode: noImageMode)
        
        // atDocumentEnd: 意思是网页中的元素标签已经加载好了内容，但是网页还没有渲染出来。该时机适合通过注入脚本来获取元素标签内容等操作。（如果注入的js代码跟修改元素标签有关的话，这就是合适的时机）
        // 字体自适应
        let scaleTextJS = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='\(textSzieScalePercent)%'"
        let scaleTextScript:WKUserScript =  WKUserScript(source: scaleTextJS, injectionTime:.atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(scaleTextScript)
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
