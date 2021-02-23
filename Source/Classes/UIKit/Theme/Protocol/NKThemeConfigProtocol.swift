//
//  ColorConfigProtocol.swift
//  FireFly
//
//  Created by Hunt on 2020/10/25.
//

import Foundation
import UIKit

/// 真正的主题配置表，包含所有的内容，假如要实现该类，继承并指定配置
protocol NKThemeConfigProtocol: NKThemeNamedColorProtocol {
    // MARK:  - UIControl
    var controlHighlightedAlpha: CGFloat { get set }
    var controlDisabledAlpha: CGFloat { get set }
    
    // MARK:  - UIButton
    var buttonHighlightedAlpha: CGFloat { get set }
    var buttonDisabledAlpha: CGFloat { get set }
    var buttonTintColor: UIColor { get set }
    var ghostButtonColorBlue: UIColor { get set }
    var ghostButtonColorRed: UIColor { get set }
    var ghostButtonColorGreen: UIColor { get set }
    var ghostButtonColorGray: UIColor { get set }
    var ghostButtonColorWhite: UIColor { get set }
    var fillButtonColorBlue: UIColor { get set }
    var fillButtonColorRed: UIColor { get set }
    var fillButtonColorGreen: UIColor { get set }
    var fillButtonColorGray: UIColor { get set }
    var fillButtonColorWhite: UIColor { get set }
    
    // MARK: - UITextField & UITextView
    var textFieldTextColor: UIColor { get set }
    var textFieldTintColor: UIColor { get set }
    var textFieldTextInsets: UIEdgeInsets { get set }
    
    var keyboardAppearance: UIKeyboardAppearance { get set }
    
    // MARK: - UISwitch
    var switchOnTintColor: UIEdgeInsets { get set }
    var switchOffTintColor: UIEdgeInsets { get set }
    var switchTintColor: UIEdgeInsets { get set }
    var switchThumbTintColor: UIEdgeInsets { get set }
    var switchOnImage: UIImage { get set }
    var switchOffImage: UIImage { get set }

    // MARK: - NavigationBar
    var navBarHighlightedAlpha: CGFloat { get set }
    var navBarDisabledAlpha: CGFloat { get set }
    var navBarButtonFont: UIFont { get set }
    var navBarButtonFontBold: UIFont { get set }
    var navBarBackgroundImage: UIImage { get set }
    var navBarShadowImageColor: UIColor { get set }
    var navBarBarTintColor: UIColor { get set }
    var navBarStyle: UIBarStyle { get set }
    var navBarTintColor: UIColor { get set }
    var navBarTitleColor: UIColor { get set }
    var navBarTitleFont: UIFont { get set }
    var navBarLargeTitleColor: UIColor { get set }
    var navBarLargeTitleFont: UIColor { get set }
    var navBarBackButtonTitlePositionAdjustment: UIOffset { get set }

    var sizeNavBarBackIndicatorImageAutomatically: Bool { get set }
    var navBarBackIndicatorImage: UIImage { get set }
    var navBarCloseButtonImage: UIImage { get set }
    var navBarLoadingMarginRight: CGFloat { get set }
    var navBarAccessoryViewMarginLeft: CGFloat { get set }
    var navBarActivityIndicatorViewStyle: UIActivityIndicatorView.Style { get set }
    var navBarAccessoryViewTypeDisclosureIndicatorImage: UIImage { get set }

    
    // MARK: - TabBar
    var tabBarBackgroundImage: UIImage { get set }
    var tabBarBarTintColor: UIColor { get set }
    var tabBarShadowImageColor: UIColor { get set }
    var tabBarStyle: UIBarStyle { get set }
    var tabBarItemTitleFont: UIFont { get set }
    var tabBarItemTitleColor: UIColor { get set }
    var tabBarItemTitleColorSelected: UIColor { get set }
    var tabBarItemImageColor: UIColor { get set }
    var tabBarItemImageColorSelected: UIColor { get set }
    
    // MARK: - Toolbar
    var toolBarHighlightedAlpha: CGFloat { get set }
    var toolBarDisabledAlpha: CGFloat { get set }
    var toolBarTintColor: UIColor { get set }
    var toolBarTintColorHighlighted: UIColor { get set }
    var toolBarTintColorDisabled: UIColor { get set }
    
