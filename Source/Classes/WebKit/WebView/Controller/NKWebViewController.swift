//
//   NKWebViewController.swift
//
//  Created by Myles Ringle on 24/06/2015.
//  Transcribed from code used in SVWebViewController.
//  Copyright (c) 2015 Myles Ringle & Sam Vermette. All rights reserved.
//

import WebKit
import SnapKit

public enum NKWebViewControllerProgressIndicatorStyle {
    case activityIndicator
    case progressView
    case both
    case none
}

@objc public protocol NKWebViewControllerDelegate: class {
    @objc optional func webViewController(_ webViewController: NKWebViewController, didChangeURL newURL: URL?)
    @objc optional func webViewController(_ webViewController: NKWebViewController, didChangeTitle newTitle: NSString?)
    @objc optional func webViewController(_ webViewController: NKWebViewController, didStartLoading loadedURL: URL?)
    @objc optional func webViewController(_ webViewController: NKWebViewController, didFinishLoading loadedURL: URL?, success: Bool)
    @objc optional func webViewController(_ webViewController: NKWebViewController, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    @objc optional func webViewController(_ webViewController: NKWebViewController, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void)
    @objc optional func webViewController(_ webViewController: NKWebViewController, didReceiveAuthenticationChallenge challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    
    /// 监听 JS 的回调
    /// - Parameters:
    ///   - userContentController: <#userContentController description#>
    ///   - message: <#message description#>
    @objc optional func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}


open class  NKWebViewController: UIViewController {
    
    /** Boolean flag which indicates whether JavaScript alerts are allowed. Default is `true`. */
    open var allowJavaScriptAlerts = true
    open weak var delegate: NKWebViewControllerDelegate?
    open var storedStatusColor: UIBarStyle?
    open var buttonColor: UIColor? = nil
    open var titleColor: UIColor? = nil
    open var closing: Bool! = false
    open var request: URLRequest?
    open var weburl: String?
    open var htmlString: String?
    open var navBarTitle: UILabel! = UILabel()
    open var readerModeCache: ReaderModeCache?
    
    open var isFirstLoading: Bool = false
    
    open var userDefinedTitle: String? {
        didSet {
            navBarTitle.text = userDefinedTitle
        }
    }
    
    internal var contentScriptManager = TabContentScriptManager()
    
    /// 文字缩放
    open var textSzieScalePercent: Int = 100 {
        didSet {
            guard textSzieScalePercent != oldValue else {
                return
            }
            self.textSzieScale()
        }
    }
    
    // Use computed property so @available can be used to guard `noImageMode`.
    open var noImageMode: Bool = false {
        didSet {
            guard noImageMode != oldValue else {
                return
            }
            self.execuNoImageModeChanage()
        }
    }

    open var nightMode: Bool = false {
        didSet {
            guard nightMode != oldValue else {
                return
            }
            self.execuDarkModeChanage(completion: nil)
        }
    }
    
    
    /// 暂时还不支持
    open var readerMode: Bool = false {
        didSet {
            guard readerMode != oldValue else {
                return
            }
//            self.execuReaderModeChange()
        }
    }
    
    ///  导航栏右上角按钮
    open var navRightItems: [UIBarButtonItem]? = []
    
    open var sharingEnabled = true 
    open var toolBarHidden = false
    
    /// scroll hidden toolbar
    open var scrollToolBarHidden = true

    open var lastOffsetY :CGFloat = 0

    
    ///  内容过滤，JSON 格式
    ///  参考：https://developer.apple.com/documentation/safariservices/creating_a_content_blocker#//apple_ref/doc/uid/TP40016265-CH2-SW5
    open var contentRules: String?
    
    /// 需要使用 Safari 打开的域名，不受"屏蔽跳转与允许跳转"影响
    open var openWithSafariDomains: [String] = []
    
    /// 打开链接时自定义跳转，如果 return true，将不执行其他动作，不受"屏蔽跳转与允许跳转"影响
    open var customDecideNavigation: ((_ webView: WKWebView, _ navigationAction: WKNavigationAction)->Bool)?
    
    /** The style of progress indication visualization. Can be one of four values: .ActivityIndicator, .ProgressView, .Both, .None*/
    open var progressIndicatorStyle: NKWebViewControllerProgressIndicatorStyle = .both
    
    /** A Boolean value indicating whether horizontal swipe gestures will trigger back-forward list navigations. The default value is false. */
    open var allowsBackForwardNavigationGestures: Bool {
        get {
            return webView.allowsBackForwardNavigationGestures
        }
        set(value) {
            webView.allowsBackForwardNavigationGestures = value
        }
    }
    
    // MARK: Private Properties
    internal var progressView: UIProgressView!
    internal var ipadToolbar = UIToolbar()
    internal var toolbarContainer: NKWebViewToolbar!
    internal var toolbarHeightConstraint: NSLayoutConstraint!
    internal var toolbarHeight: CGFloat = 44
    internal var lastToolbarHeight: CGFloat = 44
    internal var navControllerUsesBackSwipe: Bool = false
    internal let refreshControl = UIRefreshControl()
    
    lazy internal var activityIndicator: UIActivityIndicatorView? = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.backgroundColor = .clear
        #if swift(>=4.2)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        #else
        activityIndicator.activityIndicatorViewStyle = NKThemeProvider.shared.isNight() ? .gray : .whiteLarge
        #endif
        //设置指示器控件的颜色
        activityIndicator.color = UIColor.systemGray
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        
        let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        return activityIndicator
    }()
    
    
    lazy var backBarButtonItem: UIBarButtonItem =  {
        let image = UIImage(nkBundleNamed: "NKWCBackIcon")
        var tempBackBarButtonItem = UIBarButtonItem(image: image,
                                                    style: UIBarButtonItem.Style.plain,
                                                    target: self,
                                                    action: #selector(NKWebViewController.goBackTapped(_:)))
        tempBackBarButtonItem.width = 18.0
        tempBackBarButtonItem.tintColor = self.buttonColor
        return tempBackBarButtonItem
    }()
    
    lazy var forwardBarButtonItem: UIBarButtonItem =  {
        let image = UIImage(nkBundleNamed: "NKWCNextIcon")
        var tempForwardBarButtonItem = UIBarButtonItem(image: image,
                                                       style: UIBarButtonItem.Style.plain,
                                                       target: self,
                                                       action: #selector(NKWebViewController.goForwardTapped(_:)))
        tempForwardBarButtonItem.width = 18.0
        tempForwardBarButtonItem.tintColor = self.buttonColor
        return tempForwardBarButtonItem
    }()
    
    lazy var refreshBarButtonItem: UIBarButtonItem = {
        var tempRefreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh,
                                                       target: self,
                                                       action: #selector(NKWebViewController.reloadTapped(_:)))
        tempRefreshBarButtonItem.tintColor = self.buttonColor
        return tempRefreshBarButtonItem
    }()
    
    lazy var stopBarButtonItem: UIBarButtonItem = {
        var tempStopBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop,
                                                    target: self,
                                                    action: #selector(NKWebViewController.stopTapped(_:)))
        tempStopBarButtonItem.tintColor = self.buttonColor
        return tempStopBarButtonItem
    }()
    
    lazy var actionBarButtonItem: UIBarButtonItem = {
        var tempActionBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action,
                                                      target: self,
                                                      action: #selector(NKWebViewController.actionButtonTapped(_:)))
        tempActionBarButtonItem.tintColor = self.buttonColor
        return tempActionBarButtonItem
    }()
    
    
    lazy open var webView: WKWebView = {
        var tempWebView = WKWebView(frame: .zero, configuration: webConfig)
        tempWebView.uiDelegate = self
        tempWebView.navigationDelegate = self
        tempWebView.backgroundColor = NKThemeProvider.shared.isNight() ? UIColor(hex: "#000000") : .white
        tempWebView.scrollView.delegate = self
        tempWebView.translatesAutoresizingMaskIntoConstraints = false
        // after done with setup the `webView`:
        refreshControl.addTarget(self, action: #selector(reloadTapped(_:)), for: .valueChanged)
        tempWebView.scrollView.addSubview(refreshControl)
        return tempWebView;
    }()
    
    var webConfig:WKWebViewConfiguration {
        get {
            let webCfg:WKWebViewConfiguration = WKWebViewConfiguration()
            let userController:WKUserContentController = WKUserContentController()
            let messageJS = """
                window.onload = function() {
                    document.addEventListener("click", function(evt) {
                        var tagClicked = document.elementFromPoint(evt.clientX, evt.clientY);
                        window.webkit.messageHandlers.jsMessenger.postMessage(tagClicked.outerHTML.toString());
                    });
                }
                """
            // atDocumentStart: 意思是网页中的元素标签创建刚出来的时候，但是还没有内容。该时机适合通过注入脚本来添加元素标签等操作。（注意：此时<head>和<body>等标签都还没有出现）
            let messageUserScript:WKUserScript = WKUserScript(source: messageJS, injectionTime:.atDocumentStart, forMainFrameOnly: true)
            userController.add(self, name: "jsMessenger")
            userController.addUserScript(messageUserScript)
                        
            webCfg.userContentController = userController
            return webCfg
        }
    }
    

    // MARK: - Init by url
    public convenience init(urlString: String,
                            sharingEnabled: Bool = true,
                            darkMode: Bool = false,
                            contentRules: String?) {
        var urlString = urlString
        if !urlString.hasPrefix("https://") && !urlString.hasPrefix("http://") {
            urlString = "https://"+urlString
        }
        self.init(pageURL: URL(string: urlString)!, sharingEnabled: sharingEnabled, darkMode: darkMode, contentRules: contentRules)
    }
    
    public convenience init(pageURL: URL,
                            sharingEnabled: Bool = true,
                            darkMode: Bool = false,
                            contentRules: String?) {
        self.init(aRequest: URLRequest(url: pageURL), sharingEnabled: sharingEnabled, darkMode:darkMode, contentRules: contentRules)
    }
    
    public convenience init(aRequest: URLRequest,
                            sharingEnabled: Bool = true,
                            darkMode: Bool = false,
                            contentRules: String?) {
        self.init()
        self.sharingEnabled = sharingEnabled
        self.request = aRequest
        self.weburl = aRequest.url?.absoluteString
        self.readerModeCache = DiskReaderModeCache.sharedInstance
        self.contentRules = contentRules
        self.nightMode = darkMode
    }

    // MARK: - Init by html string
    public convenience init(htmlString: String?,
                            sharingEnabled: Bool = true,
                            darkMode: Bool = false,
                            contentRules: String?) {
        self.init()
        self.sharingEnabled = sharingEnabled
        self.htmlString = htmlString
        self.contentRules = contentRules
        self.readerModeCache = DiskReaderModeCache.sharedInstance
        self.nightMode = darkMode
    }

    //MARK: - load method
    func beginLoadWebView() {
        isFirstLoading = true
        if htmlString != nil && htmlString!.isNotEmpty {
            loadHtmlString()
        } else {
            loadRequest(request)
        }
        execuDarkModeChanage()
    }
    
    func clearWebView() {
        guard view != nil else {
            return
        }
        guard webView != nil else {
            return
        }
        webView.stopLoading()
        webView.uiDelegate = nil;
        webView.navigationDelegate = nil;
    }
    
    deinit {
        showLoading(false)
        removeObserver()
        clearWebView()
    }
    
    ////////////////////////////////////////////////
    // MARK: - Toolbar
    public func updateToolbarItems() {
        if toolBarHidden {
            return
        }
        backForwardListChanged()
        let refreshStopBarButtonItem: UIBarButtonItem = webView.isLoading ? stopBarButtonItem : refreshBarButtonItem

        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        if (NKDevice.isIPad()) {
            let toolbarWidth: CGFloat = 250.0
            fixedSpace.width = 35.0
            
            var items = sharingEnabled ? [fixedSpace, refreshStopBarButtonItem, fixedSpace,forwardBarButtonItem  , fixedSpace,backBarButtonItem , fixedSpace, actionBarButtonItem] : [fixedSpace, refreshStopBarButtonItem, fixedSpace, forwardBarButtonItem, fixedSpace, backBarButtonItem]
            if let addMore = self.navRightItems {
                if addMore.count > 0 {
                    items.insert(contentsOf: addMore, at: 0)
                }
            }
            
            ipadToolbar.frame =  CGRect(x: 0.0, y: 0.0, width: toolbarWidth, height: toolbarHeight)
            if !closing {
                ipadToolbar.items = items as? [UIBarButtonItem]
                if presentingViewController == nil {
                    if let barTintColor = navigationController?.navigationBar.barTintColor {
                        ipadToolbar.barTintColor = barTintColor
                    }
                }
                else {
                    if let barStyle = navigationController?.navigationBar.barStyle {
                        ipadToolbar.barStyle = barStyle
                    }
                }
                if let barTintColor = navigationController?.navigationBar.barTintColor {
                    ipadToolbar.barTintColor = barTintColor
                }
            }
            navigationItem.rightBarButtonItems = items
        }
        else {
            let items: NSArray = sharingEnabled ? [fixedSpace, backBarButtonItem, flexibleSpace, forwardBarButtonItem, flexibleSpace, refreshStopBarButtonItem, flexibleSpace, actionBarButtonItem, fixedSpace] : [fixedSpace, backBarButtonItem, flexibleSpace, forwardBarButtonItem, flexibleSpace, refreshStopBarButtonItem, fixedSpace]

            if let navigationController = navigationController, !closing {
                if presentingViewController == nil {
                    navigationController.toolbar.barTintColor = navigationController.navigationBar.barTintColor
                }
                else {
                    navigationController.toolbar.barStyle = navigationController.navigationBar.barStyle
                }
                navigationController.toolbar.tintColor = navigationController.navigationBar.tintColor
                toolbarItems = items as? [UIBarButtonItem]
            }
        }
    }

    func refreshIphonToolbarItems() {

    }

    // MARK: - Target Actions
    open func goBack() {
        webView.goBack()
    }
    
    open func goForward() {
        webView.goBack()
    }
    
    open func reload() {
        webView.reload()
    }
    
    @objc func goBackTapped(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    @objc func goForwardTapped(_ sender: UIBarButtonItem) {
        goForward()
    }
    
    @objc func reloadTapped(_ sender: UIBarButtonItem) {
        reload()
    }
    
    @objc func stopTapped(_ sender: UIBarButtonItem) {
        webView.stopLoading()
        updateToolbarItems()
    }
    
    @objc func actionButtonTapped(_ sender: AnyObject) {
        
        if let url: URL = ((webView.url != nil) ? webView.url : request?.url) {
            let activities: NSArray = [NKWebViewControllerActivitySafari(),  NKWebViewControllerActivityChrome()]
            
            if url.absoluteString.hasPrefix("file:///") {
                let dc: UIDocumentInteractionController = UIDocumentInteractionController(url: url)
                dc.presentOptionsMenu(from: view.bounds, in: view, animated: true)
            }
            else {
                let activityController: UIActivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: activities as? [UIActivity])
                
                if floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 && UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    let ctrl: UIPopoverPresentationController = activityController.popoverPresentationController!
                    ctrl.sourceView = view
                    ctrl.barButtonItem = sender as? UIBarButtonItem
                }
                
                present(activityController, animated: true, completion: nil)
            }
        }
    }
    
    ////////////////////////////////////////////////
    
    @objc func doneButtonTapped() {
        closing = true
        UINavigationBar.appearance().barStyle = storedStatusColor!
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Back gesture
extension  NKWebViewController {
    internal func backForwardListChanged() {
        if self.navControllerUsesBackSwipe && self.allowsBackForwardNavigationGestures {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = !webView.canGoBack
        }
        backBarButtonItem.isEnabled =  webView.canGoBack
        forwardBarButtonItem.isEnabled = webView.canGoForward
    }
}


//MARK: - UI-progress/error
extension  NKWebViewController {
    
    internal func updateToolbarHidden() {
        if (NKDevice.isIPad()) {
            ipadToolbar.isHidden = toolBarHidden
            webView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
            }
        } else if NKDevice.isIPhone() {
            // 保留先前，用于比较
            let lastHeight = lastToolbarHeight

            var curerntToolBarHeght: CGFloat = 0
            if !toolBarHidden {
                curerntToolBarHeght = toolbarHeight
            }
            if NKDevice.isIPad() {
                curerntToolBarHeght = 0
            }
            // 本来就是空数组
            if NKDevice.isIPhone()  && toolbarItems == nil {
                curerntToolBarHeght = 0
            }
            lastToolbarHeight = curerntToolBarHeght

            var needUpdate = false
            if lastHeight != curerntToolBarHeght {
//                NKlogger.debug("need update now!!!")
                needUpdate = true
            }

            if needUpdate {
                webView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(0)
                    make.top.equalTo(0)
                    make.bottom.equalToSuperview().offset(-curerntToolBarHeght)
                }

                // Fix problem of WebView content height not fitting WebViews frame height
                self.navigationController?.setToolbarHidden(self.toolBarHidden, animated: true)
                UIView.animate(withDuration: 0.75) {
                    self.webView.evaluateJavaScript("document.documentElement.scrollHeight = \(self.webView.height); var toobar = document.getElementsByClassName('H5DocReader-module_toolbar_wpMQA')[0]; toobar.style.bottom = '0';") { (response, error) in
//                        NKlogger.debug("update done now! webview height: \(self.webView.height)")
                    }
                }
            }
        }
    }
    
    internal func setupProgressView() {
        if progressView == nil {
            progressView = UIProgressView()
            progressView.tintColor = NKThemeProvider.shared.currentTheme.tintColor
            progressView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(progressView)
            
            let safeInsetTop = self.view.safeAreaInsets.top;
            progressView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.height.equalTo(2)
                make.top.equalTo(safeInsetTop)
            }
        }
    }
    
    internal func setupWebview() {
        view.insertSubview(webView, at: 0)
        webView.frame = view.bounds
    }
    
    internal func progressChanged(_ newValue: NSNumber) {
        progressView.progress = newValue.floatValue
        if progressView.progress == 1 {
            progressView.progress = 0
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.progressView.alpha = 0
            })
        } else if progressView.alpha == 0 {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.progressView.alpha = 1
            })
        }
    }
    
    internal func showError(_ errorString: String?) {
        let alertView = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    internal func showLoading(_ animate: Bool) {
        /*
        guard view != nil else {
            return
        }
        guard activityIndicator != nil else {
            return
        }
        UIApplication.shared.setIndicator(visible: animate)
        if animate {
            if (progressIndicatorStyle == .activityIndicator) || (progressIndicatorStyle == .both) {
                activityIndicator?.startAnimating()
            }
        } else if activityIndicator != nil {
            if (progressIndicatorStyle == .activityIndicator) || (progressIndicatorStyle == .both) {
                activityIndicator?.stopAnimating()
            }
        }
         */
    }
}

