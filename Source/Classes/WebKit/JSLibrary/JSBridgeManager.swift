//
//  JSBridgeManager.swift
//  NKUtility
//
//  Created by Hunt on 2021/6/26.
//

import Foundation
import WebKit
import SwiftSoup

extension JSBridgeManager: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webViewDidStartLoad")
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webViewDidFinishLoad")
        
        webView.evaluateJavaScript("document.body.innerHTML") { (html, error) in
        }
        
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html: Any?, error: Error?) in
            let document = html
            print(html)
            do {
                let doc = try? SwiftSoup.parse(html as! String)
                guard let body = try? doc?.body() else { return }
                self.bridge.call(handlerName: "convertHTMLToMarkdown", data: document) { (response) in
                    print("MercuryParser responded: \(String(describing: response))")
                }
            } catch let error {
                print("Error: \(error)")
            }
        })
    }
}


public class JSBridgeManager: NSObject {
    
    public static let shared = JSBridgeManager()
    
    let displayWebView = WKWebView(frame: CGRect(), configuration: WKWebViewConfiguration())
    let jsWebView = WKWebView(frame: CGRect(), configuration: WKWebViewConfiguration())

    var bridge: WKWebViewJavascriptBridge!

    override init() {
        super.init()
        setupWebviews()
        loadDefaultPage()
    }
    
    func setupWebviews() {
        // setup webView
        displayWebView.frame = CGRect.zero
        displayWebView.navigationDelegate = self

        // setup bridge
        bridge = WKWebViewJavascriptBridge(webView: jsWebView)
        bridge.isLogEnable = true
    }
    
    func loadDefaultPage() {
        let bundle = NKUtilityFramework.resourceBundle

        if let pagePath = bundle.path(forResource: "jswebBridgeIndex", ofType: "html"){
            do {
                let pageHtml = try String(contentsOfFile: pagePath, encoding: .utf8)
                let baseURL = URL(fileURLWithPath: pagePath)
                jsWebView.loadHTMLString(pageHtml, baseURL: baseURL)
            } catch {
                print(error.localizedDescription)
            }
            
    
        }
    }
    
    
    public func markdown(html: String, userInfo: Dictionary<String, Any>, completion: ((_ markdown: String, _ userInfo: Dictionary<String, Any>)->Void)? ) {
        let doc = try? SwiftSoup.parse(html as! String)
        guard let body = try? doc?.body()?.html() else { return }
        self.bridge.call(handlerName: "convertHTMLToMarkdown", data: body) { (response) in
            print("convertHTMLToMarkdown responded: \(String(describing: response))")
            if completion != nil, let result = response as? String {
                completion!(result, userInfo)
            }
        }
    }
    
    @objc public func fetch(url: String) {
        displayWebView.load(URLRequest(url: URL(string: url)!))
    }
}
