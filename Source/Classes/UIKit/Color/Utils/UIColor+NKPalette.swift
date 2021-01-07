//
//  UIColor+NKPalette.swift
//  FireFly
//
//  Created by Hunt on 2020/10/25.
//

import Foundation
import UIKit

/// color 详见 [Colours on github](https://github.com/bennyguitar/Colours)

extension UIColor {
    // MARK: - Predefined Colors
    // MARK: System Colors
    class func infoBlueColor() -> Color
    {
        return self.colorWith(47, G:112, B:225, A:1.0)
    }
    
    class func successColor() -> Color
    {
        return self.colorWith(83, G:215, B:106, A:1.0)
    }
    
    class func warningColor() -> Color
    {
        return self.colorWith(221, G:170, B:59, A:1.0)
    }
    
    class func dangerColor() -> Color
    {
        return self.colorWith(229, G:0, B:15, A:1.0)
    }
    
    
    // MARK: Whites
    class func antiqueWhiteColor() -> Color
    {
        return self.colorWith(250, G:235, B:215, A:1.0)
    }
    
    class func oldLaceColor() -> Color
    {
        return self.colorWith(253, G:245, B:230, A:1.0)
    }
    
    class func ivoryColor() -> Color
    {
        return self.colorWith(255, G:255, B:240, A:1.0)
    }
    
    class func seashellColor() -> Color
    {
        return self.colorWith(255, G:245, B:238, A:1.0)
    }
    
    class func ghostWhiteColor() -> Color
    {
        return self.colorWith(248, G:248, B:255, A:1.0)
    }
    
    class func snowColor() -> Color
    {
        return self.colorWith(255, G:250, B:250, A:1.0)
    }
    
    class func linenColor() -> Color
    {
        return self.colorWith(250, G:240, B:230, A:1.0)
    }
    
    
    // MARK: Grays
    class func black25PercentColor() -> Color
    {
        return Color(white:0.25, alpha:1.0)
    }
    
    class func black50PercentColor() -> Color
    {
        return Color(white:0.5,  alpha:1.0)
    }
    
    class func black75PercentColor() -> Color
    {
        return Color(white:0.75, alpha:1.0)
    }
    
    class func warmGrayColor() -> Color
    {
        return self.colorWith(133, G:117, B:112, A:1.0)
    }
    
    class func coolGrayColor() -> Color
    {
        return self.colorWith(118, G:122, B:133, A:1.0)
    }
    
    class func charcoalColor() -> Color
    {
        return self.colorWith(34, G:34, B:34, A:1.0)
    }
    
    
    // MARK: Blues
    class func tealColor() -> Color
    {
        return self.colorWith(28, G:160, B:170, A:1.0)
    }
    
    class func steelBlueColor() -> Color
    {
        return self.colorWith(103, G:153, B:170, A:1.0)
    }
    
    class func robinEggColor() -> Color
    {
        return self.colorWith(141, G:218, B:247, A:1.0)
    }
    
    class func pastelBlueColor() -> Color
    {
        return self.colorWith(99, G:161, B:247, A:1.0)
    }
    
    class func turquoiseColor() -> Color
    {
        return self.colorWith(112, G:219, B:219, A:1.0)
    }
    
    class func skyBlueColor() -> Color
    {
        return self.colorWith(0, G:178, B:238, A:1.0)
    }
    
    class func indigoColor() -> Color
    {
        return self.colorWith(13, G:79, B:139, A:1.0)
    }
    
    class func denimColor() -> Color
    {
        return self.colorWith(67, G:114, B:170, A:1.0)
    }
    
    class func blueberryColor() -> Color
    {
        return self.colorWith(89, G:113, B:173, A:1.0)
    }
    
    class func cornflowerColor() -> Color
    {
        return self.colorWith(100, G:149, B:237, A:1.0)
    }
    
    class func babyBlueColor() -> Color
    {
        return self.colorWith(190, G:220, B:230, A:1.0)
    }
    
    class func midnightBlueColor() -> Color
    {
        return self.colorWith(13, G:26, B:35, A:1.0)
    }
    
    class func fadedBlueColor() -> Color
    {
        return self.colorWith(23, G:137, B:155, A:1.0)
    }
    
    class func icebergColor() -> Color
    {
        return self.colorWith(200, G:213, B:219, A:1.0)
    }
    
