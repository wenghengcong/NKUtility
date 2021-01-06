//
//  Color.swift
//  FireFly
//
//  Created by Hunt on 2020/10/25.
//

import Foundation
#if !os(Linux)

#if canImport(UIKit)
import UIKit
/// SwifterSwift: Color
public typealias Color = UIColor
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
/// SwifterSwift: Color
public typealias Color = NSColor
#endif

public extension Color {
    // MARK: - Closure
    typealias TransformBlock = (CGFloat) -> CGFloat
    
    // MARK: - Enums
    enum ColorScheme:Int {
        case analagous = 0, monochromatic, triad, complementary
    }
    
    enum ColorFormulation:Int {
        case rgba = 0, hsba, lab, cmyk
    }
    
    enum ColorDistance:Int {
        case cie76 = 0, cie94, cie2000
    }
    
    enum ColorComparison:Int {
        case darkness = 0, lightness, desaturated, saturated, red, green, blue
    }
    
    var redValue: CGFloat{
        return cgColor.components! [0]
    }
    
    var greenValue: CGFloat{
        return cgColor.components! [1]
    }
    
    var blueValue: CGFloat{
        return cgColor.components! [2]
    }
    
    var alphaValue: CGFloat{
        return cgColor.components! [3]
    }
    
    
    var isWhiteText: Bool {
        // non-RGB color
        if cgColor.numberOfComponents == 2 {
            return 0.0...0.5 ~= cgColor.components!.first! ? true : false
        }
        
        let red = self.redValue * 255
        let green = self.greenValue * 255
        let blue = self.blueValue * 255
        
        // https://en.wikipedia.org/wiki/YIQ
        // https://24ways.org/2010/calculating-color-contrast/
        let yiq = ((red * 299) + (green * 587) + (blue * 114)) / 1000
        return yiq < 192
    }
    
    
    // MARK: - Color from Hex/RGBA/HSBA/CIE_LAB/CMYK
    convenience init(hex: String) {
        var rgbInt: UInt64 = 0
        let newHex = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: newHex)
        scanner.scanHexInt64(&rgbInt)
        let r: CGFloat = CGFloat((rgbInt & 0xFF0000) >> 16)/255.0
        let g: CGFloat = CGFloat((rgbInt & 0x00FF00) >> 8)/255.0
        let b: CGFloat = CGFloat(rgbInt & 0x0000FF)/255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    convenience init(hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat )) {
        self.init(hue: hsba.h, saturation: hsba.s, brightness: hsba.b, alpha: hsba.a)
    }
    
    convenience init(CIE_LAB: (l: CGFloat, a: CGFloat, b: CGFloat, alpha: CGFloat )) {
        // Set Up
        var Y = (CIE_LAB.l + 16.0)/116.0
        var X = CIE_LAB.a/500 + Y
        var Z = Y - CIE_LAB.b/200
        
        // Transform XYZ
        let deltaXYZ: TransformBlock = { k in
            return (pow(k, 3.0) > 0.008856) ? pow(k, 3.0) : (k - 4/29.0)/7.787
        }
        X = deltaXYZ(X)*0.95047
        Y = deltaXYZ(Y)*1.000
        Z = deltaXYZ(Z)*1.08883
        
        // Convert XYZ to RGB
        let R = X*3.2406 + (Y * -1.5372) + (Z * -0.4986)
        let G = (X * -0.9689) + Y*1.8758 + Z*0.0415
        let B = X*0.0557 + (Y * -0.2040) + Z*1.0570
        let deltaRGB: TransformBlock = { k in
            return (k > 0.0031308) ? 1.055 * (pow(k, (1/2.4))) - 0.055 : k * 12.92
        }
        
        self.init(rgba: (deltaRGB(R), deltaRGB(G), deltaRGB(B), CIE_LAB.alpha))
    }
    
    convenience init(cmyk: (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat)) {
        let cmyTransform: TransformBlock = { x in
            return x * (1 - cmyk.k) + cmyk.k
        }
        let C = cmyTransform(cmyk.c)
        let M = cmyTransform(cmyk.m)
        let Y = cmyTransform(cmyk.y)
        self.init(rgba: (1 - C, 1 - M, 1 - Y, 1.0))
    }
    
    
    // MARK: - Color to Hex/RGBA/HSBA/CIE_LAB/CMYK
    
    func rgba() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let components = self.cgColor.components
        let numberOfComponents = self.cgColor.numberOfComponents
        
        switch numberOfComponents {
        case 4:
            return (components![0], components![1], components![2], components![3])
        case 2:
            return (components![0], components![0], components![0], components![1])
        default:
            // FIXME: Fallback to black
            return (0, 0, 0, 1)
        }
    }
    
    func hsba() -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if self.responds(to: #selector(UIColor.getHue(_:saturation:brightness:alpha:))) && self.cgColor.numberOfComponents == 4 {
            self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        }
        
        return (h, s, b, a)
    }
    
    func CIE_LAB() -> (l: CGFloat, a: CGFloat, b: CGFloat, alpha: CGFloat) {
        // Get XYZ
        let xyzT = xyz()
        let x = xyzT.x/95.047
        let y = xyzT.y/100.000
        let z = xyzT.z/108.883
        
        // Transfrom XYZ to L*a*b
        let deltaF: TransformBlock = { f in
            if f > pow((6.0/29.0), 3.0) {
                return pow(f, 1.0/3.0)
            }
            let expressionA: CGFloat = (1/3)
            let expressionB: CGFloat = pow((29.0/6.0), 2.0)
            let expressionC: CGFloat = 4/29.0
            return expressionA * expressionB * f + expressionC
        }
        let X = deltaF(x)
        let Y = deltaF(y)
        let Z = deltaF(z)
        let L = 116*Y - 16
        let a = 500 * (X - Y)
        let b = 200 * (Y - Z)
        
        return (L, a, b, xyzT.alpha)
    }
    
    func xyz() -> (x: CGFloat, y: CGFloat, z: CGFloat, alpha: CGFloat) {
        // Get RGBA values
        let rgbaT = rgba()
        
        // Transfrom values to XYZ
        let deltaR: TransformBlock = { R in
            return (R > 0.04045) ? pow((R + 0.055)/1.055, 2.40) : (R/12.92)
        }
        let R = deltaR(rgbaT.r)
        let G = deltaR(rgbaT.g)
        let B = deltaR(rgbaT.b)
        let X = (R*41.24 + G*35.76 + B*18.05)
        let Y = (R*21.26 + G*71.52 + B*7.22)
        let Z = (R*1.93 + G*11.92 + B*95.05)
        
        return (X, Y, Z, rgbaT.a)
    }
    
    func cmyk() -> (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
        // Convert RGB to CMY
        let rgbaT = rgba()
        let C = 1 - rgbaT.r
        let M = 1 - rgbaT.g
        let Y = 1 - rgbaT.b
        
        // Find K
        let K = min(1, min(C, min(Y, M)))
        if (K == 1) {
            return (0, 0, 0, 1)
        }
        
        // Convert cmyk
        let newCMYK: TransformBlock = { x in
            return (x - K)/(1 - K)
        }
        return (newCMYK(C), newCMYK(M), newCMYK(Y), K)
    }
    
    
    // MARK: - Color Components
    func hue() -> CGFloat {
        return hsba().h
    }
    
    func saturation() -> CGFloat {
        return hsba().s
    }
    
    func brightness() -> CGFloat {
        return hsba().b
    }
    
    func CIE_Lightness() -> CGFloat {
        return CIE_LAB().l
    }
    
    func CIE_a() -> CGFloat {
        return CIE_LAB().a
    }
    
    func CIE_b() -> CGFloat {
        return CIE_LAB().b
    }
    
    func cyan() -> CGFloat {
        return cmyk().c
    }
    
    func magenta() -> CGFloat {
        return cmyk().m
    }
    
    func yellow() -> CGFloat {
        return cmyk().y
    }
    
    func keyBlack() -> CGFloat {
        return cmyk().k
    }
    
    
    // MARK: - Lighten/Darken Color
    func lightenedColor(_ percentage: CGFloat) -> Color {
        return modifiedColor(percentage + 1.0)
    }
    
    func darkenedColor(_ percentage: CGFloat) -> Color {
        return modifiedColor(1.0 - percentage)
    }
    
    fileprivate func modifiedColor(_ percentage: CGFloat) -> Color {
        let hsbaT = hsba()
        return Color(hsba: (hsbaT.h, hsbaT.s, hsbaT.b * percentage, hsbaT.a))
    }
    
    
    // MARK: - Contrasting Color
    func blackOrWhiteContrastingColor() -> Color {
        let rgbaT = rgba()
        let value = 1 - ((0.299 * rgbaT.r) + (0.587 * rgbaT.g) + (0.114 * rgbaT.b));
        return value < 0.5 ? Color.black : Color.white
    }
    
    func blackOrGrayContrastingColor() -> UIColor {
        let rgbaT = rgba()
        let value = 1 - ((0.299 * rgbaT.r) + (0.587 * rgbaT.g) + (0.114 * rgbaT.b));
        return value < 0.75 ? UIColor.black : UIColor.lightGray
    }
    
    // MARK: - Complementary Color
    func complementaryColor() -> Color {
        let hsbaT = hsba()
        let newH = Color.addDegree(180.0, staticDegree: hsbaT.h*360.0)
        return Color(hsba: (newH, hsbaT.s, hsbaT.b, hsbaT.a))
    }
    
    
    // MARK: - Color Scheme
    func colorScheme(_ type: ColorScheme) -> [Color] {
        switch (type) {
        case .analagous:
            return Color.analgousColors(self.hsba())
        case .monochromatic:
            return Color.monochromaticColors(self.hsba())
        case .triad:
            return Color.triadColors(self.hsba())
        default:
            return Color.complementaryColors(self.hsba())
        }
    }
    
    fileprivate class func analgousColors(_ hsbaT: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)) -> [Color] {
        return [Color(hsba: (self.addDegree(30, staticDegree: hsbaT.h*360)/360.0, hsbaT.s-0.05, hsbaT.b-0.1, hsbaT.a)),
                Color(hsba: (self.addDegree(15, staticDegree: hsbaT.h*360)/360.0, hsbaT.s-0.05, hsbaT.b-0.05, hsbaT.a)),
                Color(hsba: (self.addDegree(-15, staticDegree: hsbaT.h*360)/360.0, hsbaT.s-0.05, hsbaT.b-0.05, hsbaT.a)),
                Color(hsba: (self.addDegree(-30, staticDegree: hsbaT.h*360)/360.0, hsbaT.s-0.05, hsbaT.b-0.1, hsbaT.a))]
    }
    
    fileprivate class func monochromaticColors(_ hsbaT: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)) -> [Color] {
        return [Color(hsba: (hsbaT.h, hsbaT.s/2, hsbaT.b/3, hsbaT.a)),
                Color(hsba: (hsbaT.h, hsbaT.s, hsbaT.b/2, hsbaT.a)),
                Color(hsba: (hsbaT.h, hsbaT.s/3, 2*hsbaT.b/3, hsbaT.a)),
                Color(hsba: (hsbaT.h, hsbaT.s, 4*hsbaT.b/5, hsbaT.a))]
    }
    
    fileprivate class func triadColors(_ hsbaT: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)) -> [Color] {
        return [Color(hsba: (self.addDegree(120, staticDegree: hsbaT.h*360)/360.0, 2*hsbaT.s/3, hsbaT.b-0.05, hsbaT.a)),
                Color(hsba: (self.addDegree(120, staticDegree: hsbaT.h*360)/360.0, hsbaT.s, hsbaT.b, hsbaT.a)),
                Color(hsba: (self.addDegree(240, staticDegree: hsbaT.h*360)/360.0, hsbaT.s, hsbaT.b, hsbaT.a)),
                Color(hsba: (self.addDegree(240, staticDegree: hsbaT.h*360)/360.0, 2*hsbaT.s/3, hsbaT.b-0.05, hsbaT.a))]
    }
    
    fileprivate class func complementaryColors(_ hsbaT: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)) -> [Color] {
        return [Color(hsba: (hsbaT.h, hsbaT.s, 4*hsbaT.b/5, hsbaT.a)),
                Color(hsba: (hsbaT.h, 5*hsbaT.s/7, hsbaT.b, hsbaT.a)),
                Color(hsba: (self.addDegree(180, staticDegree: hsbaT.h*360)/360.0, hsbaT.s, hsbaT.b, hsbaT.a)),
                Color(hsba: (self.addDegree(180, staticDegree: hsbaT.h*360)/360.0, 5*hsbaT.s/7, hsbaT.b, hsbaT.a))]
    }
    
    // MARK: - Private Helpers
    class func colorWith(_ R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat) -> Color {
        return Color(rgba: (R/255.0, G/255.0, B/255.0, A))
    }
    
    fileprivate class func addDegree(_ addDegree: CGFloat, staticDegree: CGFloat) -> CGFloat {
        let s = staticDegree + addDegree;
        if (s > 360) {
            return s - 360;
        }
        else if (s < 0) {
            return -1 * s;
        }
        else {
            return s;
        }
    }
}


extension Int {
    var cgColor: CGColor {
        return UIColor(self).cgColor
    }
}

#endif
