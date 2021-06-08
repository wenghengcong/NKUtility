//
//  NKWebViewController+Reader.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/7.
//

import Foundation
import WebKit

//MARK: - reader mode
extension NKWebViewController: ReaderModeDelegate {

    func setupReaderModeCache() {
        if let cache = self.readerModeCache {
            ReaderModeHandlers.readerModeCache = cache
        }
    }
    
    /// 阅读模式是否可用
    var readerModeAvailableOrActive: Bool {
        if let readerMode = self.getContentScript(name: "ReaderMode") as? ReaderMode {
            return readerMode.state != .unavailable
        }
        return false
    }
    
    func execuReaderModeChange() {
        // Store the readability result in the cache and load it. This will later move to the ReadabilityHelper.
        webView.evaluateJavascriptInDefaultContentWorld("window.__firefox__.reader.readerize()") { object, error in
            if let readabilityResult = ReadabilityResult(object: object as AnyObject?) {
                //                    try? self.readerModeCache.put(currentURL, readabilityResult)
                //                    if let nav = webView.load(PrivilegedRequest(url: readerModeURL) as URLRequest) {
                //                    }
            }
        }
    }
    
    /// 文字缩放
    func textSzieScale() {
        if isFirstLoading {
            let scaleTextJS = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='\(textSzieScalePercent)%'"
            webView.evaluateJavaScript(scaleTextJS, completionHandler: {(response, error) in
                if error == nil {
                    
                }
            })
        }
    }
    
    public func readerMode(_ readerMode: ReaderMode, didDisplayReaderizedContentForWebVC web: NKWebViewController) {
        
    }
    
    public func readerMode(_ readerMode: ReaderMode, didParseReadabilityResult readabilityResult: ReadabilityResult, forWebVC web: NKWebViewController) {
        
    }
    
    public func readerMode(_ readerMode: ReaderMode, didChangeReaderModeState state: ReaderModeState, forWebVc web: NKWebViewController) {
        
    }
}
