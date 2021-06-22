//
//  JSShowDownHandler.swift
//  NKUtility
//
//  Created by Hunt on 2021/6/19.
//

import Foundation
import JavaScriptCore
import WebKit
import SwiftSoup

extension JSShowDownHandler: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
}

public class JSShowDownHandler: NSObject {
    
    public static let shared = JSShowDownHandler()
    
    let webView = WKWebView(frame: CGRect(), configuration: WKWebViewConfiguration())


    public static var markdownToHTMLNotificationName = NSNotification.Name("markdownToHTMLNotification")
    public static var HTMLToMarkdownNotificationName = NSNotification.Name("HTMLTomarkdownNotification")
    
    var jsContext: JSContext!
    
    var wkWebViewBridge: WKWebViewJavascriptBridge!
    
    override init() {
        super.init()
        initializeBridge()
        initializeJS()
        addObserverNoti()
        
        
        // setup webView
        webView.frame = CGRect.zero
        webView.navigationDelegate = self
        
        let bundle = NKUtilityFramework.resourceBundle
        if let ReadabilityJSPath = bundle.path(forResource: "Readability", ofType: "js"), let source = try? NSString(contentsOfFile: ReadabilityJSPath, encoding: String.Encoding.utf8.rawValue) as String {
            let ReadabilityJSScript = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            webView.configuration.userContentController.addUserScript(ReadabilityJSScript)
        }
        webView.load(URLRequest(url: URL(string: "https://www.raywenderlich.com/1227-javascriptcore-tutorial-for-ios-getting-started")!))
    }
    

    func initializeBridge() {
        let webView = WKWebView()
        wkWebViewBridge = WKWebViewJavascriptBridge(webView: webView)
     
        wkWebViewBridge.register(handlerName: "testiOSCallback") { (paramters, callback) in
            print("testiOSCallback called: \(String(describing: paramters))")
            callback?("Response from testiOSCallback")
        }

        wkWebViewBridge.call(handlerName: "testJavascriptHandler", data: ["foo": "before ready"], callback: nil)
    }
    
