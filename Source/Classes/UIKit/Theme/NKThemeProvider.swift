//
//  NKThemeProvider.swift
//  NKUtility
//
//  Created by Hunt on 2021/2/23.
//

import Foundation
import SwiftTheme

private let lastThemeIndexKey = "lastedThemeIndex"
private let defaults = UserDefaults.standard

public class NKThemeProvider {
    
    public static let shared = NKThemeProvider()
    
    public var themes: [NKThemeProtocol] = []
    public var currentIndex = 0
    public var lightIndex = 0
    public var nightIndex = 1
    
    public func launch(themes:[NKThemeProtocol], lightIndex: Int, nightIndex: Int) {
        assert(lightIndex < themes.count && nightIndex < themes.count, "检查传入主题数目与 index")
        self.themes = themes
        self.lightIndex = lightIndex
        self.nightIndex = nightIndex
        restoreLastTheme()
    }
    
    public static var currentTheme: NKThemeProtocol {
        return shared.current
    }
    
    public static var lastTheme: NKThemeProtocol {
        return shared.last ?? shared.current
    }
    
    // MARK: -
    public var current: NKThemeProtocol {
        assert(currentIndex < themes.count, "index 出错")
        let theme = themes[currentIndex]
        return theme
    }
    
    public var last: NKThemeProtocol?
    
    public var color: NKThemeProtocol {
        return current
    }
    
    // MARK: - Switch Theme
    
    public func switchTo(index: Int) {
        assert(index < themes.count, "index 出错")
        guard currentIndex != index else {
            return
        }
        ThemeManager.setTheme(index: index)
        currentIndex = index
        let theme = themes[index]
        last = theme
        saveLastTheme()
    }
    
    public func switchToNext() {
        var next = ThemeManager.currentThemeIndex + 1
        if next > themes.count { next = 0 } // cycle and without Night
        switchTo(index: next)
    }
    
    // MARK: - Switch Night
    public func switchNight(isToNight: Bool = true) {
        switchTo(index: isToNight ? nightIndex : lastThemeIndex())
    }
    
    public func isNight() -> Bool {
        return currentIndex == nightIndex
    }
    
    // MARK: - Save & Restore
    public func lastThemeIndex() -> Int {
        let last = defaults.integer(forKey: lastThemeIndexKey)
        return last
    }
    
    public func restoreLastTheme() {
        switchTo(index: lastThemeIndex())
    }
    
    public func saveLastTheme() {
        defaults.set(ThemeManager.currentThemeIndex, forKey: lastThemeIndexKey)
    }
}
