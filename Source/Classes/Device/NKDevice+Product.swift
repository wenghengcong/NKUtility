//
//  NKDevice+Product.swift
//  FireFly
//
//  Created by Hunt on 2020/11/24.
//

import Foundation
import UIKit

extension NKDevice {
    
    // MARK: - Device Series
    public enum Series: String {
        case unknown
        case iPhone
        case iPad
        case iPod
        case appleTV
        case appleWatch
        case homePod
        case airPods
        case simulator
    }
    
    /// PPI (Pixels per Inch) on the current device's screen (if applicable). When the device is not applicable this property returns nil.
    public var series: NKDevice.Series {
        #if os(iOS)
        switch self {
       
        // MARK: - iPod
        case .iPodTouch5,.iPodTouch6, .iPodTouch7:
            return .iPod

        // MARK: - iPhone
        case .iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6,
             .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE
            , .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR
            , .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12,
             .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax,
             .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax:
            return .iPhone
            
        // MARK: - iPad
        case .iPad2, .iPad3, .iPad4, .iPad5, .iPad6, .iPad7, .iPad8,
             .iPadAir, .iPadAir2, .iPadAir3, .iPadAir4,
             .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5
            , .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch,
             .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4,
             .iPad9,.iPadMini6,.iPadPro11Inch3,.iPadPro12Inch5:
            return .iPad
            
        case .homePod: return .homePod
        case .simulator(let model): return model.series
        case .unknown: return .unknown

        }
        #elseif os(watchOS)
        switch self {
        case .appleWatchSeries0_38mm, .appleWatchSeries0_42mm
            , .appleWatchSeries1_38mm, .appleWatchSeries1_42mm
            , .appleWatchSeries2_38mm, .appleWatchSeries2_42mm
            , .appleWatchSeries3_38mm, .appleWatchSeries3_42mm
            , .appleWatchSeries4_40mm, .appleWatchSeries4_44mm
            , .appleWatchSeries5_40mm, .appleWatchSeries5_44mm
            , .appleWatchSeries6_40mm, .appleWatchSeries6_44mm
            , .appleWatchSE_40mm, .appleWatchSE_44mm:
            return .appleWatch
        case .simulator(let model): return model.series
        case .unknown: return .unknown
        }
        #elseif os(tvOS)
        return nil
        #endif
    }
    
    
    /// PPI (Pixels per Inch) on the current device's screen (if applicable). When the device is not applicable this property returns nil.
    public var releaseYear: Int? {
        #if os(iOS)
        switch self {
       
        // MARK: - iPod
        case .iPodTouch5: return 2012
        case .iPodTouch6: return 2015
        case .iPodTouch7: return 2019
        
        // MARK: - iPhone
        case .iPhone4: return 2010
        case .iPhone4s: return 2011
        case .iPhone5: return 2012
        case .iPhone5c: return 2013
        case .iPhone5s: return 2013
        case .iPhone6: return 2014
        case .iPhone6Plus: return 201
        case .iPhone6s: return 2015
        case .iPhone6sPlus: return 2015
        case .iPhone7: return 2016
        case .iPhone7Plus: return 2016
        case .iPhoneSE: return 2016
        case .iPhone8: return 2017
        case .iPhone8Plus: return 2017
        case .iPhoneX: return 2017
        case .iPhoneXS: return 2018
        case .iPhoneXSMax: return 2018
        case .iPhoneXR: return 2018
        case .iPhone11: return 2019
        case .iPhone11Pro: return 2019
        case .iPhone11ProMax: return 2019
        case .iPhoneSE2: return 2020
        case .iPhone12: return 2020
        case .iPhone12Mini: return 2020
        case .iPhone12Pro: return 2020
        case .iPhone12ProMax: return 2020
        case .iPhone13: return 2021
        case .iPhone13Mini: return 2021
        case .iPhone13Pro: return 2021
        case .iPhone13ProMax: return 2021
            
        // MARK: - iPad
        case .iPad2: return 2011
        case .iPad3: return 2012
        case .iPad4: return 2012
        case .iPad5: return 2017
        case .iPad6: return 2018
        case .iPad7: return 2019
        case .iPad8: return 2020
        case .iPad9:
            return 2021
    
            
        // MARK: - iPad Air
        case .iPadAir: return 2013
        case .iPadAir2: return 2014
        case .iPadAir3: return 2019
        case .iPadAir4: return 2020

        // MARK: - iPad Mini
        case .iPadMini: return 2012
        case .iPadMini2: return 2013
        case .iPadMini3: return 2014
        case .iPadMini4: return 2015
        case .iPadMini5: return 2019
        case .iPadMini6:
            return 2021
    
        // MARK: - iPad Pro
        case .iPadPro9Inch: return 2016
        case .iPadPro12Inch: return 2015
        case .iPadPro12Inch2: return 2017
        case .iPadPro10Inch: return 2017
        case .iPadPro11Inch: return 2018
        case .iPadPro12Inch3: return 2018
        case .iPadPro11Inch2: return 2020
        case .iPadPro12Inch4: return 2020
        case .iPadPro11Inch3:
            return 2021
        case .iPadPro12Inch5:
            return 2021
        case .homePod: return -1
        case .simulator(let model): return model.ppi
        case .unknown: return nil
      
        }
        #elseif os(watchOS)
        switch self {
        case .appleWatchSeries0_38mm: return 2015
        case .appleWatchSeries0_42mm: return 2015
        case .appleWatchSeries1_38mm: return 2016
        case .appleWatchSeries1_42mm: return 2016
        case .appleWatchSeries2_38mm: return 2016
        case .appleWatchSeries2_42mm: return 2016
        case .appleWatchSeries3_38mm: return 2017
        case .appleWatchSeries3_42mm: return 2017
        case .appleWatchSeries4_40mm: return 2018
        case .appleWatchSeries4_44mm: return 2018
        case .appleWatchSeries5_40mm: return 2019
        case .appleWatchSeries5_44mm: return 2019
        case .appleWatchSeries6_40mm: return 2020
        case .appleWatchSeries6_44mm: return 2020
        case .appleWatchSE_40mm: return 2020
        case .appleWatchSE_44mm: return 2020
        case .simulator(let model): return model.releaseYear
        case .unknown: return nil
        }
        #elseif os(tvOS)
        return nil
        #endif
    }
}
