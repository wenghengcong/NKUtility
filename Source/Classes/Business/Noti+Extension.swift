//
//  Noti+Extension.swift
//  NemoAppSeries
//
//  Created by Nemo on 2022/7/3.
//

import Foundation

public extension Notification.Name {
    
    struct NKBiness {
        public static let WillLogin = Notification.Name(rawValue: "\(nk_nemo_prefix).willlogin")
        public static let DidLogin = Notification.Name(rawValue: "\(nk_nemo_prefix).didlogin")
        
        /// 获取到oauth token
        public static let GetOAuthToken = Notification.Name(rawValue: "\(nk_nemo_prefix).gettoken")
        /// 登录后，获取到用户信息
        public static let GetUserInfo = Notification.Name(rawValue: "\(nk_nemo_prefix).getuserinfo")
        
        public static let WillLogout = Notification.Name(rawValue: "\(nk_nemo_prefix).willlogout")
        public static let DidLogout = Notification.Name(rawValue: "\(nk_nemo_prefix).didlogout")
    }
    
    struct NKNetwork {
        /// Network reachablity
        public static let NotReachable = Notification.Name(rawValue: "\(nk_nemo_prefix).NotReachable")
        public static let Unknown = Notification.Name(rawValue: "\(nk_nemo_prefix).Unknown")
        public static let ReachableAfterUnreachable = Notification.Name(rawValue: "\(nk_nemo_prefix).ReachableAfterUnreachable")
        public static let ReachableWiFi = Notification.Name(rawValue: "\(nk_nemo_prefix).ReachableWiFi")
        public static let ReachableCellular = Notification.Name(rawValue: "\(nk_nemo_prefix).ReachableCellular")
        public static let UnReachableAfterReachable = Notification.Name(rawValue: "\(nk_nemo_prefix).UnReachableAfterReachable")
        
        public static let ReachabilityChanged = Notification.Name("\(nk_nemo_prefix).ReachabilityChanged")

    }

    struct App {
        public static let EnterHome = Notification.Name(rawValue: "\(nk_nemo_prefix).App.EnterHome")
        public static let EnterMine = Notification.Name(rawValue: "\(nk_nemo_prefix).App.EnterMine")
    }
    
    struct Privacy {
        public static let PrivacyDialog = Notification.Name(rawValue: "\(nk_nemo_prefix)Privacy.PrivacyDialog")
        public static let Push = Notification.Name(rawValue: "\(nk_nemo_prefix).Privacy.Push")
    }
    
    struct Pay {
        public static let ResultRefresh = Notification.Name(rawValue: "\(nk_nemo_prefix).Pay.ResultRefresh")
    }
    
    struct CoreData {
        public static let didFindRelevantTransactions = Notification.Name("\(nk_nemo_prefix).didFindRelevantTransactions")
    }
}
