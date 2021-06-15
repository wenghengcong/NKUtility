/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
//import Shared
import WebKit
import SwiftyJSON
import NKUtility

let ReaderModeProfileKeyStyle = "readermode.style"

public enum ReaderModeMessageType: String {
    case stateChange = "ReaderModeStateChange"
    case pageEvent = "ReaderPageEvent"
    case contentParsed = "ReaderContentParsed"
}

public enum ReaderPageEvent: String {
    case pageShow = "PageShow"
}

public enum ReaderModeState: String {
    case available = "Available"
    case unavailable = "Unavailable"
    case active = "Active"
}

public enum ReaderModeTheme: String {
    case light = "light"
    case dark = "dark"
    case sepia = "sepia"

    static func preferredTheme(for theme: ReaderModeTheme? = nil) -> ReaderModeTheme {
        // If there is no reader theme provided than we default to light theme
        let readerTheme = theme ?? .light
        // Get current Firefox theme (Dark vs Normal)
        // Normal means light theme. This is the overall theme used
        // by Firefox iOS app
        let appWideTheme = NKWebThemeManager.instance.currentName
        // We check for 3 basic themes we have Light / Dark / Sepia
        // Theme: Dark - app-wide dark overrides all
        if appWideTheme == .dark {
            return .dark
        // Theme: Sepia - special case for when the theme is sepia.
        // For this we only check the them supplied and not the app wide theme
        } else if readerTheme == .sepia {
            return .sepia
        }
        // Theme: Light - Default case for when there is no theme supplied i.e. nil and we revert to light
        return readerTheme
    }
}

private struct FontFamily {
    static let serifFamily = [ReaderModeFontType.serif, ReaderModeFontType.serifBold]
    static let sansFamily = [ReaderModeFontType.sansSerif, ReaderModeFontType.sansSerifBold]
    static let families = [serifFamily, sansFamily]
}

public enum ReaderModeFontType: String {
    case serif = "serif"
    case serifBold = "serif-bold"
    case sansSerif = "sans-serif"
    case sansSerifBold = "sans-serif-bold"
    
    init(type: String) {
        let font = ReaderModeFontType(rawValue: type)
        let isBoldFontEnabled = UIAccessibility.isBoldTextEnabled
        
        switch font {
        case .serif,
             .serifBold:
            self = isBoldFontEnabled ? .serifBold : .serif
        case .sansSerif,
             .sansSerifBold:
            self = isBoldFontEnabled ? .sansSerifBold : .sansSerif
        case .none:
            self = .sansSerif
        } 
    }
    
    func isSameFamily(_ font: ReaderModeFontType) -> Bool {        
        return !FontFamily.families.filter { $0.contains(font) && $0.contains(self) }.isEmpty        
    }
}

public enum ReaderModeFontSize: Int {
    case size1 = 1
    case size2 = 2
    case size3 = 3
    case size4 = 4
    case size5 = 5
    case size6 = 6
    case size7 = 7
    case size8 = 8
    case size9 = 9
    case size10 = 10
    case size11 = 11
    case size12 = 12
    case size13 = 13

    public func isSmallest() -> Bool {
        return self == ReaderModeFontSize.size1
    }

    public  func smaller() -> ReaderModeFontSize {
        if isSmallest() {
            return self
        } else {
            return ReaderModeFontSize(rawValue: self.rawValue - 1)!
        }
    }

    public  func isLargest() -> Bool {
        return self == ReaderModeFontSize.size13
    }

    public static var defaultSize: ReaderModeFontSize {
        switch UIApplication.shared.preferredContentSizeCategory {
        case .extraSmall:
            return .size1
        case .small:
            return .size2
        case .medium:
            return .size3
        case .large:
            return .size5
        case .extraLarge:
            return .size7
        case .extraExtraLarge:
            return .size9
        case .extraExtraExtraLarge:
            return .size12
        default:
            return .size5
        }
    }

    public func bigger() -> ReaderModeFontSize {
        if isLargest() {
            return self
        } else {
            return ReaderModeFontSize(rawValue: self.rawValue + 1)!
        }
    }
}

public  struct ReaderModeStyle {
    public var theme: ReaderModeTheme
    public var fontType: ReaderModeFontType
    public var fontSize: ReaderModeFontSize

    /// Encode the style to a JSON dictionary that can be passed to ReaderMode.js
    public func encode() -> String {
        return JSON(["theme": theme.rawValue, "fontType": fontType.rawValue, "fontSize": fontSize.rawValue]).stringify() ?? ""
    }

    /// Encode the style to a dictionary that can be stored in the profile
    public func encodeAsDictionary() -> [String: Any] {
        return ["theme": theme.rawValue, "fontType": fontType.rawValue, "fontSize": fontSize.rawValue]
    }

    public init(theme: ReaderModeTheme, fontType: ReaderModeFontType, fontSize: ReaderModeFontSize) {
        self.theme = theme
        self.fontType = fontType
        self.fontSize = fontSize
    }

