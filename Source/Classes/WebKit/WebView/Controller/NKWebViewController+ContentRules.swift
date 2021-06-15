//
//  NKWebViewController+ContentRules.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/7.
//

import Foundation
import WebKit

public extension NKWebViewController {
    
    // MARK: - load html or quest
    func loadHtmlString() {
        guard htmlString != nil else {
            return
        }
        self.loadHtmlByContentRules()
    }

    func loadRequest(_ request: URLRequest?) {
        guard request != nil else {
            return
        }
        self.loadRequestByContentRules()
    }
    
    func loadHtmlByContentRules() {
        if self.contentRules != nil, self.contentRules!.isNotEmpty {
            WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "filterContent", encodedContentRuleList: self.contentRules) { (list, error) in
                guard let contentRuleList = list else { return }
                self.webView?.configuration.userContentController.add(contentRuleList)
                self.really_loadHtmlString()
            }
        } else {
            self.really_loadHtmlString()
        }
    }
    
    internal func really_loadHtmlString() {
        if let html = htmlString{
            self.webView?.loadHTMLString(html, baseURL: nil)
        }
    }
    
    func loadRequestByContentRules() {
        if self.contentRules != nil, self.contentRules!.isNotEmpty {
            WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "filterContent", encodedContentRuleList: self.contentRules) { (list, error) in
                guard let contentRuleList = list else { return }
                self.webView?.configuration.userContentController.add(contentRuleList)
                self.really_loadRequest(self.request)
            }
        } else {
            self.really_loadRequest(self.request)
        }
    }
    
    
    internal func really_loadRequest(_ request: URLRequest?) {
        if let url = request!.url,
           url.absoluteString.contains("file:"),
           #available(iOS 9.0, *) {
            self.webView?.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            self.webView?.load(request!)
        }
    }
    
    
    /// 添加屏蔽规则
    /// - Parameters:
    ///   - identifier: <#identifier description#>
    ///   - contentRules: <#contentRules description#>
    public func addContentRules(identifier: String, contentRules: String)  {
        WKContentRuleListStore.default().compileContentRuleList(forIdentifier: identifier, encodedContentRuleList: contentRules) { (list, error) in
            guard let contentRuleList = list else { return }
            self.webView?.configuration.userContentController.add(contentRuleList)
        }
    }
}
