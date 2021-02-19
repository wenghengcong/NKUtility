//
//  NKCookieStore.swift
//  NKUtility
//
//  Created by Hunt on 2021/2/4.
//

import Foundation
import UIKit


// MARK: - CookieStore
public class NKCookieStore: NSObject {
    // MARK: - Properties
    public static let shared = NKCookieStore()
    public var saveDomains = [String]() {
        didSet {
            self.saveCookies()
        }
    }
    private let kCookieStoreSavedHTTPCookiesKey = "kNKCookieStoreCookiesKey"

    // MARK: - Initialize
    override init() {
        super.init()
        self.loadCookies()
    }

    deinit {
        self.removeNotification()
    }

    public func setup() {
        self.registApplicationNotification()
    }
}

// MARK: - Control Cookies
public extension NKCookieStore {
    
    func cookies() -> [HTTPCookie]? {
        if let cookies = HTTPCookieStorage.shared.cookies {
            return cookies
        }
        return nil
    }
    
    func cookiesMap() -> [String: String]? {
        if let cookies = cookies() {
            var map: [String: String] = [:]
            for cookie in cookies {
                map.updateValue(cookie.value, forKey: cookie.name)
            }
            return map
        }
        return nil
    }
    
    /// 生成 header 中的cookie字符串
    func cookiesString() -> String {
        var cookieString = ""
        if let cookies = cookiesMap() {
            for cookie in cookies {
                let name = cookie.key
                let value = cookie.value
                let newEntry = String(format: "%@=%@;", name, value)
                cookieString.append(newEntry)
            }
            // 移除最后一个分号
            cookieString.removeLast()
        }
        return cookieString
    }
    
    func cookieValue(domain: String, name: String) -> String {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies where cookie.domain == domain && cookie.name == name {
                return cookie.value
            }
        }
        return ""
    }

    @objc func loadCookies() {
        let defaults = UserDefaults.standard
        if let cookiesData = defaults.object(forKey: kCookieStoreSavedHTTPCookiesKey) as? NSData {
            if let cookies = NSKeyedUnarchiver.unarchiveObject(with: cookiesData as Data) as? [HTTPCookie] {
                for cookie in cookies {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
            }
        }
    }

    @objc func saveCookies() {
        let defaults = UserDefaults.standard
        if let cookies = HTTPCookieStorage.shared.cookies {
            var savedCookies = [HTTPCookie]()
            for cookie in cookies where self.saveDomains.contains(cookie.domain) {
                savedCookies.append(cookie)
            }
            if !savedCookies.isEmpty {
                let cookiesData = NSKeyedArchiver.archivedData(withRootObject: savedCookies)
                defaults.set(cookiesData, forKey: kCookieStoreSavedHTTPCookiesKey)
                defaults.synchronize()
                return
            }
        }

        defaults.removeObject(forKey: kCookieStoreSavedHTTPCookiesKey)
        defaults.synchronize()
    }

    func deleteCookies() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        self.saveCookies()
    }

    func deleteCookie(domain: String) {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies where cookie.domain == domain {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        self.saveCookies()
    }

    func deleteCookie(domain: String, name: String, path: String = "/") {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies where cookie.domain == domain && cookie.name == name && cookie.path == path {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        self.saveCookies()
    }

    func addCookie(_ cook: HTTPCookie) {
        HTTPCookieStorage.shared.setCookie(cook)
        self.saveCookies()
    }
    
    func addCookie(value: String, name: String, domain: String, path: String = "/", expiresDate: NSDate? = nil) {
        self.deleteCookie(domain: domain, name: name, path: path)

        var properties = [HTTPCookiePropertyKey: Any]()
        properties[HTTPCookiePropertyKey.value] = value
        properties[HTTPCookiePropertyKey.name] = name
        properties[HTTPCookiePropertyKey.domain] = domain
        properties[HTTPCookiePropertyKey.expires] = expiresDate ?? "0"
        properties[HTTPCookiePropertyKey.path] = path

        if let cookie = HTTPCookie(properties: properties) {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
        self.saveCookies()
    }
}

// MARK: - NSNotification
private extension NKCookieStore {
    private func registApplicationNotification() {
        let nCenter = NotificationCenter.default
        nCenter.addObserver(self, selector: #selector(loadCookies), name: UIApplication.didBecomeActiveNotification, object: nil)
        nCenter.addObserver(self, selector: #selector(saveCookies), name: UIApplication.didEnterBackgroundNotification, object: nil)
        nCenter.addObserver(self, selector: #selector(saveCookies), name: UIApplication.willTerminateNotification, object: nil)
    }

    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
}
