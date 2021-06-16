

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


# cookie
https://github.com/Kofktu/WKCookieWebView

# WebAssembly
https://github.com/swiftwasm/JavaScriptKit



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


# 暗黑模式与阅读模式
https://github.com/tsucres/SwiftyMercuryReady       会崩溃
https://github.com/kharrison/CodeExamples/tree/main/DynamicWebKit


https://github.com/PerfectFreeze/PFWebViewController        支持阅读模式


# 离线缓存
https://stackoverflow.com/questions/36246495/swift-ios-cache-wkwebview-content-for-offline-view


# GCDWebServer
https://github.com/swisspol/GCDWebServer

https://www.hangge.com/blog/cache/detail_1555.html#

GCDWebServer 使用详解
https://xiaovv.me/2018/11/30/GCDWebServer-BasicUse/



# JS 
## 工具类库
WKWebViewJavascriptBridge   https://github.com/Lision/WKWebViewJavascriptBridge
JavaScriptKit       https://github.com/alexisakers/JavaScriptKit

## JS
[Inject JavaScript into WKWebView](https://www.appsdeveloperblog.com/inject-javascript-into-wkwebview/) 


# webview
https://github.com/XWebView/XWebView


# headerless wkwebview
https://github.com/mkoehnke/WKZombie    navigate within websites and collect data without the need of User Interface or API, also known as Headless browser. It can be used to run automated tests / snapshots and manipulate websites using Javascript.
已经不维护更新了