    class func waveColor() -> Color
    {
        return self.colorWith(102, G:169, B:251, A:1.0)
    }
    
    
    // MARK: Greens
    class func emeraldColor() -> Color
    {
        return self.colorWith(1, G:152, B:117, A:1.0)
    }
    
    class func grassColor() -> Color
    {
        return self.colorWith(99, G:214, B:74, A:1.0)
    }
    
    class func pastelGreenColor() -> Color
    {
        return self.colorWith(126, G:242, B:124, A:1.0)
    }
    
    class func seafoamColor() -> Color
    {
        return self.colorWith(77, G:226, B:140, A:1.0)
    }
    
    class func paleGreenColor() -> Color
    {
        return self.colorWith(176, G:226, B:172, A:1.0)
    }
    
    class func cactusGreenColor() -> Color
    {
        return self.colorWith(99, G:111, B:87, A:1.0)
    }
    
    class func chartreuseColor() -> Color
    {
        return self.colorWith(69, G:139, B:0, A:1.0)
    }
    
    class func hollyGreenColor() -> Color
    {
        return self.colorWith(32, G:87, B:14, A:1.0)
    }
    
    class func oliveColor() -> Color
    {
        return self.colorWith(91, G:114, B:34, A:1.0)
    }
    
    class func oliveDrabColor() -> Color
    {
        return self.colorWith(107, G:142, B:35, A:1.0)
    }
    
    class func moneyGreenColor() -> Color
    {
        return self.colorWith(134, G:198, B:124, A:1.0)
    }
    
    class func honeydewColor() -> Color
    {
        return self.colorWith(216, G:255, B:231, A:1.0)
    }
    
    class func limeColor() -> Color
    {
        return self.colorWith(56, G:237, B:56, A:1.0)
    }
    
    class func cardTableColor() -> Color
    {
        return self.colorWith(87, G:121, B:107, A:1.0)
    }
    
    
    // MARK: Reds
    class func salmonColor() -> Color
    {
        return self.colorWith(233, G:87, B:95, A:1.0)
    }
    
    class func brickRedColor() -> Color
    {
        return self.colorWith(151, G:27, B:16, A:1.0)
    }
    
    class func easterPinkColor() -> Color
    {
        return self.colorWith(241, G:167, B:162, A:1.0)
    }
    
    class func grapefruitColor() -> Color
    {
        return self.colorWith(228, G:31, B:54, A:1.0)
    }
    
    class func pinkColor() -> Color
    {
        return self.colorWith(255, G:95, B:154, A:1.0)
    }
    
    class func indianRedColor() -> Color
    {
        return self.colorWith(205, G:92, B:92, A:1.0)
    }
    
    class func strawberryColor() -> Color
    {
        return self.colorWith(190, G:38, B:37, A:1.0)
    }
    
    class func coralColor() -> Color
    {
        return self.colorWith(240, G:128, B:128, A:1.0)
    }
    
    class func maroonColor() -> Color
    {
        return self.colorWith(80, G:4, B:28, A:1.0)
    }
    
    class func watermelonColor() -> Color
    {
        return self.colorWith(242, G:71, B:63, A:1.0)
    }
    
    class func tomatoColor() -> Color
    {
        return self.colorWith(255, G:99, B:71, A:1.0)
    }
    
    class func pinkLipstickColor() -> Color
    {
        return self.colorWith(255, G:105, B:180, A:1.0)
    }
    
    class func paleRoseColor() -> Color
    {
        return self.colorWith(255, G:228, B:225, A:1.0)
    }
    
    class func crimsonColor() -> Color
    {
        return self.colorWith(187, G:18, B:36, A:1.0)
    }
    
    
    // MARK: Purples
    class func eggplantColor() -> Color
    {
        return self.colorWith(105, G:5, B:98, A:1.0)
    }
    
    class func pastelPurpleColor() -> Color
    {
        return self.colorWith(207, G:100, B:235, A:1.0)
    }
    
    class func palePurpleColor() -> Color
    {
        return self.colorWith(229, G:180, B:235, A:1.0)
    }
    
    class func coolPurpleColor() -> Color
    {
        return self.colorWith(140, G:93, B:228, A:1.0)
    }
    
    class func violetColor() -> Color
    {
        return self.colorWith(191, G:95, B:255, A:1.0)
    }
    
