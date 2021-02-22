//
//  NKDevice+Screen.swift
//  FireFly
//
//  Created by Hunt on 2020/11/23.
//

import UIKit

extension NKDevice {
    // The device screen size.
    #if os(iOS) || os(watchOS)
    public enum Screen: String {
        case sizeUnknown      = "Unknown"
        #if os(iOS)
        case size3Dot5IN      = "3.5 inches"
        case size4IN          = "4 inches"
        case size4Dot7IN      = "4,7 inches"
        case size5Dot4IN      = "5,4 inches"
        case size5Dot5IN      = "5,5 inches"
        case size5Dot8IN      = "5,8 inches"
        case size6Dot1IN      = "6,1 inches"
        case size6Dot5IN      = "6,5 inches"
        case size6Dot7IN      = "6,7 inches"
        case size7Dot9IN      = "7,9 inches"
        case size9Dot7IN      = "9,7 inches"
        case size10Dot2IN     = "10,2 inches"
        case size10Dot5IN     = "10,5 inches"
        case size10Dot9IN     = "10,9 inches"
        case size11IN         = "11 inches"
        case size12Dot9IN     = "12,9 inches"
        #elseif os(watchOS)
        case size1Dot5IN      = "1.5 inches"
        case size1Dot6IN      = "1.6 inches"
        case size1Dot8IN      = "1.8 inches"
        case size2IN          = "2.0 inches"
        #endif
        
        /// This is the value as `Double` of the screen size.
        /// Could be useful to make comparison.
        /// 屏幕对角线的长度
        var diagonal: Double {
            switch self {
            case .sizeUnknown:
                return -1
            #if os(iOS)
            case .size3Dot5IN:
                return 3
            case .size4IN:
                return 4
            case .size4Dot7IN:
                return 4.7
            case .size5Dot4IN:
                return 5.4
            case .size5Dot5IN:
                return 5.5
            case .size5Dot8IN:
                return 5.8
            case .size6Dot1IN:
                return 6.1
            case .size6Dot5IN:
                return 6.5
            case .size6Dot7IN:
                return 6.7
            case .size7Dot9IN:
                return 7.9
            case .size9Dot7IN:
                return 9.7
            case .size10Dot2IN:
                return 10.2
            case .size10Dot5IN:
                return 10.5
            case .size10Dot9IN:
                return 10.9
            case .size11IN:
                return 11
            case .size12Dot9IN:
                return 12.9
            #elseif os(watchOS)
            case .size1Dot5IN:
                return 1.5
            case .size1Dot6IN:
                return 1.6
            case .size4Dot7IN:
                return 1.7
            case .size1Dot8IN:
                return 1.8
            case .size2IN:
                return 2.0
            #endif
            }
        }
        
        
        /// The current brightness
        public static var brightness: Float {
            return Float(UIScreen.main.brightness)
        }
        
        /// Check if the screen is being mirrored.
        public static var isMirrored: Bool {
            if let _ = UIScreen.main.mirrored {
                return true
            }
            
            return false
        }
        
        /// The bounding rectange of the physical screen measured in pixels.
        public static var nativeBounds: CGRect {
            return UIScreen.mainNativeBounds
        }
        
        /// The scale of the physical screen.
        public static var nativeScale: Float {
            return Float(UIScreen.mainNativeScale)
        }
        
        /// The bounds of the current main screen.
        public static var bounds: CGRect {
            return UIScreen.mainBounds
        }
        
        public static var width: CGFloat {
            return UIScreen.mainWidth
        }
        
        /// 顶部导航栏高度
        public static var topBarHeight: CGFloat {
            let topbarHeight = UIViewController.topViewController()?.topBarHeight ?? 0
            return topbarHeight
        }
        
        public static var height: CGFloat {
            return UIScreen.mainHeight
        }
        
        /// The scale of the current main screen.
        public static var scale: Float {
            return Float(UIScreen.mainScale)
        }
        
        public static var isRetina: Bool {
            return UIScreen.isRetina
        }
        
        /// The snapshot of the current view after all the updates are applied.
        public static var snapshotOfCurrentView: UIView {
            return UIScreen.main.snapshotView(afterScreenUpdates: true)
        }
    }
    #endif
}

extension NKDevice {
    
