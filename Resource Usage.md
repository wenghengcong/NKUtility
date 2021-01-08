# bundle 使用
 1. 关于图片或者颜色的使用，可以从MicrosoftFluentUI参考。
 2. 图片使用如下，bundle 见Bundle+Niki.swift
 
 internal class func staticImageNamed(_ name: String) -> UIImage? {
     guard let image = UIImage(named: name, in: FluentUIFramework.resourceBundle, compatibleWith: nil) else {
         preconditionFailure("Missing image asset with name: \(name)")
     }
     return image
 }

  3. 颜色使用
  参考MicrosoftFluentUI下 Colors 的使用
  
  public var color: UIColor {
      if let fluentColor = UIColor(named: "FluentColors/" + self.name, in: FluentUIFramework.resourceBundle, compatibleWith: nil) {
          return fluentColor
      } else {
          preconditionFailure("invalid fluent color")
      }
  }
