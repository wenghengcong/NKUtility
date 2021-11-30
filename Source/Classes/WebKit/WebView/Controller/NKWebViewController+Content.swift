//
//  NKWebViewController+ContentRules.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/7.
//

import Foundation
import WebKit

public extension NKWebViewController {
    
    func loadWebContent() {
        if NKNetworkUtil.shared.isReachable {
            // 网络正常
            if htmlString != nil && htmlString!.isNotEmpty {
                loadContentType = .loadHTML
            } else if request != nil {
                loadContentType = .loadRequest
            } else {
                loadContentType = .loadEmpty
            }
            // cache
            archiveWebContent()
        } else {
            if cacheEnable {
                loadContentType = .loadCache
            } else {
                loadContentType = .loadError
            }
        }
        
        switch loadContentType {
        case .none:
            break
        case .loadHTML:
            loadHtmlWithContentRules()
            break
        case .loadRequest:
            loadRequestWithContentRules()
            break
        case .loadCache:
            loadArchiveCache()
            break
        case .loadEmpty:
            loadEmptyContentView()
            break
        case .loadError:
            loadErrorContentView()
            break
        }
    }
    
    // MARK: - load webview content
    func loadHtmlWithContentRules() {
        guard htmlString != nil else {
            return
        }
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
    
    func loadRequestWithContentRules() {
        guard request != nil else {
            return
        }
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
    
    func loadArchiveCache() {
        if unArchiveWebContent() {
            
        } else {
            loadErrorContentView()
        }
    }
    
    func loadEmptyContentView() {
        
    }
    
    func loadErrorContentView() {
        
    }
    
    // MARK: - really do load action
    internal func really_loadHtmlString() {
        if let html = htmlString {
            self.webView?.loadHTMLString(html, baseURL: nil)
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
