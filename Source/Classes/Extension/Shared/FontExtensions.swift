// FontExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(UIKit)
import UIKit
/// SwifterSwift: Font
public typealias NKFont = UIFont
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
/// SwifterSwift: Font
public typealias NKFont = NSFont
#endif
