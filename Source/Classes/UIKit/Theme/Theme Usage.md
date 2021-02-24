#  状态栏

## 全局配置
如果要启用全局的配置
UIApplication.shared.theme_setStatusBarStyle(picker, animated: true)


需要在 Info.plist 中关闭页面的配置：
View controller-based status bar appearance 设置为 NO


##  页面配置
页面开启配置的方法如下：
```
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNeedsStatusBarAppearanceUpdate()
}

override var preferredStatusBarStyle: UIStatusBarStyle {
    return NKThemeProvider.shared.viewControllerStatusBar()
}
```

# 导航栏
## 导航栏颜色配置
```
navigationBar.theme_barTintColor = NKThemeProvider.barBackgroundColor
navigationBar.isTranslucent = false
```

## 导航栏标题


# 富文本
## 富文本
```
let titleAttributes = NKThemeProvider.titleTextColor.map { hexString in
    return [
        NSAttributedString.Key.foregroundColor: UIColor(hex: hexString)
    ]
}
navigationBar.theme_titleTextAttributes = ThemeStringAttributesPicker.pickerWithAttributes(titleAttributes)
navigationBar.theme_largeTitleTextAttributes = ThemeStringAttributesPicker.pickerWithAttributes(titleAttributes)
```


另外，根据 theme 来创建：
```
let allThemes: [NSAttributedString] = NKThemeProvider.shared.themes.map { theme in
    let builder = NKAttributedStringBuilder()
    builder.defaultAttributes = [
        .textColor(theme.mainTextColor),
        .font( NKSysFont5 ),
        .alignment(.center),
    ]

    builder
        .text("\(count)", attributes: [.textColor(theme.titleTextColor), .font(NKBoldSysFont18)])
        .newline()
        .newline()
        .text(suffix, attributes: [.textColor(theme.mainTextColor), .font(NKSysFont12)])
    return builder.attributedString
}

let followAttributedTitle = ThemeAttributedStringPicker.pickerWithAttributedStrings(allThemes)
followerBtn.theme_setAttributedTitle(followAttributedTitle, forState: .normal)
```



# 通知
问题，通知是在主题改变前发出的，所以改变后的通知


```
NotificationCenter.default.addObserver(
    self,
    selector: #selector(refreshViewsWhenThemeChange),
    name: NSNotification.Name(rawValue: ThemeUpdateNotification),
    object: nil
)
```

