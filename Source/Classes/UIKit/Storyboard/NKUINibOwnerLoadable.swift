/*********************************************
 *
 * This code is under the MIT License (MIT)
 *
 * Copyright (c) 2016 AliSoftware
 *
 *********************************************/

#if canImport(UIKit)
import UIKit

// MARK: Protocol Definition

/*
 * 1.视图从 Nib 加载，假如如果该 Nib 设置了File's Owner为该类，未将类 Custom Class设置为该类，声明 NKUINibOwnerLoadable
 * 2.视图从 Nib 加载，如果 Nib 未设置 File's Owner，只是将 root view 设置为该类，则使用 NKUINibLoadable 声明
 
 #if TARGET_INTERFACE_BUILDER

 /// 每次在 IB 即将把这个自定义的 view 渲染到画布之前会调用这个方法进行最后的配置
 open override func prepareForInterfaceBuilder() {
     super.prepareForInterfaceBuilder()
     
 }
 
 #endif
 
 */
/// Make your UIView subclasses conform to this protocol when:
///  * they *are* NIB-based, and
///  * this class is used as the XIB's File's Owner
///
/// to be able to instantiate them from the NIB in a type-safe manner
public protocol NKUINibOwnerLoadable: class {
  /// The nib file to use to load a new instance of the View designed in a XIB
  static var nib: UINib { get }
}

// MARK: Default implementation

public extension NKUINibOwnerLoadable {
  /// By default, use the nib which have the same name as the name of the class,
  /// and located in the bundle of that class
  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }
}

// MARK: Support for instantiation from NIB

public extension NKUINibOwnerLoadable where Self: UIView {
  /**
   Adds content loaded from the nib to the end of the receiver's list of subviews and adds constraints automatically.
   */
  func loadNibContent() {
    let layoutAttributes: [NSLayoutConstraint.Attribute] = [.top, .leading, .bottom, .trailing]
    for case let view as UIView in type(of: self).nib.instantiate(withOwner: self, options: nil) {
      view.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview(view)
      NSLayoutConstraint.activate(layoutAttributes.map { attribute in
        NSLayoutConstraint(
          item: view, attribute: attribute,
          relatedBy: .equal,
          toItem: self, attribute: attribute,
          multiplier: 1, constant: 0.0
        )
      })
    }
  }
}
#endif

/// Swift < 4.2 support
#if !(swift(>=4.2))
private extension NSLayoutConstraint {
  typealias Attribute = NSLayoutAttribute
}
#endif
