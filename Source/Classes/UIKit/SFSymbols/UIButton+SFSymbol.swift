#if canImport(UIKit) && (os(iOS) || os(tvOS) || targetEnvironment(macCatalyst))

import UIKit

@available(iOS 13.0, tvOS 13.0, *)
public extension UIButton {

    /// Creates and returns a system type button with specified symbol, target, and action.
    ///
    /// - Parameter with: The `SFSymbol` describing the image for the system button.
    /// - Parameter target: The object that receives the action message.
    /// - Parameter action: The action to send to target when this item is selected.
    class func systemButton(with symbol: SFSymbol, target: Any?, action: Selector?) -> Self {
        let symbol = UIImage(symbol: symbol)
        return self.systemButton(with: symbol, target: target, action: action)
    }

    /// Sets the system symbol to use for the specified state.
    ///
    /// - Parameter with: The `SFSymbol` describing this image.
    /// - Parameter state: The state that uses the specified image.
    func setImage(_ symbol: SFSymbol, for state: UIControl.State) {
        let symbol = UIImage(symbol: symbol)
        self.setImage(symbol, for: state)
    }
    

}

#endif