    /// Initialize the style from a dictionary, taken from the profile. Returns nil if the object cannot be decoded.
    public init?(dict: [String: Any]) {
        let themeRawValue = dict["theme"] as? String
        let fontTypeRawValue = dict["fontType"] as? String
        let fontSizeRawValue = dict["fontSize"] as? Int
        if themeRawValue == nil || fontTypeRawValue == nil || fontSizeRawValue == nil {
            return nil
        }

        let theme = ReaderModeTheme(rawValue: themeRawValue!)
        let fontType = ReaderModeFontType(type: fontTypeRawValue!)
        let fontSize = ReaderModeFontSize(rawValue: fontSizeRawValue!)
        if theme == nil || fontSize == nil {
            return nil
        }

        self.theme = theme ?? ReaderModeTheme.preferredTheme()
        self.fontType = fontType
        self.fontSize = fontSize!
    }
    
    public mutating func ensurePreferredColorThemeIfNeeded() {
        self.theme = ReaderModeTheme.preferredTheme(for: self.theme)
    }
}

public let DefaultReaderModeStyle = ReaderModeStyle(theme: .light, fontType: .sansSerif, fontSize: ReaderModeFontSize.defaultSize)

/// This struct captures the response from the Readability.js code.
public struct ReadabilityResult {
    var domain = ""
    var url = ""
    var content = ""
    var title = ""
    var credits = ""

    public init?(object: AnyObject?) {
        if let dict = object as? NSDictionary {
            if let uri = dict["uri"] as? NSDictionary {
                if let url = uri["spec"] as? String {
                    self.url = url
                }
                if let host = uri["host"] as? String {
                    self.domain = host
                }
            }
            if let content = dict["content"] as? String {
                self.content = content
            }
            if let title = dict["title"] as? String {
                self.title = title
            }
            if let credits = dict["byline"] as? String {
                self.credits = credits
            }
        } else {
            return nil
        }
    }

    /// Initialize from a JSON encoded string
    public init?(string: String) {
        let object = JSON(parseJSON: string)
        let domain = object["domain"].string
        let url = object["url"].string
        let content = object["content"].string
        let title = object["title"].string
        let credits = object["credits"].string

        if domain == nil || url == nil || content == nil || title == nil || credits == nil {
            return nil
        }

        self.domain = domain!
        self.url = url!
        self.content = content!
        self.title = title!
        self.credits = credits!
    }

    /// Encode to a dictionary, which can then for example be json encoded
    public func encode() -> [String: Any] {
        return ["domain": domain, "url": url, "content": content, "title": title, "credits": credits]
    }

    /// Encode to a JSON encoded string
    public func encode() -> String {
        let dict: [String: Any] = self.encode()
        return JSON(dict).stringify()!
    }
}

/// Delegate that contains callbacks that we have added on top of the built-in WKWebViewDelegate
public protocol ReaderModeDelegate {
    func readerMode(_ readerMode: ReaderMode, didChangeReaderModeState state: ReaderModeState, forWebVc web: NKWebViewController)
    func readerMode(_ readerMode: ReaderMode, didDisplayReaderizedContentForWebVC web: NKWebViewController)
    func readerMode(_ readerMode: ReaderMode, didParseReadabilityResult readabilityResult: ReadabilityResult, forWebVC web: NKWebViewController)
}

let ReaderModeNamespace = "window.__firefox__.reader"

public class ReaderMode: TabContentScript {
    public var delegate: ReaderModeDelegate?

    fileprivate weak var web: NKWebViewController?
    public var state = ReaderModeState.unavailable
    fileprivate var originalURL: URL?

    public  class func name() -> String {
        return "ReaderMode"
    }

    required init(web: NKWebViewController) {
        self.web = web
    }

    public func scriptMessageHandlerName() -> String? {
        return "readerModeMessageHandler"
    }

    fileprivate func handleReaderPageEvent(_ readerPageEvent: ReaderPageEvent) {
        switch readerPageEvent {
            case .pageShow:
                if let web = web {
                    delegate?.readerMode(self, didDisplayReaderizedContentForWebVC: web)
                }
        }
    }

    fileprivate func handleReaderModeStateChange(_ state: ReaderModeState) {
        self.state = state
        guard let web = web else {
            return
        }
        delegate?.readerMode(self, didChangeReaderModeState: state, forWebVc: web)
    }

    fileprivate func handleReaderContentParsed(_ readabilityResult: ReadabilityResult) {
        guard let web = web else {
            return
        }
        delegate?.readerMode(self, didParseReadabilityResult: readabilityResult, forWebVC: web)
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        guard let msg = message.body as? [String: Any], let type = msg["Type"] as? String, let messageType = ReaderModeMessageType(rawValue: type) else { return }
        
        switch messageType {
            case .pageEvent:
                if let readerPageEvent = ReaderPageEvent(rawValue: msg["Value"] as? String ?? "Invalid") {
                    handleReaderPageEvent(readerPageEvent)
                }
            case .stateChange:
                if let readerModeState = ReaderModeState(rawValue: msg["Value"] as? String ?? "Invalid") {
                    handleReaderModeStateChange(readerModeState)
                }
            case .contentParsed:
                if let readabilityResult = ReadabilityResult(object: msg["Value"] as AnyObject?) {
                    handleReaderContentParsed(readabilityResult)
                }
        }
    }

    public var style: ReaderModeStyle = DefaultReaderModeStyle {
        didSet {
            if state == ReaderModeState.active {
                web?.webView?.evaluateJavascriptInDefaultContentWorld("\(ReaderModeNamespace).setStyle(\(style.encode()))") { object, error in
                    return
                }
            }
        }
    }
}
