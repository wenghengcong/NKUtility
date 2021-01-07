//
//  NKNetworkManager+Noti.swift
//  FireFly
//
//  Created by Hunt on 2020/11/22.
//

import Foundation

extension Notification.Name {
    public struct NKNetwork {
        /// Network reachablity
        public static let NotReachable = Notification.Name(rawValue: "com.luci.beefun.mac.NotReachable")
        public static let Unknown = Notification.Name(rawValue: "com.luci.beefun.mac.Unknown")
        public static let ReachableAfterUnreachable = Notification.Name(rawValue: "com.luci.beefun.mac.ReachableAfterUnreachable")
        public static let ReachableWiFi = Notification.Name(rawValue: "com.luci.beefun.mac.ReachableWiFi")
        public static let ReachableCellular = Notification.Name(rawValue: "com.luci.beefun.mac.ReachableCellular")
        public static let UnReachableAfterReachable = Notification.Name(rawValue: "com.luci.beefun.mac.UnReachableAfterReachable")
        
    }
}
