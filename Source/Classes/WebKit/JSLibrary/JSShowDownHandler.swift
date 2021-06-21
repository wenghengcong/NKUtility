//
//  JSShowDownHandler.swift
//  NKUtility
//
//  Created by Hunt on 2021/6/19.
//

import Foundation
import JavaScriptCore
import WebKit
import SwiftSoup

extension JSShowDownHandler: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
}

public class JSShowDownHandler: NSObject {
    
    public static let shared = JSShowDownHandler()
    
    let webView = WKWebView(frame: CGRect(), configuration: WKWebViewConfiguration())


    public static var markdownToHTMLNotificationName = NSNotification.Name("markdownToHTMLNotification")
    public static var HTMLToMarkdownNotificationName = NSNotification.Name("HTMLTomarkdownNotification")
    
    var jsContext: JSContext!
    
    var wkWebViewBridge: WKWebViewJavascriptBridge!
    
    override init() {
        super.init()
        initializeBridge()
        initializeJS()
        addObserverNoti()
        
        
        // setup webView
        webView.frame = CGRect.zero
        webView.navigationDelegate = self
        
        let bundle = NKUtilityFramework.resourceBundle
        if let ReadabilityJSPath = bundle.path(forResource: "Readability", ofType: "js"), let source = try? NSString(contentsOfFile: ReadabilityJSPath, encoding: String.Encoding.utf8.rawValue) as String {
            let ReadabilityJSScript = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            webView.configuration.userContentController.addUserScript(ReadabilityJSScript)
        }
        webView.load(URLRequest(url: URL(string: "https://www.raywenderlich.com/1227-javascriptcore-tutorial-for-ios-getting-started")!))
    }
    

    func initializeBridge() {
        let webView = WKWebView()
        wkWebViewBridge = WKWebViewJavascriptBridge(webView: webView)
     
        wkWebViewBridge.register(handlerName: "testiOSCallback") { (paramters, callback) in
            print("testiOSCallback called: \(String(describing: paramters))")
            callback?("Response from testiOSCallback")
        }

        wkWebViewBridge.call(handlerName: "testJavascriptHandler", data: ["foo": "before ready"], callback: nil)
    }
    
    func initializeJS() {
        self.jsContext = JSContext()
        
        // Add an exception handler.
        self.jsContext.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception:", exc.toString())
            }
        }
        
        let bundle = NKUtilityFramework.resourceBundle
        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        self.jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
        _ = self.jsContext.evaluateScript("consoleLog")
        if let jsSourcePath = bundle.path(forResource: "showdownFunction", ofType: "js") {
            do {
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                self.jsContext.evaluateScript(jsSourceContents)
                
                // Fetch and evaluate the Snowdown script.
//                let snowdownScript = try String(contentsOf: URL(string: "https://cdn.jsdelivr.net/npm/showdown@1.9.1/dist/showdown.min.js")!)
//                self.jsContext.evaluateScript(snowdownScript)
                
                if let sourcePath = bundle.path(forResource: "showdown.min", ofType: "js") {
                    let sourceContent = try String(contentsOfFile: sourcePath)
                    self.jsContext.evaluateScript(sourceContent)
                }
                
                if let sourcePath = bundle.path(forResource: "Readability", ofType: "js") {
                    let sourceContent = try String(contentsOfFile: sourcePath)
                    self.jsContext.evaluateScript(sourceContent)
                }
                
                if let sourcePath = bundle.path(forResource: "JSDOMParser", ofType: "js") {
                    let sourceContent = try String(contentsOfFile: sourcePath)
                    self.jsContext.evaluateScript(sourceContent)
                }
                
                if let sourcePath = bundle.path(forResource: "jquery3.6.0", ofType: "js") {
                    let sourceContent = try String(contentsOfFile: sourcePath)
                    self.jsContext.evaluateScript(sourceContent)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        // 将self.markdownToHTMLHandler 方法以 "handleConvertedMarkdown" 的名注册到 JS 环境中
        let htmlResultsHandler = unsafeBitCast(self.markdownToHTMLHandler, to: AnyObject.self)
        self.jsContext.setObject(htmlResultsHandler, forKeyedSubscript: "handleConvertedMarkdown" as (NSCopying & NSObjectProtocol))
//        _ = self.jsContext.evaluateScript("handleConvertedMarkdown")
        
        let markdownResultsHandler = unsafeBitCast(self.HTMLToMarkdownHandler, to: AnyObject.self)
        self.jsContext.setObject(markdownResultsHandler, forKeyedSubscript: "handleConvertedHtml" as (NSCopying & NSObjectProtocol))
//        _ = self.jsContext.evaluateScript("handleConvertedHtml")
    }
    
    func addObserverNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleMarkdownToHTMLNotification(notification:)), name: JSShowDownHandler.markdownToHTMLNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHTMLToMarkdownNotification(notification:)), name: JSShowDownHandler.HTMLToMarkdownNotificationName, object: nil)
    }
    
    // MARK: - Markdown To html
    public func convertMarkdownToHTML(_ markdownString: String) {
        if let functionConvertMarkdownToHTML = self.jsContext.objectForKeyedSubscript("convertMarkdownToHTML") {
            _ = functionConvertMarkdownToHTML.call(withArguments: [markdownString])
        }
    }
    
    
    @objc func handleMarkdownToHTMLNotification(notification: Notification) {
        if let html = notification.object as? String {
            let newContent = "<html><head><style>body { background-color: #3498db; color: #ffffff; } </style></head><body>\(html)</body></html>"
            
        }
    }
    
    let markdownToHTMLHandler: @convention(block) (String) -> Void = { htmlOutput in
        NotificationCenter.default.post(name: JSShowDownHandler.markdownToHTMLNotificationName, object: htmlOutput)
    }
    
    
    // MARK: - Html To Markdown
    public func convertHTMLToMarkdown(_ htmlString: String) {
        
        let myURLString = "https://www.raywenderlich.com/1227-javascriptcore-tutorial-for-ios-getting-started"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        do {
            var myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            let doc = try? SwiftSoup.parse(myHTMLString)
            print("HTML : \(myHTMLString)")
            if let html = try doc?.html(), let functionConvertHTMLToMarkdown = self.jsContext.objectForKeyedSubscript("convertHTMLToMarkdown") {
                var cleanHtml = myHTMLString.trim().lowercased().replacing("<!doctype html>", with: "")
                print("HTML : \(cleanHtml)")
                _ = functionConvertHTMLToMarkdown.call(withArguments: [cleanHtml])
            }
        } catch let error {
            print("Error: \(error)")
        }
        
    }
    
    
    @objc func handleHTMLToMarkdownNotification(notification: Notification) {
        if let markdown = notification.object as? String {
            
        }
    }
    
    /// js 环境中调用方法后，会回调到这里
    /// 在该回调里，将转换结果以通知的方式进行转发
    let HTMLToMarkdownHandler: @convention(block) (String) -> Void = { htmlOutput in
        NotificationCenter.default.post(name: JSShowDownHandler.HTMLToMarkdownNotificationName, object: htmlOutput)
    }
    
    
    // MARK: - Console Blocks
    
    let consoleLog: @convention(block) (String) -> Void = { logMessage in
        print("\nJS Console:", logMessage)
    }
}