    var toolBarBackgroundImage: UIImage { get set }
    var toolBarBarTintColor: UIColor { get set }
    var toolBarShadowImageColor: UIColor { get set }
    var toolBarStyle: UIBarStyle { get set }
    var toolBarButtonFont: UIFont { get set }
    
    // MARK: - SearchBar
    var searchBarTextFieldBackgroundImage: UIImage { get set }
    var searchBarTextFieldBorderColor: UIColor { get set }
    var searchBarBackgroundImage: UIImage { get set }
    var searchBarTintColor: UIColor { get set }
    var searchBarTextColor: UIColor { get set }
    
    var searchBarPlaceholderColor: UIColor { get set }
    var searchBarFont: UIFont { get set }
    
    /// 搜索框放大镜icon的图片，大小必须为14x14pt，否则会失真（系统的限制）
    var searchBarSearchIconImage: UIImage { get set }
    var searchBarClearIconImage: UIImage { get set }
    var searchBarTextFieldCornerRadius: CGFloat { get set }
    
    // MARK: - TableView / TableViewCell
    var tableViewEstimatedHeightEnabled: Bool { get set }
    var tableViewBackgroundColor: UIColor { get set }
    var tableSectionIndexColor: UIColor { get set }
    
    var tableSectionIndexBackgroundColor: UIColor { get set }
    var tableSectionIndexTrackingBackgroundColor: UIColor { get set }
    var tableViewSeparatorColor: UIColor { get set }
    
    var tableViewCellNormalHeight: CGFloat { get set }
    var tableViewCellTitleLabelColor: UIColor { get set }
    var tableViewCellDetailLabelColor: UIColor { get set }
    
    var tableViewCellBackgroundColor: UIColor { get set }
    var tableViewCellSelectedBackgroundColor: UIColor { get set }
    var tableViewCellWarningBackgroundColor: UIColor { get set }
    
    var tableViewCellDisclosureIndicatorImage: UIImage { get set }
    var tableViewCellCheckmarkImage: UIImage { get set }
    var tableViewCellDetailButtonImage: UIImage { get set }
    
    var tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator: CGFloat { get set }
    var tableViewSectionHeaderBackgroundColor: UIColor { get set }
    var tableViewSectionFooterBackgroundColor: UIColor { get set }
    
    var tableViewSectionHeaderFont: UIFont { get set }
    var tableViewSectionFooterFont: UIFont { get set }
    var tableViewSectionHeaderTextColor: UIColor { get set }
    
    var tableViewSectionFooterTextColor: UIColor { get set }
    var tableViewSectionHeaderAccessoryMargins: UIEdgeInsets { get set }
    var tableViewSectionFooterAccessoryMargins: UIEdgeInsets { get set }
    
    var tableViewSectionHeaderContentInset: UIEdgeInsets { get set }
    var tableViewSectionFooterContentInset: UIEdgeInsets { get set }
    var tableViewGroupedBackgroundColor: UIColor { get set }
    
    var tableViewGroupedSeparatorColor: UIColor { get set }
    var tableViewGroupedCellTitleLabelColor: UIColor { get set }
    var tableViewGroupedCellDetailLabelColor: UIColor { get set }
    
    var tableViewGroupedCellBackgroundColor: UIColor { get set }
    var tableViewGroupedCellSelectedBackgroundColor: UIColor { get set }
    var tableViewGroupedCellWarningBackgroundColor: UIColor { get set }

    var tableViewGroupedSectionHeaderFont: UIFont { get set }
    var tableViewGroupedSectionFooterFont: UIFont { get set }
    var tableViewGroupedSectionHeaderTextColor: UIColor { get set }
    
    var tableViewGroupedSectionFooterTextColor: UIColor { get set }
    var tableViewGroupedSectionHeaderAccessoryMargins: UIEdgeInsets { get set }
    var tableViewGroupedSectionFooterAccessoryMargins: UIEdgeInsets { get set }
    