    /// PPI (Pixels per Inch) on the current device's screen (if applicable). When the device is not applicable this property returns nil.
    public var ppi: Int? {
        #if os(iOS)
        switch self {
        case .iPodTouch1: return 163
        case .iPodTouch2: return 163
        case .iPodTouch3: return 163
        case .iPodTouch4: return 326
        case .iPodTouch5: return 326
        case .iPodTouch6: return 326
        case .iPodTouch7: return 326
        case .iPhone4: return 326
        case .iPhone4s: return 326
        case .iPhone5: return 326
        case .iPhone5c: return 326
        case .iPhone5s: return 326
        case .iPhone6: return 326
        case .iPhone6Plus: return 401
        case .iPhone6s: return 326
        case .iPhone6sPlus: return 401
        case .iPhone7: return 326
        case .iPhone7Plus: return 401
        case .iPhoneSE: return 326
        case .iPhone8: return 326
        case .iPhone8Plus: return 401
        case .iPhoneX: return 458
        case .iPhoneXS: return 458
        case .iPhoneXSMax: return 458
        case .iPhoneXR: return 326
        case .iPhone11: return 326
        case .iPhone11Pro: return 458
        case .iPhone11ProMax: return 458
        case .iPhoneSE2: return 326
        case .iPhone12: return 460
        case .iPhone12Mini: return 476
        case .iPhone12Pro: return 460
        case .iPhone12ProMax: return 458
        case .iPad2: return 132
        case .iPad3: return 264
        case .iPad4: return 264
        case .iPadAir: return 264
        case .iPadAir2: return 264
        case .iPad5: return 264
        case .iPad6: return 264
        case .iPadAir3: return 264
        case .iPad7: return 264
        case .iPad8: return 264
        case .iPadAir4: return 264
        case .iPadMini: return 163
        case .iPadMini2: return 326
        case .iPadMini3: return 326
        case .iPadMini4: return 326
        case .iPadMini5: return 326
        case .iPadPro9Inch: return 264
        case .iPadPro12Inch: return 264
        case .iPadPro12Inch2: return 264
        case .iPadPro10Inch: return 264
        case .iPadPro11Inch: return 264
        case .iPadPro12Inch3: return 264
        case .iPadPro11Inch2: return 264
        case .iPadPro12Inch4: return 264
        case .homePod: return -1
        case .simulator(let model): return model.ppi
        case .unknown: return nil
        }
        #elseif os(watchOS)
        switch self {
        case .appleWatchSeries0_38mm: return 290
        case .appleWatchSeries0_42mm: return 303
        case .appleWatchSeries1_38mm: return 290
        case .appleWatchSeries1_42mm: return 303
        case .appleWatchSeries2_38mm: return 290
        case .appleWatchSeries2_42mm: return 303
        case .appleWatchSeries3_38mm: return 290
        case .appleWatchSeries3_42mm: return 303
        case .appleWatchSeries4_40mm: return 326
        case .appleWatchSeries4_44mm: return 326
        case .appleWatchSeries5_40mm: return 326
        case .appleWatchSeries5_44mm: return 326
        case .appleWatchSeries6_40mm: return 326
        case .appleWatchSeries6_44mm: return 326
        case .appleWatchSE_40mm: return 326
        case .appleWatchSE_44mm: return 326
        case .simulator(let model): return model.ppi
        case .unknown: return nil
        }
        #elseif os(tvOS)
        return nil
        #endif
    }
    
    
    #if os(iOS) || os(watchOS)
    /// Returns diagonal screen length in inches
    public var screenDiagonal: NKDevice.Screen {
        #if os(iOS)
        switch self {
        case .iPodTouch1: return .size3Dot5IN
        case .iPodTouch2: return .size3Dot5IN
        case .iPodTouch3: return .size3Dot5IN
        case .iPodTouch4: return .size3Dot5IN
        case .iPodTouch5: return .size4IN
        case .iPodTouch6: return .size4IN
        case .iPodTouch7: return .size4IN
        case .iPhone4: return .size3Dot5IN
        case .iPhone4s: return .size3Dot5IN
        case .iPhone5: return .size4IN
        case .iPhone5c: return .size4IN
        case .iPhone5s: return .size4IN
        case .iPhone6: return .size4Dot7IN
        case .iPhone6Plus: return .size5Dot5IN
        case .iPhone6s: return .size4Dot7IN
        case .iPhone6sPlus: return .size5Dot5IN
        case .iPhone7: return .size4Dot7IN
        case .iPhone7Plus: return .size5Dot5IN
        case .iPhoneSE: return .size4IN
        case .iPhone8: return .size4Dot7IN
        case .iPhone8Plus: return .size5Dot5IN
        case .iPhoneX: return .size5Dot8IN
        case .iPhoneXS: return .size5Dot8IN
        case .iPhoneXSMax: return .size6Dot5IN
        case .iPhoneXR: return .size6Dot1IN
        case .iPhone11: return .size6Dot1IN
        case .iPhone11Pro: return .size5Dot8IN
        case .iPhone11ProMax: return .size6Dot5IN
        case .iPhoneSE2: return .size4Dot7IN
        case .iPhone12: return .size6Dot1IN
        case .iPhone12Mini: return .size5Dot4IN
        case .iPhone12Pro: return .size6Dot1IN
        case .iPhone12ProMax: return .size6Dot7IN
        case .iPad2: return .size9Dot7IN
        case .iPad3: return .size9Dot7IN
        case .iPad4: return .size9Dot7IN
        case .iPadAir: return .size9Dot7IN
        case .iPadAir2: return .size9Dot7IN
        case .iPad5: return .size9Dot7IN
        case .iPad6: return .size9Dot7IN
        case .iPadAir3: return .size10Dot5IN
        case .iPad7: return .size10Dot2IN
        case .iPad8: return .size10Dot2IN
        case .iPadAir4: return .size10Dot9IN
        case .iPadMini: return .size7Dot9IN
        case .iPadMini2: return .size7Dot9IN
        case .iPadMini3: return .size7Dot9IN
        case .iPadMini4: return .size7Dot9IN
        case .iPadMini5: return .size7Dot9IN
        case .iPadPro9Inch: return .size9Dot7IN
        case .iPadPro12Inch: return .size12Dot9IN
        case .iPadPro12Inch2: return .size12Dot9IN
        case .iPadPro10Inch: return .size10Dot5IN
        case .iPadPro11Inch: return .size11IN
        case .iPadPro12Inch3: return .size12Dot9IN
        case .iPadPro11Inch2: return .size11IN
        case .iPadPro12Inch4: return .size12Dot9IN
        case .homePod: return .sizeUnknown
        case .simulator(let model): return model.screenDiagonal
        case .unknown: return .sizeUnknown
        }
        #elseif os(watchOS)
        switch self {
        case .appleWatchSeries0_38mm: return .size1Dot5IN
        case .appleWatchSeries0_42mm: return .size1Dot6IN
        case .appleWatchSeries1_38mm: return .size1Dot5IN
        case .appleWatchSeries1_42mm: return .size1Dot6IN
        case .appleWatchSeries2_38mm: return .size1Dot5IN
        case .appleWatchSeries2_42mm: return .size1Dot6IN
        case .appleWatchSeries3_38mm: return .size1Dot5IN
        case .appleWatchSeries3_42mm: return .size1Dot6IN
        case .appleWatchSeries4_40mm: return .size1Dot8IN
        case .appleWatchSeries4_44mm: return .size2IN
        case .appleWatchSeries5_40mm: return .size1Dot8IN
        case .appleWatchSeries5_44mm: return .size2IN
        case .appleWatchSeries6_40mm: return .size1Dot8IN
        case .appleWatchSeries6_44mm: return .size2IN
        case .appleWatchSE_40mm: return .size1Dot8IN
        case .appleWatchSE_44mm: return .size2IN
        case .simulator(let model): return model.diagonal
        case .unknown: return .sizeUnknown
        }
        #endif
    }
    #endif
    
