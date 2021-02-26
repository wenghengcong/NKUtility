#  适配要点

## 适配 iPad
1. 注意判断是否是 iPad 屏幕，如果是 iPad 屏幕，将所有元素扩展，且最大扩展倍数限定为 1.5 倍合适
2. 横竖屏切换，注意适配。横竖屏切换会调用。
```
public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    tableView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    tableView.reloadData()
}
```
3. 横竖屏时，根据 screen 中获取的width、height并不是实际用的。所以要根据是否是横屏返回
```
static var mainWidth: CGFloat {
    if NKDevice.Screen.isLandscape() {
        return mainSize.height
    }
    return mainSize.width
}
```


# 横屏支持
1. 全局配置
在 Project 中General->Deployment Info，这个设置和在 info.plist 中设置一致。
```
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
```

2. UIApplicationDelegate 中设置

该设置的优先级要高于 1
```
func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return .all
}
```

3. 单独在页面设置
需要注意的是，单独在页面中设置，页面遵循其视图层级上层的配置。
所以你需要在根控制器设置如下，否则下层级中的控制器就算设置也无效
```
public override var shouldAutorotate: Bool {
    return true
}

public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .all
}

public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .portrait
}
```

跳转的页面是模态页面，还是正常的 push 跳转，假如是模态，实现上面方法即可。
假如是 push 时，要求其 navigation controller 也要支持。而且，假如navigation controller的 root controller 是 tabbarcontroller，那么tabbarcontroller也要支持。

如下：
```
// tabbarcontroller 
override var shouldAutorotate: Bool {
    return self.selectedViewController?.shouldAutorotate ?? true
}

override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return self.selectedViewController?.supportedInterfaceOrientations ?? .all
}

// 父类 navigation controller
override var shouldAutorotate: Bool {
    return self.topViewController?.shouldAutorotate ?? true
}

override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return self.topViewController?.supportedInterfaceOrientations ?? .all
}

// 之类当前的页面
override var shouldAutorotate: Bool {
    return ture
}

override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    // 返回的需要和 info.plist 中的配置有交集，否则会crash
    return .all
}

```

4. 强制横屏
参考：https://www.jianshu.com/p/7108620fee35
方法一：
```
override var shouldAutorotate: Bool {
    //关闭自动旋转
    return false
}

override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    // 返回的需要和 info.plist 中的配置有交集，否则会crash
    return .landscapeLeft
}
```

方法二：实现 view 的 transform
