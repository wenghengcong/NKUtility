//
//  NKWebViewController+WKDelegate.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/7.
//

import Foundation
import WebKit

//MARK: - WKUIDelegate
extension  NKWebViewController: WKUIDelegate {
    
    // Add any desired WKUIDelegate methods here: https://developer.apple.com/reference/webkit/wkuidelegate
    open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url{
            if url.description.lowercased().range(of: "http://") != nil || url.description.lowercased().range(of: "https://") != nil  {
                webView.load(navigationAction.request)
            }
        }
        return nil
    }
    
    
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        if !allowJavaScriptAlerts {
            return
        }
        
        let alertController: UIAlertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction) -> Void in
            completionHandler()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: - WKNavigationDelegate
extension  NKWebViewController: WKNavigationDelegate {
    
    // 1、4 在发送请求之前，决定是否跳转
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return
        }
        
        let hostAddress = navigationAction.request.url?.host
        
        // 1.To connnect app store
        if hostAddress == "itunes.apple.com" {
            if UIApplication.shared.canOpenURL(navigationAction.request.url!) {
                UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
        }
        
        // 2. handle other scheme
        let url_elements = url.absoluteString.components(separatedBy: ":")
        
        switch url_elements[0] {
        case "tel":
            openCustomApp(urlScheme: "telprompt://", additional_info: url_elements[1])
            decisionHandler(.cancel)
            return
        case "sms":
            openCustomApp(urlScheme: "sms://", additional_info: url_elements[1])
            decisionHandler(.cancel)
            return
        case "mailto":
            openCustomApp(urlScheme: "mailto://", additional_info: url_elements[1])
            decisionHandler(.cancel)
            return
        default:
            //NKlogger.debug("Default")
            break
        }
        
        // 3. 处理自定义跳转
        if customDecideNavigation != nil {
            let isReturn = customDecideNavigation!(webView, navigationAction)
            if isReturn {
                decisionHandler(.cancel)
                return
            }
        }
        
        // 4. 支持用 Safari 打开的
        if openWithSafariDomains.isNotEmpty {
            var containOpenWithSafariUrl = false
            if let rootDomain = url.rootDomain {
                for domain in openWithSafariDomains {
                    if domain.contains(rootDomain) {
                        containOpenWithSafariUrl = true
                        break
                    }
                }
            }
            // 使用 Safari 打开网页
            if (containOpenWithSafariUrl) {
                if UIApplication.shared.canOpenURL(url) {
                    //                    NKlogger.debug("Redirected to browser. No need to open it locally: \(url)")
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    decisionHandler(.cancel)
                    return
                }
            }
        }
        
        //        NKlogger.debug("Open it locally: \(url)")
        decisionHandler(.allow)
    }
    
    
    // 2 页面开始加载时调用
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoading(true)
        delegate?.webViewController?(self, didStartLoading: webView.url)
        updateToolbarItems()
    }
    
    
    // 3、5 在收到响应后，决定是否跳转
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            let headers = response.allHeaderFields
            //do something with headers
            //            NKlogger.debug("webvie headers: \(headers)")
        }
        
        DispatchQueue.main.async {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                for cookie in cookies {
                    NKCookieStore.shared.addCookie(cookie)
                }
            }
        }
        delegate?.webViewController?(self, decidePolicyForNavigationResponse: navigationResponse, decisionHandler: decisionHandler)
        decisionHandler(.allow)
    }
    
    // 6 页面加载完成之后调用
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showLoading(false)
        refreshControl.endRefreshing()
        delegate?.webViewController?(self, didFinishLoading: webView.url, success: true)
        
        if userDefinedTitle == nil {
            webView.evaluateJavaScript("document.title", completionHandler: {(response, error) in
                if error == nil {
                    self.navBarTitle.text = response as! String?
                    self.navBarTitle.sizeToFit()
                    self.updateToolbarItems()
                }
            })
            
            webView.evaluateJavaScript("document.getElementById('article-title').textContent") { (response, error) -> Void in
                if error == nil {
                    //                    NKlogger.debug(response)
                    self.navBarTitle.text = response as! String?
                    self.navBarTitle.sizeToFit()
                    self.updateToolbarItems()
                }
            }
        }
    }
    
    /// 当内容开始返回时调用
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    // 页面加载失败时调用
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showLoading(false)
        refreshControl.endRefreshing()
        
        delegate?.webViewController?(self, didFinishLoading: webView.url, success: false)
        updateToolbarItems()
    }
    
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showLoading(false)
        refreshControl.endRefreshing()
        
        delegate?.webViewController?(self, didFinishLoading: webView.url, success: false)
        updateToolbarItems()
    }
    
    open func openCustomApp(urlScheme: String, additional_info:String){
        if let requestUrl: URL = URL(string:"\(urlScheme)"+"\(additional_info)") {
            let application:UIApplication = UIApplication.shared
            if application.canOpenURL(requestUrl) {
                application.open(requestUrl, options: [:], completionHandler: nil)
            }
        }
    }
}
