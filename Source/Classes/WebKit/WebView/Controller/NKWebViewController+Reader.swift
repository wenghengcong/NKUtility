//
//  NKWebViewController+Reader.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/6/7.
//

import Foundation
import WebKit

//MARK: - reader mode
extension NKWebViewController {

    
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
    
}