//MARK: - KVO
extension  NKWebViewController {
    internal func addObserver() {
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
    }
    
    internal func removeObserver() {
        guard view != nil else {
            return
        }
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "URL")
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "loading")
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {return}
        switch keyPath {
        case "estimatedProgress":
            if (progressIndicatorStyle == .progressView) || (progressIndicatorStyle == .both) {
                if let newValue = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                    progressChanged(newValue)
                }
            }
        case "URL":
            delegate?.webViewController?(self, didChangeURL: webView.url)
        case "title":
            delegate?.webViewController?(self, didChangeTitle: webView.title as NSString?)
        case "loading":
            if let val = change?[NSKeyValueChangeKey.newKey] as? Bool {
                if !val {
                    showLoading(false)
                    updateToolbarItems()
                    delegate?.webViewController?(self, didFinishLoading: webView.url, success: false)
                }
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

// MARK: - scroll
/*
 willBeginDragging
 DidScroll
 willEndDragging
 DidEndDragging
 willBeginDecelerating
 DidScroll
 DidEndDecelerating
 */
extension  NKWebViewController: UIScrollViewDelegate {
    
    func scrollToUp() {
        if NKDevice.isIPhone() && scrollToolBarHidden {
            toolBarHidden = false
            updateToolbarHidden()
        }
    }

    func scrollToDown() {
        if NKDevice.isIPhone() && scrollToolBarHidden {
            toolBarHidden = true
            updateToolbarHidden()
        }
    }

    //scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
            scrollToUp()
        }else {
            scrollToDown()
        }
    }

    // 当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastOffsetY = scrollView.contentOffset.y

    }

    // 滑动scrollView，并且手指离开时执行。一次有效滑动，只执行一次。
    // 当pagingEnabled属性为YES时，不调用，该方法
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }

    // 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
    // decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }

    // 滑动减速时调用该方法。
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let hide = scrollView.contentOffset.y > self.lastOffsetY

    }

    // 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }

    // 当滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
}

