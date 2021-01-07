//
//  NKNetworkManager.swift
//  FireFly
//
//  Created by Hunt on 2020/11/22.
//

import Foundation

public class NKNetworkUtil: NSObject {
    
    static let shared = NKNetworkUtil()
    var lastState: Reachability.Connection = .unavailable
    
    typealias ReachabilityConnectionListener = (Reachability.Connection) -> Void
    
    private var reachability: Reachability!
    
    private var listeners: [ReachabilityConnectionListener] = []
    
    var reachabilityStatus: Reachability.Connection {
        return self.reachability.connection
    }
    
    var isReachable: Bool {
        lastState = currentConnection()
        return currentConnection() != .unavailable
    }
    
    var isReachableOnCellular: Bool {
        lastState = currentConnection()
        return currentConnection() == .cellular
    }
    
    var isReachableOnWiFi: Bool {
        lastState = currentConnection()
        return currentConnection() == .wifi
    }
    
    override init() {
        super.init()
        self.reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleConnectionChange(_:)), name: .reachabilityChanged, object: nil)
        try! self.reachability.startNotifier()
        
    }
    
    func currentConnection() -> Reachability.Connection {
        return self.reachability.connection
    }
    
    func addReachabilityChangeHandlers(_ listener: @escaping ReachabilityConnectionListener) {
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
