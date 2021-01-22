//
//  NKWebViewConstants.swift
//  Alamofire
//
//  Created by Hunt on 2021/1/20.
//

import UIKit
import Foundation

fileprivate extension String {
    var localizedInWebView: String {
        let outString = localizedInside(using: "NKWebViewLocaliziable")
        return outString
    }
}

struct NKWebViewConstants {
    static let l10nStringFile = "NKWebViewLocaliziable"

    static let OpenInSafari = "Open in Safari".localizedInWebView
    static let OpenInChrome = "Open in Chrome".localizedInWebView
    static let CopyLink = "Copy Link".localizedInWebView
    static let Cancel = "Cancel".localizedInWebView
    static let MailLinkToThisPage = "Mail Link to this Page".localizedInWebView

}
        
