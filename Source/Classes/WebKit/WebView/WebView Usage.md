

#  webview

以https://github.com/meismyles/SwiftWebVC为原型开发

TODO: 
1. 将 toolbar 抽出
2. 支持 JS
3. 支持操作 cookies

参考文档：https://juejin.cn/post/6844903669276606472


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


# html 解析
https://github.com/tid-kijyun/Kanna
https://github.com/scinfu/SwiftSoup
https://github.com/cezheng/Fuzi
https://github.com/mattt/Ono


# 加速加载
https://github.com/bernikovich/WebViewWarmUper


# 内容过滤
官方文档
https://developer.apple.com/documentation/safariservices/creating_a_content_blocker#//apple_ref/doc/uid/TP40016265-CH2-SW5

参考下这个项目的实现：https://github.com/AdguardTeam/AdguardForiOS

说明的博客：
https://www.cnblogs.com/zhanggui/p/8260136.html

关于 CSS selector 的写法：
https://www.w3schools.com/css/css_selectors.asp
```
All CSS Simple Selectors
Selector             Example                     Example description    
#id                    #firstname                   Selects the element with id="firstname"
.class                .intro                        Selects all elements with class="intro"
element.class         p.intro                       Selects only <p> elements with class="intro"
*                        *                          Selects all elements
element                 p                           Selects all <p> elements
element,element,..    div, p                        Selects all <div> elements and all <p> elements
````
