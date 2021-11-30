//
//  NKWebViewController+Archive.swift
//  NKUtility
//
//  Created by wenghengcong on 2021/11/30.
//

import Foundation
import WebKit

public extension NKWebViewController {
    
    private func archiveURL() -> URL? {
        guard cacheEnable else { return nil}
        guard let fileName = self.weburl?.removeCharacters(from: CharacterSet.alphanumerics.inverted) else { return nil }
        var cacheKey = fileName.replaceFirstOccurrence(of: "/", with: "_")
        let archiveURL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(cacheKey).appendingPathExtension("webarchive")
        return archiveURL
    }
    
    public func archiveWebContent() {
        guard cacheEnable else { return }
        guard let url = self.weburl, let URL = URL(string: url) else {
//        guard let URL = URL(string: "https://nshipster.com/wkwebview") else { // test
            return
        }
        guard let archiveURL = archiveURL() else {
            return
        }
        webView?.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            WebArchiver.archive(url: URL, cookies: cookies, includeJavascript: false) { result in
                if let data = result.plistData {
                    do {
                        try data.write(to: archiveURL)
                        self.archiveState = .archiveCreated
                    } catch {
                        self.archiveState = .achivingFailed(error: error)
                    }
                } else if let firstError = result.errors.first {
                    self.archiveState = .achivingFailed(error: firstError)
                }
            }
        }
    }
    
    public func unArchiveWebContent() -> Bool {
        guard cacheEnable else { return false}
        guard let archiveURL = archiveURL() else {
            return false
        }
        var findArchive = false
        if FileManager.default.fileExists(atPath: archiveURL.path) {
            webView?.loadFileURL(archiveURL, allowingReadAccessTo: archiveURL)
            findArchive = true
        } else {
            self.archiveState = .noArchive
            findArchive = false
        }
        return findArchive
    }
    
}
