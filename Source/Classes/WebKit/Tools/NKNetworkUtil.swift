//
//  NKNetworkManager.swift
//  FireFly
//
//  Created by Hunt on 2020/11/22.
//

import Foundation

/// 网络工具类
public class NKNetworkUtil: NSObject {
    
    public static let shared = NKNetworkUtil()
    
    private var reachability: Reachability!
    private var listeners: [ReachabilityConnectionListener] = []
    
    /// 上一次的状态
    public var lastState: Reachability.Connection = .unavailable
    
    /// 监听网络状态变更的回调类型
    public typealias ReachabilityConnectionListener = (Reachability.Connection) -> Void
    
    /// 当前网络连接
    public var reachabilityStatus: Reachability.Connection {
        return self.reachability.connection
    }
    
    /// 网络是否可用
    public var isReachable: Bool {
        lastState = currentConnection()
        return currentConnection() != .unavailable
    }
    
    /// 是否是蜂窝数据网络
    public var isReachableOnCellular: Bool {
        lastState = currentConnection()
        return currentConnection() == .cellular
    }
    /// 是否是 wifi
    public var isReachableOnWiFi: Bool {
        lastState = currentConnection()
        return currentConnection() == .wifi
    }
    
    override init() {
        super.init()
        self.reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleConnectionChange(_:)), name: .reachabilityChanged, object: nil)
        try! self.reachability.startNotifier()
        
    }
    
    /// 当前网络状态
    public func currentConnection() -> Reachability.Connection {
        return self.reachability.connection
    }
    
    /// 添加网络监听
    public func addReachabilityChangeHandlers(_ listener: @escaping ReachabilityConnectionListener) {
        self.listeners.append(listener)
    }
    
    @objc func handleConnectionChange(_ notification: Notification) {
        let conn = self.reachability.connection
        switch conn{
        case .unavailable:
            debugPrint("Reachability Network became unreachable")
        case .wifi:
            debugPrint("Reachability Network reachable through WiFi")
        case .cellular:
            debugPrint("Reachability Network reachable through Cellular Data")
        }
        
        for listener in self.listeners {
            listener(conn)
        }
    }
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleConnectionChange(_:)), name: .reachabilityChanged, object: nil)
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
        
    }
    
    /// Stop monitoring the network availabilty status
    func stopMonitoring() {
        reachability.stopNotifier()
        lastState = .unavailable
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    deinit {
        stopMonitoring()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }
}
