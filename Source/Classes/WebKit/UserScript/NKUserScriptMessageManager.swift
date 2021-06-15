//
//  NKUserScriptMessageManager.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/10.
//

import Foundation
import WebKit

public class NKUserScriptMessageManager: NSObject, WKScriptMessageHandler  {
    public static let shared = NKUserScriptMessageManager()
    
    public var helpers = [String: TabContentScript]()

    // Without calling this, the TabscriptMessageManager will leak.
    public func uninstall(webView: WKWebView?) {
        if #available(iOS 14.0, *) {
            webView?.configuration.userContentController.removeAllScriptMessageHandlers()
        } else {
            // Fallback on earlier versions
            helpers.forEach { helper in
                if let name = helper.value.scriptMessageHandlerName() {
                    webView?.configuration.userContentController.removeScriptMessageHandler(forName: name)
                }
            }
        }
    }

    @objc public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        for helper in helpers.values {
            if let scriptMessageHandlerName = helper.scriptMessageHandlerName(), scriptMessageHandlerName == message.name {
                helper.userContentController(userContentController, didReceiveScriptMessage: message)
                return
            }
        }
    }

    public func addContentScript(_ helper: TabContentScript, name: String, forWebView webView: WKWebView?) {
        if let _ = helpers[name] {
            assertionFailure("Duplicate helper added: \(name)")
        }

        helpers[name] = helper

        // If this helper handles script messages, then get the handler name and register it. The Browser
        // receives all messages and then dispatches them to the right TabHelper.
        if let scriptMessageHandlerName = helper.scriptMessageHandlerName() {
            webView?.configuration.userContentController.addInDefaultContentWorld(scriptMessageHandler: self, name: scriptMessageHandlerName)
        }
    }

    public func getContentScript(_ name: String) -> TabContentScript? {
        return helpers[name]
    }
}