    class func plumColor() -> Color
    {
        return self.colorWith(139, G:102, B:139, A:1.0)
    }
    
    class func lavenderColor() -> Color
    {
        return self.colorWith(204, G:153, B:204, A:1.0)
    }
    
    class func raspberryColor() -> Color
    {
        return self.colorWith(135, G:38, B:87, A:1.0)
    }
    
    class func fuschiaColor() -> Color
    {
        return self.colorWith(255, G:20, B:147, A:1.0)
    }
    
    class func grapeColor() -> Color
    {
        return self.colorWith(54, G:11, B:88, A:1.0)
    }
    
    class func periwinkleColor() -> Color
    {
        return self.colorWith(135, G:159, B:237, A:1.0)
    }
    
    class func orchidColor() -> Color
    {
        return self.colorWith(218, G:112, B:214, A:1.0)
    }
    
    
    // MARK: Yellows
    class func goldenrodColor() -> Color
    {
        return self.colorWith(215, G:170, B:51, A:1.0)
    }
    
    class func yellowGreenColor() -> Color
    {
        return self.colorWith(192, G:242, B:39, A:1.0)
    }
    
    class func bananaColor() -> Color
    {
        return self.colorWith(229, G:227, B:58, A:1.0)
    }
    
    class func mustardColor() -> Color
    {
        return self.colorWith(205, G:171, B:45, A:1.0)
    }
    
    class func buttermilkColor() -> Color
    {
        return self.colorWith(254, G:241, B:181, A:1.0)
    }
    
    class func goldColor() -> Color
    {
        return self.colorWith(139, G:117, B:18, A:1.0)
    }
    
    class func creamColor() -> Color
    {
        return self.colorWith(240, G:226, B:187, A:1.0)
    }
    
    class func lightCreamColor() -> Color
    {
        return self.colorWith(240, G:238, B:215, A:1.0)
    }
    
    class func wheatColor() -> Color
    {
        return self.colorWith(240, G:238, B:215, A:1.0)
    }
    
    class func beigeColor() -> Color
    {
        return self.colorWith(245, G:245, B:220, A:1.0)
    }
    
    
    // MARK: Oranges
    class func peachColor() -> Color
    {
        return self.colorWith(242, G:187, B:97, A:1.0)
    }
    
    class func burntOrangeColor() -> Color
    {
        return self.colorWith(184, G:102, B:37, A:1.0)
    }
    
    class func pastelOrangeColor() -> Color
    {
        return self.colorWith(248, G:197, B:143, A:1.0)
    }
    
    class func cantaloupeColor() -> Color
    {
        return self.colorWith(250, G:154, B:79, A:1.0)
    }
    
    class func carrotColor() -> Color
    {
        return self.colorWith(237, G:145, B:33, A:1.0)
    }
    
    class func mandarinColor() -> Color
    {
        return self.colorWith(247, G:145, B:55, A:1.0)
    }
    
    
    // MARK: Browns
    class func chiliPowderColor() -> Color
    {
        return self.colorWith(199, G:63, B:23, A:1.0)
    }
    
    class func burntSiennaColor() -> Color
    {
        return self.colorWith(138, G:54, B:15, A:1.0)
    }
    
    class func chocolateColor() -> Color
    {
        return self.colorWith(94, G:38, B:5, A:1.0)
    }
    
    class func coffeeColor() -> Color
    {
        return self.colorWith(141, G:60, B:15, A:1.0)
    }
    
    class func cinnamonColor() -> Color
    {
        return self.colorWith(123, G:63, B:9, A:1.0)
    }
    
    class func almondColor() -> Color
    {
        return self.colorWith(196, G:142, B:72, A:1.0)
    }
    
    class func eggshellColor() -> Color
    {
        return self.colorWith(252, G:230, B:201, A:1.0)
    }
    
    class func sandColor() -> Color
    {
        return self.colorWith(222, G:182, B:151, A:1.0)
    }
    
    class func mudColor() -> Color
    {
        return self.colorWith(70, G:45, B:29, A:1.0)
    }
    
    class func siennaColor() -> Color
    {
        return self.colorWith(160, G:82, B:45, A:1.0)
    }
    
    class func dustColor() -> Color
    {
        return self.colorWith(236, G:214, B:197, A:1.0)
    }
    
}
