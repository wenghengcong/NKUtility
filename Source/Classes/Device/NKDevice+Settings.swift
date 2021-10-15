//
//  NKDevice+Settings.swift
//  Alamofire
//
//  Created by wenghengcong on 2021/10/15.
//

import Foundation
import UIKit

public extension NKDevice {
    public struct Settings {
        
        /// 设置的 URL
        public static let url = UIApplication.openSettingsURLString
        
        /// 打开设置
        public static func open() {
            let applicationShared =  UIApplication.shared
            if let settingsUrl = URL(string: url),
               applicationShared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    applicationShared.open(settingsUrl, options: [:], completionHandler: nil)
                } else {
                    applicationShared.openURL(settingsUrl)
                }
            }
        }
        
       public static func showAlert(message: String?) {
            let alertVC = UIAlertController(alertTitle: "是否打开设置？", message: message, leftActionTitle: "取消", leftActionStyle: .cancel, leftHandler: { action in
                
            }, rightActionTitle: "确定", rightActionStyle: .default) { action  in
                NKDevice.Settings.open()
            }
            UIWindow.topViewController()?.present(alertVC, animated: true, completion: {
                
            })
        }
    }
}
