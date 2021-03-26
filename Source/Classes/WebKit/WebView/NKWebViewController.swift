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


open class  NKWebViewController: UIViewController, WKScriptMessageHandler {
    
    /** Boolean flag which indicates whether JavaScript alerts are allowed. Default is `true`. */
    open var allowJavaScriptAlerts = true
    open weak var delegate: NKWebViewControllerDelegate?
    open var storedStatusColor: UIBarStyle?
    open var buttonColor: UIColor? = nil
    open var titleColor: UIColor? = nil
    open var closing: Bool! = false
    open var request: URLRequest?
    open var navBarTitle: UILabel! = UILabel()
    open var userDefinedTitle: String? {
        didSet {
            navBarTitle.text = userDefinedTitle
        }
    }
    open var sharingEnabled = true 
    open var toolBarHidden = false
    
    /// 需要使用 Safari 打开的域名
    open var openWithSafariDomains: [String] = []
    
    
    /// 允许跳转的 url，优先级最高
    open var enableNavigationUrls: [String] = []
    
    //MARK: 导航类型是 link
    /// 网页内的链接是否可点击
    open var enableNavigationLink: Bool = true
    
    //MARK: 导航类型是 other
    /// 网页内的其他跳转是否允许
    open var enableNavigationOther: Bool = true
    /// 网页内的不允许其他跳转的域名，优先级更高
    open var disableNavigationOtherDomains: [String] = []
    /// 网页内的允许其他跳转的域名
    open var enableNavigationOtherDomains: [String] = []
    
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
    
    /// 得到 webview response 的处理结果
    open var responseBackHandler: ((WKWebView)->Void)?
    
    /// 打开链接时自定义跳转，如果 return true，将不执行其他动作
    open var customDecideNavigation: ((URL)->Bool)?
    
    
    // MARK: Private Properties
    fileprivate var progressView: UIProgressView!
    fileprivate var ipadToolbar = UIToolbar()
    fileprivate var toolbarContainer: NKWebViewToolbar!
    fileprivate var toolbarHeightConstraint: NSLayoutConstraint!
    fileprivate var toolbarHeight: CGFloat = 44
    fileprivate var navControllerUsesBackSwipe: Bool = false
    fileprivate let refreshControl = UIRefreshControl()
    
    lazy fileprivate var activityIndicator: UIActivityIndicatorView? = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.backgroundColor = .clear
        #if swift(>=4.2)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        #else
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
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
        tempWebView.backgroundColor = .white
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
            let javascript = """
                window.onload = function() {
                    document.addEventListener("click", function(evt) {
                        var tagClicked = document.elementFromPoint(evt.clientX, evt.clientY);
                        window.webkit.messageHandlers.jsMessenger.postMessage(tagClicked.outerHTML.toString());
                    });
                }
                """
            let userScript:WKUserScript =  WKUserScript(source: javascript, injectionTime:.atDocumentStart, forMainFrameOnly: true)
            
            userController.add(self, name: "jsMessenger")
            userController.addUserScript(userScript)
            webCfg.userContentController = userController
            return webCfg
        }
    }
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("detect webview click ")
        delegate?.userContentController?(userContentController, didReceive: message)
    }
    
    ////////////////////////////////////////////////
    public convenience init(urlString: String, sharingEnabled: Bool = true) {
        var urlString = urlString
        if !urlString.hasPrefix("https://") && !urlString.hasPrefix("http://") {
            urlString = "https://"+urlString
        }
        self.init(pageURL: URL(string: urlString)!, sharingEnabled: sharingEnabled)
    }
    
    public convenience init(pageURL: URL, sharingEnabled: Bool = true) {
        self.init(aRequest: URLRequest(url: pageURL), sharingEnabled: sharingEnabled)
    }
    
    public convenience init(aRequest: URLRequest, sharingEnabled: Bool = true) {
        self.init()
        self.sharingEnabled = sharingEnabled
        self.request = aRequest
    }
    
    func loadRequest(_ request: URLRequest?) {
        guard request != nil else {
            return
        }
        if let url = request!.url,
           url.absoluteString.contains("file:"),
           #available(iOS 9.0, *) {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            webView.load(request!)
        }
    }
    
    deinit {
        showLoading(false)
        removeObserver()
        webView.stopLoading()
        webView.uiDelegate = nil;
        webView.navigationDelegate = nil;
    }
    
    ////////////////////////////////////////////////
    // Toolbar
    
    func updateToolbarItems() {
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
            
            let items: NSArray = sharingEnabled ? [fixedSpace, refreshStopBarButtonItem, fixedSpace, backBarButtonItem, fixedSpace, forwardBarButtonItem, fixedSpace, actionBarButtonItem] : [fixedSpace, refreshStopBarButtonItem, fixedSpace, backBarButtonItem, fixedSpace, forwardBarButtonItem]
            
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
            navigationItem.rightBarButtonItems = items.reverseObjectEnumerator().allObjects as? [UIBarButtonItem]
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
    
    
    ////////////////////////////////////////////////
    // Target Actions
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
    fileprivate func backForwardListChanged() {
        if self.navControllerUsesBackSwipe && self.allowsBackForwardNavigationGestures {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = !webView.canGoBack
        }
        backBarButtonItem.isEnabled =  webView.canGoBack
        forwardBarButtonItem.isEnabled = webView.canGoForward
    }
}