    /// Returns screen ratio as a tuple
    public var screenRatio: (width: Double, height: Double) {
        #if os(iOS)
        switch self {
        case .iPodTouch1: return (width: 2, height: 3)
        case .iPodTouch2: return (width: 2, height: 3)
        case .iPodTouch3: return (width: 2, height: 3)
        case .iPodTouch4: return (width: 2, height: 3)
        case .iPodTouch5: return (width: 9, height: 16)
        case .iPodTouch6: return (width: 9, height: 16)
        case .iPodTouch7: return (width: 9, height: 16)
        case .iPhone4: return (width: 2, height: 3)
        case .iPhone4s: return (width: 2, height: 3)
        case .iPhone5: return (width: 9, height: 16)
        case .iPhone5c: return (width: 9, height: 16)
        case .iPhone5s: return (width: 9, height: 16)
        case .iPhone6: return (width: 9, height: 16)
        case .iPhone6Plus: return (width: 9, height: 16)
        case .iPhone6s: return (width: 9, height: 16)
        case .iPhone6sPlus: return (width: 9, height: 16)
        case .iPhone7: return (width: 9, height: 16)
        case .iPhone7Plus: return (width: 9, height: 16)
        case .iPhoneSE: return (width: 9, height: 16)
        case .iPhone8: return (width: 9, height: 16)
        case .iPhone8Plus: return (width: 9, height: 16)
        case .iPhoneX: return (width: 9, height: 19.5)
        case .iPhoneXS: return (width: 9, height: 19.5)
        case .iPhoneXSMax: return (width: 9, height: 19.5)
        case .iPhoneXR: return (width: 9, height: 19.5)
        case .iPhone11: return (width: 9, height: 19.5)
        case .iPhone11Pro: return (width: 9, height: 19.5)
        case .iPhone11ProMax: return (width: 9, height: 19.5)
        case .iPhoneSE2: return (width: 9, height: 16)
        case .iPhone12: return (width: 9, height: 19.5)
        case .iPhone12Mini: return (width: 9, height: 19.5)
        case .iPhone12Pro: return (width: 9, height: 19.5)
        case .iPhone12ProMax: return (width: 9, height: 19.5)
        case .iPad2: return (width: 3, height: 4)
        case .iPad3: return (width: 3, height: 4)
        case .iPad4: return (width: 3, height: 4)
        case .iPadAir: return (width: 3, height: 4)
        case .iPadAir2: return (width: 3, height: 4)
        case .iPad5: return (width: 3, height: 4)
        case .iPad6: return (width: 3, height: 4)
        case .iPadAir3: return (width: 3, height: 4)
        case .iPad7: return (width: 3, height: 4)
        case .iPad8: return (width: 3, height: 4)
        case .iPadAir4: return (width: 41, height: 59)
        case .iPadMini: return (width: 3, height: 4)
        case .iPadMini2: return (width: 3, height: 4)
        case .iPadMini3: return (width: 3, height: 4)
        case .iPadMini4: return (width: 3, height: 4)
        case .iPadMini5: return (width: 3, height: 4)
        case .iPadPro9Inch: return (width: 3, height: 4)
        case .iPadPro12Inch: return (width: 3, height: 4)
        case .iPadPro12Inch2: return (width: 3, height: 4)
        case .iPadPro10Inch: return (width: 3, height: 4)
        case .iPadPro11Inch: return (width: 139, height: 199)
        case .iPadPro12Inch3: return (width: 512, height: 683)
        case .iPadPro11Inch2: return (width: 139, height: 199)
        case .iPadPro12Inch4: return (width: 512, height: 683)
        case .homePod: return (width: 4, height: 5)
        case .simulator(let model): return model.screenRatio
        case .unknown: return (width: -1, height: -1)
        }
        #elseif os(watchOS)
        switch self {
        case .appleWatchSeries0_38mm: return (width: 4, height: 5)
        case .appleWatchSeries0_42mm: return (width: 4, height: 5)
        case .appleWatchSeries1_38mm: return (width: 4, height: 5)
        case .appleWatchSeries1_42mm: return (width: 4, height: 5)
        case .appleWatchSeries2_38mm: return (width: 4, height: 5)
        case .appleWatchSeries2_42mm: return (width: 4, height: 5)
        case .appleWatchSeries3_38mm: return (width: 4, height: 5)
        case .appleWatchSeries3_42mm: return (width: 4, height: 5)
        case .appleWatchSeries4_40mm: return (width: 4, height: 5)
        case .appleWatchSeries4_44mm: return (width: 4, height: 5)
        case .appleWatchSeries5_40mm: return (width: 4, height: 5)
        case .appleWatchSeries5_44mm: return (width: 4, height: 5)
        case .appleWatchSeries6_40mm: return (width: 4, height: 5)
        case .appleWatchSeries6_44mm: return (width: 4, height: 5)
        case .appleWatchSE_40mm: return (width: 4, height: 5)
        case .appleWatchSE_44mm: return (width: 4, height: 5)
        case .simulator(let model): return model.screenRatio
        case .unknown: return (width: -1, height: -1)
        }
        #elseif os(tvOS)
        return (width: -1, height: -1)
        #endif
    }
    
}