// MARK: - View Lifecycle
extension  NKWebViewController {
    ////////////////////////////////////////////////
    // View Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // 设置edgesForExtendedLayout可以使得 webview 从导航栏bottom 开始布局
        //        edgesForExtendedLayout = []
        view.autoresizingMask = .flexibleHeight
        view.backgroundColor = NKThemeProvider.shared.isNight() ? UIColor(hex: "#000000") : .white
        addUserScript()
        setupWebview()
        setupProgressView()
        addObserver()
        beginLoadWebView()
        setupReaderModeCache()
    }

    
    override open func viewWillAppear(_ animated: Bool) {
        assert(self.navigationController != nil, "NKWebViewController needs to be contained in a UINavigationController. If you are presenting NKWebViewController modally, use NKModalWebViewController instead.")
        updateToolbarItems()
        navBarTitle.backgroundColor = UIColor.clear
        if presentingViewController == nil {
            if let titleAttributes = navigationController!.navigationBar.titleTextAttributes {
                navBarTitle.textColor = titleAttributes[.foregroundColor] as? UIColor
            }
        }
        else {
            navBarTitle.textColor = self.titleColor
        }
        navBarTitle.shadowOffset = CGSize(width: 0, height: 1);
        navBarTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 17.0)
        navBarTitle.textAlignment = .center
        navigationItem.titleView = navBarTitle;
        super.viewWillAppear(true)
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            self.navigationController?.setToolbarHidden(false, animated: false)
        }
        else if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateToolbarHidden()
        if let navVC = self.navigationController {
            if let gestureRecognizer = navVC.interactivePopGestureRecognizer {
                navControllerUsesBackSwipe = gestureRecognizer.isEnabled
            } else {
                navControllerUsesBackSwipe = false
            }
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setToolbarHidden(false, animated: true)
        if NKDevice.isIPad() || NKDevice.isIPhone() {
            // 都要隐藏 toolbar
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if navControllerUsesBackSwipe {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        webView.stopLoading()
    }
}
