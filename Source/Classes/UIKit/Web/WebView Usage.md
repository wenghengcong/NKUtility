

#  webview

以https://github.com/meismyles/SwiftWebVC为原型开发

TODO: 
1. 将 toolbar 抽出
2. 支持 JS
3. 支持操作 cookies



# 指示符
https://github.com/3lvis/Networking#updating-the-network-activity-indicator
https://github.com/Alamofire/AlamofireNetworkActivityIndicator

最后采用：https://github.com/futuretap/FTLinearActivityIndicator
不过使用后，没有出现指示符

```swift

// statusbar indicator
UIApplication.shared.isNetworkActivityIndicatorVisible = true

// 单独 indicator
var standAloneIndicator: FTLinearActivityIndicator?
func toggleStandAlone(_ sender: Any) {
    guard let standAloneIndicator = standAloneIndicator else {return}
    
    if standAloneIndicator.isAnimating {
        standAloneIndicator.stopAnimating()
    } else {
        standAloneIndicator.startAnimating()
    }
}

// 隐藏状态栏
func toggleStatusBar(_sender: Any) {
    statusBarHidden = !statusBarHidden
    setNeedsStatusBarAppearanceUpdate()
}

override var prefersStatusBarHidden: Bool {
    get {
        return statusBarHidden
    }
}

```