    var tableViewGroupedSectionHeaderDefaultHeight: CGFloat { get set }
    var tableViewGroupedSectionFooterDefaultHeight: CGFloat { get set }
    var tableViewGroupedSectionHeaderContentInset: UIEdgeInsets { get set }
    
    var tableViewGroupedSectionFooterContentInset: UIEdgeInsets { get set }
    var tableViewInsetGroupedCornerRadius: CGFloat { get set }
    var tableViewInsetGroupedHorizontalInset: UIEdgeInsets { get set }
    
    var tableViewInsetGroupedBackgroundColor: UIColor { get set }
    var tableViewInsetGroupedSeparatorColor: UIColor { get set }
    var tableViewInsetGroupedCellTitleLabelColor: UIColor { get set }
    
    var tableViewInsetGroupedCellDetailLabelColor: UIColor { get set }
    var tableViewInsetGroupedCellBackgroundColor: UIColor { get set }
    var tableViewInsetGroupedCellSelectedBackgroundColor: UIColor { get set }
    
    var tableViewInsetGroupedCellWarningBackgroundColor: UIColor { get set }
    var tableViewInsetGroupedSectionHeaderFont: UIFont { get set }
    var tableViewInsetGroupedSectionFooterFont: UIFont { get set }
    
    var tableViewInsetGroupedSectionHeaderTextColor: UIColor { get set }
    var tableViewInsetGroupedSectionFooterTextColor: UIColor { get set }
    var tableViewInsetGroupedSectionHeaderAccessoryMargins: UIEdgeInsets { get set }
    
    var tableViewInsetGroupedSectionFooterAccessoryMargins: UIEdgeInsets { get set }
    var tableViewInsetGroupedSectionHeaderDefaultHeight: CGFloat { get set }
    var tableViewInsetGroupedSectionFooterDefaultHeight: CGFloat { get set }
    
    var tableViewInsetGroupedSectionHeaderContentInset: UIEdgeInsets { get set }
    var tableViewInsetGroupedSectionFooterContentInset: UIEdgeInsets { get set }
    
    
    // MARK: - UIWindowLevel
    
    var windowLevelQMUIAlertView: CGFloat { get set }
    var windowLevelQMUIConsole: CGFloat { get set }
    
    // MARK: - QMUILog
    var shouldPrintDefaultLog: Bool { get set }
    var shouldPrintInfoLog: Bool { get set }
    var shouldPrintWarnLog: Bool { get set }
    var shouldPrintQMUIWarnLogToConsole: Bool { get set }
    
    // MARK: - QMUIBadge
    var badgeBackgroundColor: UIColor { get set }
    var badgeTextColor: UIColor { get set }
    
    var badgeFont: UIFont { get set }
    var badgeContentEdgeInsets: UIEdgeInsets { get set }
    var badgeOffset: CGPoint { get set }
    var badgeOffsetLandscape: CGPoint { get set }
    var updatesIndicatorColor: UIColor { get set }
    var updatesIndicatorSize: CGSize { get set }
    var updatesIndicatorOffset: CGPoint { get set }
    var updatesIndicatorOffsetLandscape: CGPoint { get set }
    
    // MARK: - Others
    var automaticCustomNavigationBarTransitionStyle: Bool { get set }
    var supportedOrientationMask: Bool { get set }
    var automaticallyRotateDeviceOrientation: Bool { get set }
    var statusbarStyleLightInitially: Bool { get set }
    var needsBackBarButtonItemTitle: Bool { get set }
    var hidesBottomBarWhenPushedInitially: Bool { get set }
    var preventConcurrentNavigationControllerTransitions: Bool { get set }
    var navigationBarHiddenInitially: Bool { get set }
    var shouldFixTabBarTransitionBugInIPhoneX: Bool { get set }
    var shouldFixTabBarButtonBugForAll: Bool { get set }
    var shouldFixTabBarSafeAreaInsetsBug: Bool { get set }
    var shouldFixSearchBarMaskViewLayoutBug: Bool { get set }
    var sendAnalyticsToQMUITeam: Bool { get set }
    var dynamicPreferredValueForIPad: Bool { get set }
    var ignoreKVCAccessProhibited: Bool { get set }
    var adjustScrollIndicatorInsetsByContentInsetAdjustment: Bool { get set }
}
