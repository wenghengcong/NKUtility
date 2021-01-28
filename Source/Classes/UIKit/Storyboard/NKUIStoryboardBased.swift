//
//  NKUITableView.swift
//  FireFly
//
//  Created by Hunt on 2020/11/4.
//

#if canImport(UIKit)
import UIKit

// MARK: Protocol Definition
/// Make your UIViewController subclasses conform to this protocol when:
///  * they *are* Storyboard-based, and
///  * this ViewController is the initialViewController of your Storyboard
///
/// to be able to instantiate them from the Storyboard in a type-safe manner
public protocol NMUIStoryboardBased: class {
  /// The UIStoryboard to use when we want to instantiate this ViewController
  static var sceneStoryboard: UIStoryboard { get }
}

// MARK: Default Implementation
public extension NMUIStoryboardBased {
  /// By default, use the storybaord with the same name as the class
  static var sceneStoryboard: UIStoryboard {
    return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
  }
}

// MARK: Support for instantiation from Storyboard
public extension NMUIStoryboardBased where Self: UIViewController {
  /**
   Create an instance of the ViewController from its associated Storyboard's initialViewController
   - returns: instance of the conforming ViewController
   */
  static func instantiate() -> Self {
    let viewController = sceneStoryboard.instantiateInitialViewController()
    guard let typedViewController = viewController as? Self else {
      fatalError("The initialViewController of '\(sceneStoryboard)' is not of class '\(self)'")
    }
    return typedViewController
  }
}
#endif