    func initializeJS() {
        self.jsContext = JSContext()
        
        // Add an exception handler.
        self.jsContext.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception:", exc.toString())
            }
        }
        
        let bundle = NKUtilityFramework.resourceBundle
        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        self.jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
        _ = self.jsContext.evaluateScript("consoleLog")
        if let jsSourcePath = bundle.path(forResource: "showdownFunction", ofType: "js") {
            do {
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                self.jsContext.evaluateScript(jsSourceContents)
                
                // Fetch and evaluate the Snowdown script.
//                let snowdownScript = try String(contentsOf: URL(string: "https://cdn.jsdelivr.net/npm/showdown@1.9.1/dist/showdown.min.js")!)
//                self.jsContext.evaluateScript(snowdownScript)
                
                if let sourcePath = bundle.path(forResource: "showdown.min", ofType: "js") {
                    let sourceContent = try String(contentsOfFile: sourcePath)
                    self.jsContext.evaluateScript(sourceContent)
                }
                
                if let sourcePath = bundle.path(forResource: "Readability", ofType: "js") {
                    let sourceContent = try String(contentsOfFile: sourcePath)
                    self.jsContext.evaluateScript(sourceContent)
                }
                
                if let sourcePath = bundle.path(forResource: "JSDOMParser", ofType: "js") {
                    let sourceContent = try String(contentsOfFile: sourcePath)
                    self.jsContext.evaluateScript(sourceContent)
                }
                
                if let sourcePath = bundle.path(forResource: "jquery3.6.0", ofType: "js") {
                    let sourceContent = try String(contentsOfFile: sourcePath)
                    self.jsContext.evaluateScript(sourceContent)
                }
                
                if let sourcePath = bundle.path(forResource: "purify.min", ofType: "js") {
                    let sourceContent = try String(contentsOfFile: sourcePath)
                    self.jsContext.evaluateScript(sourceContent)
                }
                if let sourcePath = bundle.path(forResource: "mercury-parser", ofType: "js") {
                    let sourceContent = try String(contentsOfFile: sourcePath)
                    self.jsContext.evaluateScript(sourceContent)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        // 将self.markdownToHTMLHandler 方法以 "handleConvertedMarkdown" 的名注册到 JS 环境中
        let htmlResultsHandler = unsafeBitCast(self.markdownToHTMLHandler, to: AnyObject.self)
        self.jsContext.setObject(htmlResultsHandler, forKeyedSubscript: "handleConvertedMarkdown" as (NSCopying & NSObjectProtocol))
//        _ = self.jsContext.evaluateScript("handleConvertedMarkdown")
        
        let markdownResultsHandler = unsafeBitCast(self.HTMLToMarkdownHandler, to: AnyObject.self)
        self.jsContext.setObject(markdownResultsHandler, forKeyedSubscript: "handleConvertedHtml" as (NSCopying & NSObjectProtocol))
//        _ = self.jsContext.evaluateScript("handleConvertedHtml")
    }
    
    func addObserverNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleMarkdownToHTMLNotification(notification:)), name: JSShowDownHandler.markdownToHTMLNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHTMLToMarkdownNotification(notification:)), name: JSShowDownHandler.HTMLToMarkdownNotificationName, object: nil)
    }
    
    // MARK: - Markdown To html
    public func convertMarkdownToHTML(_ markdownString: String) {
        if let functionConvertMarkdownToHTML = self.jsContext.objectForKeyedSubscript("convertMarkdownToHTML") {
            _ = functionConvertMarkdownToHTML.call(withArguments: [markdownString])
        }
    }
    
    
    @objc func handleMarkdownToHTMLNotification(notification: Notification) {
        if let html = notification.object as? String {
            let newContent = "<html><head><style>body { background-color: #3498db; color: #ffffff; } </style></head><body>\(html)</body></html>"
            
        }
    }
    
    let markdownToHTMLHandler: @convention(block) (String) -> Void = { htmlOutput in
        NotificationCenter.default.post(name: JSShowDownHandler.markdownToHTMLNotificationName, object: htmlOutput)
    }
    
    
    // MARK: - Html To Markdown
    public func convertHTMLToMarkdown(_ htmlString: String) {
        
        let myURLString = "https://www.raywenderlich.com/1227-javascriptcore-tutorial-for-ios-getting-started"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        do {
            var myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            let doc = try? SwiftSoup.parse(myHTMLString)
            print("HTML : \(myHTMLString)")
            if let html = try doc?.html(), let functionConvertHTMLToMarkdown = self.jsContext.objectForKeyedSubscript("convertHTMLToMarkdown") {
                var cleanHtml = myHTMLString.trim().lowercased().replacing("<!doctype html>", with: "")
                print("HTML : \(cleanHtml)")
                cleanHtml = """
                    "<div class="c-written-tutorial__content l-block l-block--688"> <p><em>Note</em>: Updated for Xcode 8, iOS 10, and Swift 3 on 24-09-2016</p>
                    <p>Since the introduction of Swift in 2014, its popularity has skyrocketed: according to <a href="http://www.tiobe.com/index.php/content/paperinfo/tpci/index.html">the TIOBE index</a> from February 2016 it&#x2019;s already listed in 16th place. But only a few spaces ahead at number 9, you&#x2019;ll find a language that seems quite the opposite of Swift: JavaScript. Swift puts a lot of effort on compile-time safety, while JavaScript is weakly typed and dynamic.</p>
                    <p>Swift and JavaScript may look different, but there is one important thing that binds them together: you can use them together to make a slick iOS app!</p>
                    <p>In this JavaScriptCore tutorial you&#x2019;ll build an iOS companion app for a web page, reusing parts of its existing JavaScript code. In particular, you&#x2019;ll learn about:</p>
                    <ul>
                    <li>The components of the JavaScriptCore framework.</li>
                    <li>How to invoke JavaScript methods from your iOS code.</li>
                    <li>How to access your native code from JavaScript.</li>
                    </ul>
                    <div class="note">
                    <p>
                    <em>Note</em>: You don&#x2019;t need to be experienced in JavaScript to follow along. If this JavaScriptCore tutorial has piqued your interest in learning the language, <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript">Mozilla Developer Network</a> is an excellent resource for beginners &#x2014; or you can also choose to skip straight to <a href="http://engineering.wix.com/wp-content/uploads/2015/04/mIuuwgx-1024x576.jpg">the good parts</a>. :]
                    </p>
                    </div>
                    <h2 id="toc-anchor-001">Getting Started</h2>
                    <p><a href="https://koenig-media.raywenderlich.com/uploads/2016/04/Showtime-Starter.zip">Download the starter project</a> for this tutorial and unzip it. You&#x2019;ll be greeted by the following folder structure:</p>
                    <ul>
                    <li>
                    <em>Web</em>: Contains the HTML and CSS for the web app that you&#x2019;ll be converting to iOS.</li>
                    <li>
                    <em>Native</em>: The iOS project. This is where you&#x2019;ll make all the changes in this tutorial.</li>
                    <li>
                    <em>js</em>: Contains the JavaScript code used in the project.</li>
                    </ul>
                    <p>The app is named <em>Showtime</em>; you can use it to search for movies on iTunes by price. To see it in action, open <em>Web/index.html</em> in your favorite browser, enter your preferred price, and hit <em>Return</em>:</p>
                    <div id="attachment_124799" class="wp-caption aligncenter">
                    <a href="https://koenig-media.raywenderlich.com/uploads/2016/01/5.jpg"><img src="https://koenig-media.raywenderlich.com/uploads/2016/01/5-700x364.jpg" alt="javascriptcore tutorial" width="700" class="size-large wp-image-124799" srcset="https://koenig-media.raywenderlich.com/uploads/2016/01/5-700x364.jpg 700w, https://koenig-media.raywenderlich.com/uploads/2016/01/5-480x250.jpg 480w, https://koenig-media.raywenderlich.com/uploads/2016/01/5-768x400.jpg 768w, https://koenig-media.raywenderlich.com/uploads/2016/01/5.jpg 1293w" sizes="(max-width: 700px) 100vw, 700px"></a><p class="wp-caption-text">Movie night is ON&#x2026;</p>
                    </div>
                    <p>To test Showtime on iOS, open the Xcode project residing in <em>Native/Showtime</em>. Build and run the app to take a look:</p>
                    <div id="attachment_126876" class="wp-caption aligncenter">
                    <img src="https://koenig-media.raywenderlich.com/uploads/2016/02/Simulator-Screen-Shot-20-Feb-2016-21.25.58-1-281x500.png" alt="javascriptcore tutorial" width="281" class="size-large wp-image-126876" srcset="https://koenig-media.raywenderlich.com/uploads/2016/02/Simulator-Screen-Shot-20-Feb-2016-21.25.58-1-281x500.png 281w, https://koenig-media.raywenderlich.com/uploads/2016/02/Simulator-Screen-Shot-20-Feb-2016-21.25.58-1-180x320.png 180w, https://koenig-media.raywenderlich.com/uploads/2016/02/Simulator-Screen-Shot-20-Feb-2016-21.25.58-1.png 752w" sizes="(max-width: 281px) 100vw, 281px"><p class="wp-caption-text">&#x2026; Or Not?</p>
                    </div>
                    <p>As you can see, the mobile companion isn&#x2019;t quite feature-ready, but you&#x2019;ll fix it shortly. The project already contains some code; feel free to browse through it to get a better idea of what&#x2019;s going on. The app aims to provide a similar experience to the web page: it will display the search results in a collection view.</p>
                    <h2 id="toc-anchor-002">What is JavaScriptCore?</h2>
                    <p>The JavaScriptCore framework provides access to WebKit&#x2019;s JavaScript engine. Originally, the framework had a Mac-only, C API, but iOS 7 and OS X 10.9 shipped with a much nicer Objective-C wrapper. The framework enables powerful interoperability between your Swift/Objective-C and JavaScript code.</p> <p>In this section, you&#x2019;ll take a closer look at the API. Under the hood, JavaScriptCore consists of a couple of key components: <code>JSVirtualMachine</code>, <code>JSContext</code>, and <code>JSValue</code>. Here&#x2019;s how they all fit together.</p>
                    <h3 id="toc-anchor-003">JSVirtualMachine</h3>
                    <p>JavaScript code is executed in a virtual machine represented by the <code>JSVirtualMachine</code> class. You won&#x2019;t normally have to interact with this class directly, but there is one main use case for it: supporting concurrent JavaScript execution. Within a single <code>JSVirtualMachine</code>, it&#x2019;s not possible to execute multiple threads at the same time. In order to support parallelism, you must use multiple virtual machines.</p>
                    <p>Each instance of <code>JSVirtualMachine</code> has its own heap and its own garbage collector, which means that you can&#x2019;t pass objects between virtual machines. A virtual machine&#x2019;s garbage collector wouldn&#x2019;t know how to deal with a value from a different heap.</p>
                    <h3 id="toc-anchor-004">JSContext</h3>
                    <p>A <code>JSContext</code> object represents an execution environment for JavaScript code. It corresponds to a single global object; its web development equivalent would be a <code>window</code> object. Unlike with virtual machines, you are free to pass objects between contexts (given that they reside in the same virtual machine).</p>
                    <h3 id="toc-anchor-005">JSValue</h3>
                    <p><code>JSValue</code> is the primary data type you&#x2019;ll have to work with: it can represent any possible JavaScript value. An instance of <code>JSValue</code> is tied to the <code>JSContext</code> object it lives in. Any value that comes from the context object will be of <code>JSValue</code> type.</p>
                    <p>This diagram shows how each piece of the puzzle works together:</p>
                    <p><img src="https://koenig-media.raywenderlich.com/uploads/2016/02/javascriptcore-700x310.png" alt="javascriptcore tutorial" width="700" class="aligncenter size-large wp-image-126871" srcset="https://koenig-media.raywenderlich.com/uploads/2016/02/javascriptcore-700x310.png 700w, https://koenig-media.raywenderlich.com/uploads/2016/02/javascriptcore-480x213.png 480w, https://koenig-media.raywenderlich.com/uploads/2016/02/javascriptcore-768x340.png 768w, https://koenig-media.raywenderlich.com/uploads/2016/02/javascriptcore.png 1588w" sizes="(max-width: 700px) 100vw, 700px"></p>
                    <p>Now that you have a better understanding about the possible types in the JavaScriptCore framework, it&#x2019;s finally time to write some code.</p>
                    <div id="attachment_124781" class="wp-caption aligncenter">
                    <a href="https://koenig-media.raywenderlich.com/uploads/2016/01/manofhope.png"><img src="https://koenig-media.raywenderlich.com/uploads/2016/01/manofhope-336x320.png" alt="javascriptcore tutorial" width="250" class="size-medium wp-image-124781" srcset="https://koenig-media.raywenderlich.com/uploads/2016/01/manofhope-250x250.png 250w, https://koenig-media.raywenderlich.com/uploads/2016/01/manofhope-32x32.png 32w, https://koenig-media.raywenderlich.com/uploads/2016/01/manofhope-64x64.png 64w, https://koenig-media.raywenderlich.com/uploads/2016/01/manofhope-96x96.png 96w, https://koenig-media.raywenderlich.com/uploads/2016/01/manofhope-128x128.png 128w" sizes="(max-width: 250px) 100vw, 250px"></a><p class="wp-caption-text">Enough theory, let&#x2019;s get to work!</p>
                    </div>
                    <h2 id="toc-anchor-006">Invoking JavaScript Methods</h2>
                    <p>Back in Xcode, expand the <em>Data</em> group in the project navigator and open <em>MovieService.swift</em>. This class will retrieve and process movie results from iTunes. Right now, it&#x2019;s mostly empty; it will be your job to provide the implementation for the method stubs.</p>
                    <p>The general workflow of <code>MovieService</code> will look like the following:</p>
                    <ul>
                    <li>
                    <code>loadMoviesWith(limit:onComplete:)</code> will fetch the movies.</li>
                    <li>
                    <code>parse(response:withLimit:)</code> will reach out to the shared JavaScript code to process the API response.</li>
                    </ul>
                    <p>The first step is to fetch the list of movies. If you&#x2019;re familiar with JavaScript development, you&#x2019;ll know that networking calls typically use <code>XMLHttpRequest</code> objects. This object isn&#x2019;t part of the language itself, however, so you can&#x2019;t use it in the context of an iOS app. Instead, you&#x2019;ll have to resort to native networking code.</p>
                    <p>Within the <code>MovieService</code> class, find the stub for <code>loadMoviesWith(limit:onComplete:)</code> and modify it to match the code below:</p>
                    <pre>
                    func loadMoviesWith(limit: Double, onComplete complete: @escaping ([Movie]) -&gt; ()) {
                      guard let url = URL(string: movieUrl) else {
                        print(&quot;Invalid url format: ;)
                        return
                      }
                      
                      URLSession.shared.dataTask(with: url) { data, _, _ in
                        guard let data = data, let jsonString = String(data: data, encoding: String.Encoding.utf8) else {
                          print(&quot;Error while parsing the response data.&quot;)
                          return
                        }
                        
                        let movies = self.parse(response: jsonString, withLimit: limit)
                        complete(movies)
                      }.resume()
                    }
                    </pre>
                    <p>The snippet above uses the default shared <code>URLSession</code> session to fetch the movies. Before you can pass the response to the JavaScript code, you&#x2019;ll need to provide an execution context for the response. First, import JavaScriptCore by adding the following line of code to the top of <em>MovieService.swift</em>, below the existing UIKit import:</p>
                    <pre>
                    import JavaScriptCore
                    </pre>
                    <p>Then, define the following property in <code>MovieService</code>:</p>
                    <pre>
                    lazy var context: JSContext? = {
                      let context = JSContext()
                      
                      // 1
                      guard let
                        commonJSPath = Bundle.main.path(forResource: &quot;common&quot;, ofType: &quot;js&quot;) else {
                          print(&quot;Unable to read resource files.&quot;)
                          return nil
                      }
                      
                      // 2
                      do {
                        let common = try String(contentsOfFile: commonJSPath, encoding: String.Encoding.utf8)
                        _ = context?.evaluateScript(common)
                      } catch (let error) {
                        print(&quot;Error while processing script file: )&quot;)
                      }
                      
                      return context
                    }()
                    </pre>
                    <p>This defines <code>context</code> as a lazy <code>JSContext</code> property:</p>
                    <ol>
                    <li>First, you load the <em>common.js</em> file from the application bundle, which contains the JavaScript code you want to access.</li>
                    <li>After loading the file, the context object will evaluate its contents by calling <code>context.evaluateScript()</code>, passing in the file contents for the parameter.</li>
                    </ol>
                    <p>Now it&#x2019;s time to invoke the JavaScript methods. Still in <em>MovieService.swift</em>, find the method stub for <code>parse(response:withLimit:)</code>, and add the following code:</p>
                    <pre>
                    func parse(response: String, withLimit limit: Double) -&gt; [Movie] {
                      // 1
                      guard let context = context else {
                        print(&quot;JSContext not found.&quot;)
                        return []
                      }
                      
                      // 2
                      let parseFunction = context.objectForKeyedSubscript(&quot;parseJson&quot;)
                      guard let parsed = parseFunction?.call(withArguments: [response]).toArray() else {
                        print(&quot;Unable to parse JSON&quot;)
                        return []
                      }
                      
                      // 3
                      let filterFunction = context.objectForKeyedSubscript(&quot;filterByLimit&quot;)
                      let filtered = filterFunction?.call(withArguments: [parsed, limit]).toArray()

                      // 4
                      return []
                    }
                    </pre>
                    <p>Taking a look at the process, step by step:</p>
                    <ol>
                    <li>First, you make sure the context object is properly initialized. If there were any errors during the setup (e.g.: <em>common.js</em> was not in the bundle), there&#x2019;s no point in resuming. </li>
                    <li>You ask the context object to provide the <code>parseJSON()</code> method. As mentioned previously, the result of the query will be wrapped in a <code>JSValue</code> object. Next, you invoke the method using <code>call(withArguments:)</code>, where you specify the arguments in an array format. Finally, you convert the JavaScript value to an array.</li>
                    <li>
                    <code>filterByLimit()</code> returns the list of movies that fit the given price limit.</li>
                    <li>So you&#x2019;ve got the list of movies, but there&#x2019;s still one missing piece: <code>filtered</code> holds a <code>JSValue</code> array, and you need to map them to the native <code>Movie</code> type.
                    </li>
                    </ol>
                    <p class="note">
                    <em>Note</em>: You might find the use of <code>objectForKeyedSubscript()</code> a little odd here. Unfortunately, Swift only has access to these raw subscripting methods rather than having them translated into a proper <code>subscript</code> method. Objective-C <i>can</i> use subscripting syntax with square brackets, however.</p> <p>One way to run native code in the JavaScript runtime is to define <em>blocks</em>; they&#x2019;ll be bridged automatically to JavaScript methods. There is, however, one tiny issue: this approach only works with Objective-C blocks, not Swift closures. In order to export a closure, you&#x2019;ll have to perform two tasks:</p>
                    <ul>
                    <li>Annotate the closure with the <code>@convention(block)</code> attribute to bridge it to an Objective-C block.</li>
                    <li>Before you can map the block to a JavaScript method call, you&#x2019;ll need to cast it to an <code>AnyObject</code>.</li>
                    </ul>
                    <p>Switch over to <em>Movie.swift</em> and add the following method to the class:</p>
                    <pre>
                    static let movieBuilder: @convention(block) ([[String : String]]) -&gt; [Movie] = { object in
                      return object.map { dict in
                        
                        guard
                          let title = dict[&quot;title&quot;],
                          let price = dict[&quot;price&quot;],
                          let imageUrl = dict[&quot;imageUrl&quot;] else {
                            print(&quot;unable to parse Movie objects.&quot;)
                            fatalError()
                        }
                        
                        return Movie(title: title, price: price, imageUrl: imageUrl)
                      }
                    }
                    </pre>
                    <p>This closure takes an array of JavaScript objects (represented as dictionaries) and uses them to construct <code>Movie</code> instances.</p>
                    <p>Switch back to <em>MovieService.swift</em>. In <code>parse(response:withLimit:)</code>, replace the <code>return</code> statement with the following code:</p>
                    <pre>
                    // 1
                    let builderBlock = unsafeBitCast(Movie.movieBuilder, to: AnyObject.self)

                    // 2
                    context.setObject(builderBlock, forKeyedSubscript: &quot;movieBuilder&quot; as (NSCopying &amp; NSObjectProtocol)!)
                    let builder = context.evaluateScript(&quot;movieBuilder&quot;)

                    // 3
                    guard let unwrappedFiltered = filtered,
                      let movies = builder?.call(withArguments: [unwrappedFiltered]).toArray() as? [Movie] else {
                        print(&quot;Error while processing movies.&quot;)
                        return []
                    }

                    return movies
                    </pre>
                    <ol>
                    <li>You use Swift&#x2019;s <code>unsafeBitCast(_:to:)</code> function to cast the block to <code>AnyObject</code>.</li>
                    <li>Calling <code>setObject(_:forKeyedSubscript:)</code> on the context lets you load the block into the JavaScript runtime. You then use <code>evaluateScript()</code> to get a reference to your block in JavaScript.</li>
                    <li>The final step is to call your block from JavaScript using <code>call(withArguments:)</code>, passing in the array of <code>JSValue</code> objects as the argument. The return value can be cast to an array of <code>Movie</code> objects.</li>
                    </ol>
                    <p>It&#x2019;s finally time to see your code in action! Build and run. Enter a price in the search field and you should see some results pop up:</p>
                    <div id="attachment_126877" class="wp-caption aligncenter">
                    <img src="https://koenig-media.raywenderlich.com/uploads/2016/02/Simulator-Screen-Shot-19-Feb-2016-21.51.48-1-281x500.png" alt="javascriptcore tutorial" width="281" class="size-large wp-image-126877" srcset="https://koenig-media.raywenderlich.com/uploads/2016/02/Simulator-Screen-Shot-19-Feb-2016-21.51.48-1-281x500.png 281w, https://koenig-media.raywenderlich.com/uploads/2016/02/Simulator-Screen-Shot-19-Feb-2016-21.51.48-1-180x320.png 180w, https://koenig-media.raywenderlich.com/uploads/2016/02/Simulator-Screen-Shot-19-Feb-2016-21.51.48-1.png 752w" sizes="(max-width: 281px) 100vw, 281px"><p class="wp-caption-text">That&#x2019;s more like it!</p>
                    </div>
                    <p>With only a few lines of code, you have a native app up and running that uses JavaScript to parse and filter results! :]</p>
                    <h2 id="toc-anchor-008">Using The JSExport Protocol</h2>
                    <p>The other way to use your custom objects in JavaScript is the <code>JSExport</code> protocol. You have to create a protocol that conforms to <code>JSExport</code> and declare the properties and methods, that you want to expose to JavaScript.</p>
                    <p>For each native class you export, JavaScriptCore will create a prototype within the appropriate <code>JSContext</code> instance. The framework does this on an opt-in basis: by default, no methods or properties of your classes expose themselves to JavaScript. Instead, you must choose what to export. The rules of <code>JSExport</code> are as follows:</p>
                    <ul>
                    <li>For exported instance methods, JavaScriptCore creates a corresponding JavaScript function as a property of the prototype object.</li>
                    <li>Properties of your class will be exported as accessor properties on the prototype.</li>
                    <li>For class methods, the framework will create a JavaScript function on the constructor object.</li>
                    </ul>
                    <p>To see how the process works in practice, switch to <em>Movie.swift</em> and define the following new protocol above the existing class declaration:</p>
                    <pre>
                    import JavaScriptCore

                    @objc protocol MovieJSExports: JSExport {
                      var title: String { get set }
                      var price: String { get set }
                      var imageUrl: String { get set }
                      
                      static func movieWith(title: String, price: String, imageUrl: String) -&gt; Movie
                    }
                    </pre>
                    <p>Here, you specify all the properties you want to export and define a class method to construct <code>Movie</code> objects in JavaScript. The latter is necessary since JavaScriptCore doesn&#x2019;t bridge initializers.</p>
                    <p>It&#x2019;s time to modify <code>Movie</code> to conform to <code>JSExport</code>. Replace the entire class with the following:</p>
                    <pre>
                    class Movie: NSObject, MovieJSExports {
                      
                      dynamic var title: String
                      dynamic var price: String
                      dynamic var imageUrl: String
                      
                      init(title: String, price: String, imageUrl: String) {
                        self.title = title
                        self.price = price
                        self.imageUrl = imageUrl
                      }
                      
                      class func movieWith(title: String, price: String, imageUrl: String) -&gt; Movie {
                        return Movie(title: title, price: price, imageUrl: imageUrl)
                      }
                    }
                    </pre>
                    <p>The class method will simply invoke the appropriate initializer method.</p>
                    <p>Now your class is ready to be used in JavaScript. To see how you can translate the current implementation, open <em>additions.js</em> from the Resources group. It already contains the following code:</p>
                    <pre>
                    var mapToNative = function(movies) {
                      return movies.map(function (movie) {
                        return Movie.movieWithTitlePriceImageUrl(movie.title, movie.price, movie.imageUrl);
                      });
                    };
                    </pre>
                    <p>The above method takes each element from the input array, and uses it to build a <code>Movie</code> instance. The only thing worth pointing out is how the method signature changes: since JavaScript doesn&#x2019;t have named parameters, it appends the extra parameters to the method name using camel case.</p>
                    <p>Open <em>MovieService.swift</em> and replace the closure of the lazy <code>context</code> property with the following:</p>
                    <pre>
                    lazy var context: JSContext? = {

                      let context = JSContext()
                      
                      guard let
                        commonJSPath = Bundle.main.path(forResource: &quot;common&quot;, ofType: &quot;js&quot;),
                        let additionsJSPath = Bundle.main.path(forResource: &quot;additions&quot;, ofType: &quot;js&quot;) else {
                          print(&quot;Unable to read resource files.&quot;)
                          return nil
                      }
                      
                      do {
                        let common = try String(contentsOfFile: commonJSPath, encoding: String.Encoding.utf8)
                        let additions = try String(contentsOfFile: additionsJSPath, encoding: String.Encoding.utf8)
                        
                        context?.setObject(Movie.self, forKeyedSubscript: &quot;Movie&quot; as (NSCopying &amp; NSObjectProtocol)!)
                        _ = context?.evaluateScript(common)
                        _ = context?.evaluateScript(additions)
                      } catch (let error) {
                        print(&quot;Error while processing script file: &quot;)
                      }
                      
                      return context
                    }()
                    </pre>
                    <p>No big changes here. You load the contents of <code>additions.js</code> into your context. By using <code>setObject(_:forKeyedSubscript:)</code> on <code>JSContext</code>, you also make the <code>Movie</code> prototype available within the context.</p>
                    <p>There is only one thing left to do: in <em>MovieService.swift</em>, replace the current implementation of <code>parse(response:withLimit:)</code> with the following code:</p>
                    <pre>
                    func parse(response: String, withLimit limit: Double) -&gt; [Movie] {
                      guard let context = context else {
                        print(&quot;JSContext not found.&quot;)
                        return []
                      }
                      
                      let parseFunction = context.objectForKeyedSubscript(&quot;parseJson&quot;)
                      guard let parsed = parseFunction?.call(withArguments: [response]).toArray() else {
                        print(&quot;Unable to parse JSON&quot;)
                        return []
                      }
                      
                      let filterFunction = context.objectForKeyedSubscript(&quot;filterByLimit&quot;)
                      let filtered = filterFunction?.call(withArguments: [parsed, limit]).toArray()
                      
                      let mapFunction = context.objectForKeyedSubscript(&quot;mapToNative&quot;)
                      guard let unwrappedFiltered = filtered,
                        let movies = mapFunction?.call(withArguments: [unwrappedFiltered]).toArray() as? [Movie] else {
                        return []
                      }
                      
                      return movies
                    }
                    </pre>
                    <p>Instead of the builder closure, the code now uses <code>mapToNative()</code> from the JavaScript runtime to create the <code>Movie</code> array. If you build and run now, you should see that the app still works as it should:</p>
                    <p><a href="https://koenig-media.raywenderlich.com/uploads/2016/01/4.jpg"><img src="https://koenig-media.raywenderlich.com/uploads/2016/01/4-700x482.jpg" alt="javascriptcore tutorial" width="700" class="aligncenter size-large wp-image-124792" srcset="https://koenig-media.raywenderlich.com/uploads/2016/01/4-700x482.jpg 700w, https://koenig-media.raywenderlich.com/uploads/2016/01/4-464x320.jpg 464w, https://koenig-media.raywenderlich.com/uploads/2016/01/4-768x529.jpg 768w, https://koenig-media.raywenderlich.com/uploads/2016/01/4.jpg 988w" sizes="(max-width: 700px) 100vw, 700px"></a></p>
                    <p>Congratulations! Not only have you created an awesome app for browsing movies, you have done so by reusing existing code &#x2014; written in a completely different language!</p>
                    <div id="attachment_124757" class="wp-caption aligncenter">
                    <a href="https://koenig-media.raywenderlich.com/uploads/2016/01/CYo8n3vWQAAHYQP.jpg-large.jpeg"><img src="https://koenig-media.raywenderlich.com/uploads/2016/01/CYo8n3vWQAAHYQP.jpg-large-480x270.jpeg" alt="javascriptcore tutorial" width="480" class="size-medium wp-image-124757" srcset="https://koenig-media.raywenderlich.com/uploads/2016/01/CYo8n3vWQAAHYQP.jpg-large-480x270.jpeg 480w, https://koenig-media.raywenderlich.com/uploads/2016/01/CYo8n3vWQAAHYQP.jpg-large-768x432.jpeg 768w, https://koenig-media.raywenderlich.com/uploads/2016/01/CYo8n3vWQAAHYQP.jpg-large-700x394.jpeg 700w, https://koenig-media.raywenderlich.com/uploads/2016/01/CYo8n3vWQAAHYQP.jpg-large-266x151.jpeg 266w, https://koenig-media.raywenderlich.com/uploads/2016/01/CYo8n3vWQAAHYQP.jpg-large.jpeg 1024w" sizes="(max-width: 480px) 100vw, 480px"></a><p class="wp-caption-text">Now that&#x2019;s what I call seamless user experience!</p>
                    </div>
                    <h2 id="toc-anchor-009">Where to Go From Here?</h2>
                    <p>You can download the completed project for this tutorial <a href="https://koenig-media.raywenderlich.com/uploads/2016/04/Showtime-Finished.zip">here</a>.</p>
                    <p>If you wish to learn more about JavaScriptCore, check out <a href="https://developer.apple.com/videos/play/wwdc2013-615/">Session 615</a> from WWDC 2013.</p>
                    <p>I hope you enjoyed this JavaScriptCore tutorial. If you have any questions or comments, please join the forum discussion below!</p> <div class="l-margin-24 c-written-tutorial__content-footer"> <div class="c-written-tutorial__content-tags"> <a class="o-tag" href="/library?category_ids%5B%5D=154&amp;domain_ids%5B%5D=1&amp;sort_order=released_at">Tools &amp; Libraries</a> <a class="o-tag" href="/library?domain_ids%5B%5D=1&amp;sort_order=released_at">iOS &amp; Swift Tutorials</a> </div> </div> <div class="l-margin-72 l-block--card-small l-margin-left-auto l-margin-right-auto l-border-top l-newsletter-article"> <p class="l-text-align-center l-font-header--force">The raywenderlich.com newsletter is the easiest way to stay up-to-date on everything you need to know as a mobile developer.</p> <p class="l-text-align-center l-font-body l-color-grey l-font-15--force l-margin-18">Get a weekly digest of our tutorials and courses, and receive a free in-depth email course as a bonus!</p> </div> <div class="l-border-top l-margin-36 l-article-rating-footer" id="c-rate"> <div id="c-add-rating" class="c-add-rating l-block--card-medium l-block l-padding-30"> <div class="l-flex l-grid-3"> <span class="l-font-header l-font-bold l-margin-n-18 l-inline-block"> <span class="l-font-42">5</span>/5 </span> <p class="l-text-align-right"> <span class="l-font-15 l-color-grey-regent l-font-italic"> 3 ratings </span> </p> </div> </div> </div> </div>"
                    """
                _ = functionConvertHTMLToMarkdown.call(withArguments: [cleanHtml])
            }
        } catch let error {
            print("Error: \(error)")
        }
        
    }
    
    
    @objc func handleHTMLToMarkdownNotification(notification: Notification) {
        if let markdown = notification.object as? String {
            
        }
    }
    
    /// js 环境中调用方法后，会回调到这里
    /// 在该回调里，将转换结果以通知的方式进行转发
    let HTMLToMarkdownHandler: @convention(block) (String) -> Void = { htmlOutput in
        NotificationCenter.default.post(name: JSShowDownHandler.HTMLToMarkdownNotificationName, object: htmlOutput)
    }
    
    
    // MARK: - Console Blocks
    
    let consoleLog: @convention(block) (String) -> Void = { logMessage in
        print("\nJS Console:", logMessage)
    }
}
