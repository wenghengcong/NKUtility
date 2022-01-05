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
        removeAllScript()
        NKUserScriptManager.shared.injectUserScriptsIntoTab(self.webView, nightMode: nightMode, noImageMode: noImageMode)
        addMessageJSScript()
        addScaleTextScript()
    }
    
    func removeAllScript() {
        NKUserScriptManager.shared.removeAllUserScripts(self.webView)
        NKUserScriptMessageManager.shared.uninstall(webView: self.webView)
    }
    
    func addMessageJSScript() {
        motionClickJSMessage()
    }
    
    /// 监听 js 点击事件
    func motionClickJSMessage() {
        let motiorClickMessage = NKJavascriptMessageType.click.rawValue
        let messageJS = """
            window.onload = function() {
                document.addEventListener("click", function(evt) {
                    var tagClicked = document.elementFromPoint(evt.clientX, evt.clientY);
                    window.webkit.messageHandlers.\(motiorClickMessage).postMessage(tagClicked.outerHTML.toString());
                });
            }
            """
        // atDocumentStart: 意思是网页中的元素标签创建刚出来的时候，但是还没有内容。该时机适合通过注入脚本来添加元素标签等操作。（注意：此时<head>和<body>等标签都还没有出现）
        let messageUserScript:WKUserScript = WKUserScript(source: messageJS, injectionTime:.atDocumentStart, forMainFrameOnly: true)
        
        webView?.configuration.userContentController.add(self, name: motiorClickMessage)
        webView?.configuration.userContentController.addUserScript(messageUserScript)
    }
    
    func addScaleTextScript() {
        // atDocumentEnd: 意思是网页中的元素标签已经加载好了内容，但是网页还没有渲染出来。该时机适合通过注入脚本来获取元素标签内容等操作。（如果注入的js代码跟修改元素标签有关的话，这就是合适的时机）
        // 字体自适应
        let scaleTextJS = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='\(textSzieScalePercent)%'"
        let scaleTextScript:WKUserScript =  WKUserScript(source: scaleTextJS, injectionTime:.atDocumentEnd, forMainFrameOnly: true)
        webView?.configuration.userContentController.addUserScript(scaleTextScript)
    }
    
    func addScriptMessageHandle() {
        let readerMode = ReaderMode(web: self)
        readerMode.delegate = self
        self.addContentScript(readerMode, name: ReaderMode.name())
    }
    
    func addContentScript(_ helper: TabContentScript, name: String) {
        scriptMessageManager.addContentScript(helper, name: name, forWebView: self.webView)
    }
    
    func getContentScript(name: String) -> TabContentScript? {
        return scriptMessageManager.getContentScript(name)
    }
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //        NKlogger.debug("detect webview click ")
        delegate?.nkuserContentController?(userContentController, didReceive: message)
    }
}