//MARK: - UI-progress/error
extension  NKWebViewController {
    
    fileprivate func updateToolbarHidden() {
        if (NKDevice.isIPad()) {
            ipadToolbar.isHidden = toolBarHidden
        } else {
            navigationController?.setToolbarHidden(toolBarHidden, animated: false)
        }
        
        var allBarHeight = toolBarHidden ? topBarHeight : topBarHeight+tabBarHeight
        if NKDevice.isIPad() {  // ipad 只有 top，没有 tab
            allBarHeight = topBarHeight
        }
        let webHeight = NKSCREEN_HEIGHT-allBarHeight
        
        webView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(webHeight)
        }
    }
    
    fileprivate func setupProgressView() {
        if progressView == nil {
            progressView = UIProgressView()
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
    
    fileprivate func setupWebview() {
        view.insertSubview(webView, at: 0)
        webView.frame = view.bounds
    }
    
    fileprivate func progressChanged(_ newValue: NSNumber) {
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
    
    fileprivate func showError(_ errorString: String?) {
        let alertView = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    fileprivate func showLoading(_ animate: Bool) {
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
    }
}

//MARK: - KVO
extension  NKWebViewController {
    fileprivate func addObserver() {
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
    }
    
    fileprivate func removeObserver() {
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


//MARK: - View Lifecycle
extension  NKWebViewController {
    ////////////////////////////////////////////////
    // View Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // 设置edgesForExtendedLayout可以使得 webview 从导航栏bottom 开始布局
        //        edgesForExtendedLayout = []
        view.autoresizingMask = .flexibleHeight
        view.backgroundColor = .white
        setupWebview()
        setupProgressView()
        addObserver()
        loadRequest(request)
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

//MARK: - WKUIDelegate
extension  NKWebViewController: WKUIDelegate {
    
    // Add any desired WKUIDelegate methods here: https://developer.apple.com/reference/webkit/wkuidelegate
    open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url{
            if url.description.lowercased().range(of: "http://") != nil || url.description.lowercased().range(of: "https://") != nil  {
                webView.load(navigationAction.request)
            }
        }
        return nil
    }
    
    
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        if !allowJavaScriptAlerts {
            return
        }
        
        let alertController: UIAlertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction) -> Void in
            completionHandler()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: - WKNavigationDelegate
extension  NKWebViewController: WKNavigationDelegate {
    
    // 1、4 在发送请求之前，决定是否跳转
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return
        }
        let hostAddress = navigationAction.request.url?.host
        
        // 1.To connnect app store
        if hostAddress == "itunes.apple.com" {
            if UIApplication.shared.canOpenURL(navigationAction.request.url!) {
                UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
        }
        
        // 2. handle other scheme
        let url_elements = url.absoluteString.components(separatedBy: ":")
        
        switch url_elements[0] {
        case "tel":
            openCustomApp(urlScheme: "telprompt://", additional_info: url_elements[1])
            decisionHandler(.cancel)
            return
        case "sms":
            openCustomApp(urlScheme: "sms://", additional_info: url_elements[1])
            decisionHandler(.cancel)
            return
        case "mailto":
            openCustomApp(urlScheme: "mailto://", additional_info: url_elements[1])
            decisionHandler(.cancel)
            return
        default:
            //print("Default")
            break
        }
        
        //  NKTODO: 增加支持打开外部 URL 的域名集合，提供一个属性对外暴露
        // 3. handle other url
        if customDecideNavigation != nil {
            let isReturn = customDecideNavigation!(url)
            if isReturn {
                decisionHandler(.cancel)
                return
            }
        }
        
        var containOpenWithSafariUrl = false
        if let rootDomain = url.rootDomain {
            for domain in openWithSafariDomains {
                if domain.contains(rootDomain) {
                    containOpenWithSafariUrl = true
                    break
                }
            }
        }
        
        // 使用 Safari 打开网页
        if (enableNavigationLink && containOpenWithSafariUrl) {
            if UIApplication.shared.canOpenURL(url) {
                print("Redirected to browser. No need to open it locally: \(url)")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
        }
        
        if enableNavigationUrls.count > 0 {
            var pass = false
            
            let components = url.absoluteString.components(separatedBy: "?")
            if let urlString = components.first {
                for enableUrl in enableNavigationUrls {
                    if urlString.contains(enableUrl) {
                        pass = true
                        break
                    }
                }
                if pass {
                    print("Enable navigation urls Open : \(url)")
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        if navigationAction.navigationType == .linkActivated {
            // 对网页内链接跳转进行屏蔽
            if(!enableNavigationLink) {
                print("Disable open link : \(url)")
                decisionHandler(.cancel)
                return
            }
        } else if navigationAction.navigationType == .other {
            // 对网页内其他跳转进行屏蔽，刚加载网页时 targetRequstUrl 为空。所以要规避掉
            if #available(iOS 14.0, *) {
                if let targetRequstUrl = navigationAction.targetFrame?.request.url,
                   targetRequstUrl.absoluteString.isNotEmpty {
                    if enableNavigationOther {
                        if disableNavigationOtherDomains.count > 0 {
                            // 1. 是否包含了不允许跳转的
                            var containDisableOtherDomain = false
                            if let rootDomain = url.rootDomain {
                                // 获取当前根域名，判断是否要允许加载 navigationType == .other 的情况
                                for domain in disableNavigationOtherDomains {
                                    if domain.contains(rootDomain) {
                                        containDisableOtherDomain = true
                                        break
                                    }
                                }
                            }
                            
                            if containDisableOtherDomain {
                                print("In disable domains open other: \(url)")
                                decisionHandler(.cancel)
                                return
                            }
                        }
                        
                        if enableNavigationOtherDomains.count > 0 {
                            // 2. 当前域名是否包含在允许跳转的
                            var containNavigationOtherDomain = false
                            if let rootDomain = url.rootDomain {
                                // 获取当前根域名，判断是否要允许加载 navigationType == .other 的情况
                                for domain in enableNavigationOtherDomains {
                                    if domain.contains(rootDomain) {
                                        containNavigationOtherDomain = true
                                        break
                                    }
                                }
                            }
                            
                            if(!containNavigationOtherDomain) {
                                print("Not in enable domains open other : \(url)")
                                decisionHandler(.cancel)
                                return
                            }
                        }
                    } else {
                        print("Disable open other : \(url)")
                        decisionHandler(.cancel)
                        return
                    }
                }
            }
        }
        
        print("Open it locally: \(url)")
        decisionHandler(.allow)
    }
    
    
    // 2 页面开始加载时调用
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoading(true)
        if responseBackHandler != nil {
            webView.isHidden = true
        }
        delegate?.webViewController?(self, didStartLoading: webView.url)
        updateToolbarItems()
    }
    
    
    // 3、5 在收到响应后，决定是否跳转
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if responseBackHandler != nil {
            responseBackHandler!(webView)
        }
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                NKCookieStore.shared.addCookie(cookie)
            }
        }
        delegate?.webViewController?(self, decidePolicyForNavigationResponse: navigationResponse, decisionHandler: decisionHandler)
        decisionHandler(.allow)
    }
    
    
    // 6 页面加载完成之后调用
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showLoading(false)
        refreshControl.endRefreshing()
        
        if responseBackHandler != nil {
            webView.isHidden = false
        }
        delegate?.webViewController?(self, didFinishLoading: webView.url, success: true)
        if userDefinedTitle == nil {
            webView.evaluateJavaScript("document.title", completionHandler: {(response, error) in
                if error == nil {
                    self.navBarTitle.text = response as! String?
                    self.navBarTitle.sizeToFit()
                    self.updateToolbarItems()
                }
            })
            
            webView.evaluateJavaScript("document.getElementById('article-title').textContent") { (response, error) -> Void in
                if error == nil {
                    print(response)
                    self.navBarTitle.text = response as! String?
                    self.navBarTitle.sizeToFit()
                    self.updateToolbarItems()
                }
            }
        }
    }
    
    /// 当内容开始返回时调用
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    // 页面加载失败时调用
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showLoading(false)
        refreshControl.endRefreshing()
        
        delegate?.webViewController?(self, didFinishLoading: webView.url, success: false)
        updateToolbarItems()
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showLoading(false)
        refreshControl.endRefreshing()
        
        delegate?.webViewController?(self, didFinishLoading: webView.url, success: false)
        updateToolbarItems()
    }
    
    func openCustomApp(urlScheme: String, additional_info:String){
        if let requestUrl: URL = URL(string:"\(urlScheme)"+"\(additional_info)") {
            let application:UIApplication = UIApplication.shared
            if application.canOpenURL(requestUrl) {
                application.open(requestUrl, options: [:], completionHandler: nil)
            }
        }
    }
}
