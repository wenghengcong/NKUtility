#if canImport(UIKit)

import UIKit

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension UIImage {
    
    //NKTODO: 无法设置颜色
    static func symbol(symbolName: String,
                       pointSize: CGFloat? = 17,
                       font: UIFont?,
                       weight: UIImage.SymbolWeight? = nil,
                       scale: UIImage.SymbolScale? = nil,
                       textStyle: UIFont.TextStyle? = nil,
                       tintColor: UIColor?) -> UIImage? {
        let config = UIImage.SymbolConfiguration.combine(pointSize, weight, scale, textStyle)
        if tintColor != nil {
            let image = UIImage(systemName: symbolName, withConfiguration: config)?.withTintColor(tintColor!, renderingMode: .alwaysOriginal)
            return image
        } else {
            let image = UIImage(systemName: symbolName, withConfiguration: config)
            return image
        }
    }
    
    convenience init?(symbolName: String,
                      pointSize: CGFloat? = 17,
                      font: UIFont?,
                      weight: UIImage.SymbolWeight? = nil,
                      scale: UIImage.SymbolScale? = nil,
                      textStyle: UIFont.TextStyle? = nil,
                      tintColor: UIColor?) {
        let config = UIImage.SymbolConfiguration.combine(pointSize, weight, scale, textStyle)
        self.init(systemName: symbolName, withConfiguration: config)
        if tintColor != nil {
            withTintColor(tintColor!, renderingMode: .alwaysOriginal)
        }
    }
    
    convenience init?(symbolName: String,
                      pointSize: CGFloat? = 17,
                      weight: UIImage.SymbolWeight?,
                      scale: UIImage.SymbolScale?,
                      tintColor: UIColor?) {
        self.init(symbolName: symbolName, pointSize: pointSize, font: nil,  weight: weight, scale: scale, textStyle: nil, tintColor: tintColor);
    }
    
    convenience init?(symbolName: String,
                      pointSize: CGFloat? = 17,
                      tintColor: UIColor?) {
        self.init(symbolName: symbolName, pointSize: pointSize, font: nil, weight: nil, scale: nil, textStyle: nil, tintColor: tintColor);
    }
    
    convenience init?(symbolName: String,
                      pointSize: CGFloat? = 17) {
        self.init(symbolName: symbolName, pointSize: pointSize, font: nil,  weight: nil, scale: nil, textStyle: nil, tintColor: nil);
    }
    
    /// Retrieve a system symbol image of the given type.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    @available(iOS 13.0, tvOS 13.0, *)
    @available(watchOS, unavailable)
    convenience init(symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)!
    }
    
    /// Retrieve a system symbol image of the given type and with the given configuration.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter configuration: The `UIImage.Configuration` applied to this system image.
    @available(iOS 13.0, tvOS 13.0, *)
    @available(watchOS, unavailable)
    convenience init(symbol: SFSymbol, withConfiguration configuration: UIImage.SymbolConfiguration?) {
        self.init(systemName: symbol.rawValue, withConfiguration: configuration)!
    }
    
    /// Initialize a SF Symbol with shortcuts for configuration properties.
    convenience init(symbol: SFSymbol,
                     pointSize: CGFloat? = nil,
                     weight: SymbolWeight? = nil,
                     scale: SymbolScale? = nil,
                     textStyle: UIFont.TextStyle? = nil) {
        self.init(symbol: symbol, withConfiguration: .combine(pointSize, weight, scale, textStyle))
    }
}

#endif
