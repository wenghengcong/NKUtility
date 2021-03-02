//
//  NKNetworkUtil.swift
//  FireFly
//
//  Created by Hunt on 2020/11/22.
//

import Foundation
import WebKit

public extension NKNetworkUtil {
    // MARK: - 清除工具
    /// 清除Cookies
    class func clearCookies() {
        NKCookieStore.shared.deleteCookies()
    }
    
    /// 清除缓存
    class func clearCache() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeOfflineWebApplicationCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeSessionStorage, WKWebsiteDataTypeLocalStorage])
            let date = NSDate(timeIntervalSince1970: 0)
            
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler: { })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }

}

//MARK: - css 渲染

public extension NKNetworkUtil {
    
    public struct CSSRender {
        public static func github(html inHtml: String) -> (outHtml: String, baseURL: URL?)?{
            let cssren = NKNetworkUtil.CSS.renderTemplate(html: inHtml, with: "github-markdownRender")
            return cssren
        }
    }
    
    public struct CSS {
        public static func renderTemplate(html inHtml: String,
                                          with templatePath: String)
        -> (outHtml: String, baseURL: URL?)? {
            guard let path = templateHtmlPathURL(templatePath) else {
                return nil
            }
            let template = templateHtml(templatePath)
            var resultHtml = ""
            if !template.isEmpty {
                resultHtml = template.replacing("{{body}}", with: inHtml)
            }
            let delePath = path.deletingLastPathComponent()
            return (resultHtml, delePath)
        }
        
        public static func templateHtml(_ path: String)  -> String {
            var html = ""
            if let htmlPathURL = templateHtmlPathURL(path) {
                do {
                    html = try String(contentsOf: htmlPathURL, encoding: .utf8)
                } catch  {
                    print("Unable to get the file.")
                }
            }
            
            return html
        }
        
        public static func templateHtmlPathURL(_ path: String) -> URL? {
            let bundle: Bundle = Bundle.nikiFrameworkBundle()
            let htmlPathURL = bundle.url(forResource: path, withExtension: "html")
            return htmlPathURL
        }
    }
}

// MARK: - JS 操作
public extension NKNetworkUtil {
    public struct JS {
        public static func removeElements(elements: [String],
                                          from webView: WKWebView,
                                          completionHandler: ((Any?, Error?) -> Void)? = nil) {
            guard !elements.isEmpty else {
                return
            }
            
            elements.forEach {
                removeElement(id: $0, from: webView, completionHandler: completionHandler)
            }
        }
        
        public static func removeElement(id: String,
                                         from webView: WKWebView,
                                         completionHandler: ((Any?, Error?) -> Void)? = nil) {
            let removeElementIdScript = "var element = document.getElementById('\(id)'); element.parentElement.removeChild(element);"
            webView.evaluateJavaScript(removeElementIdScript) { (result, error) in
                let removeElementClassScript = "document.getElementsByClassName('\(id)')[0].style.display=\"none\";"
                webView.evaluateJavaScript(removeElementClassScript) { (result, error) in
                    completionHandler?(result, error)
                }
            }
        }
    }
}