#if os(iOS)
extension NKDevice.Screen {
    
    public static var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIWindow.topWindow() else {
            return false
        }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
    
    // MARK: Orientation
    public static func isPortrait() -> Bool {
        return UIDevice.current.orientation.isPortrait
    }

    public static func isLandscape() -> Bool {
        return UIDevice.current.orientation.isLandscape
    }
}

// MARK: - scale
/// guide https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
/// https://kapeli.com/cheat_sheets/iOS_Design.docset/Contents/Resources/Documents/index
extension NKDevice.Screen {
    /// 设计稿全部以iPhone 12 Pro Max尺寸设计
    public static func scaleBase320(_ x: CGFloat) -> CGFloat {
        let scale = width/320
        let result = scale * x
        return result
    }
    
    /// 设计稿全部以iPhone XS Max， iPhone 11 Pro Max尺寸设计
    public static func scaleBase375(_ x: CGFloat) -> CGFloat {
        let scale = width/375
        let result = scale * x
        return result
    }
    
    /// 设计稿全部以iPhone 5尺寸设计
    public static func scaleBase390(_ x: CGFloat) -> CGFloat {
        let scale = width/390
        let result = scale * x
        return result
    }
    
    /// 设计稿全部以iPhone 6尺寸设计
    public static func scaleBase414(_ x: CGFloat) -> CGFloat {
        let scale = width/414.0
        let result = scale * x
        return result
    }
    
    /// 设计稿全部以iPhone 6 Plus尺寸设计
    public static func scaleBase428(_ x: CGFloat) -> CGFloat {
        let scale = width/428
        let result = scale * x
        return result
    }
}
#endif
