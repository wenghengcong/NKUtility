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
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {
                  // All done!
                })
              }
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                NKlogger.debug("error")
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

        public static func github(html inHtml: String, cssTemplateFile: String) -> (outHtml: String, baseURL: URL?)?{
            let cssren = NKNetworkUtil.CSS.renderTemplate(html: inHtml, with: cssTemplateFile)
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
                    NKlogger.debug("Unable to get the file.")
                }
            }
            
            return html
        }
        
        public static func templateHtmlPathURL(_ path: String) -> URL? {
            let bundle: Bundle = Bundle.nikiFrameworkBundle()
            var htmlPathURL = bundle.url(forResource: path, withExtension: "html")
            if htmlPathURL == nil {
                htmlPathURL = Bundle.main.url(forResource: path, withExtension: "html")
            }
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
            
            let js = """
                var removeEles = \(elements);
                for (let i = 0; i < removeEles.length; i++) {
                    let rid = removeEles[i];
                    var element = document.getElementById(rid);
                    if(element !== null && element !== undefined) {
                        element.parentElement.removeChild(element);
                    }
                    var elements = document.getElementsByClassName(rid);
                    if(elements !== null && elements !== undefined) {
                        for (let j = 0; j < elements.length; j++) {
                            elements[j].style.display=\"none\";
                        }
                    }
                }
            """
            webView.evaluateJavaScript(js) { (result, error) in
                completionHandler?(result, error)
            }
        }
    }
}
