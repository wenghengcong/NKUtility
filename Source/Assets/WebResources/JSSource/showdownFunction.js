function setupWKWebViewJavascriptBridge(callback) {
    if (window.WKWebViewJavascriptBridge) { return callback(WKWebViewJavascriptBridge); }
    if (window.WKWVJBCallbacks) { return window.WKWVJBCallbacks.push(callback); }
    window.WKWVJBCallbacks = [callback];
    window.webkit.messageHandlers.iOS_Native_InjectJavascript.postMessage(null)
}

// markdown to html
function convertMarkdownToHTML(source) {
    var converter = new showdown.Converter();
    var htmlResult = converter.makeHtml(source);
    consoleLog(htmlResult);
    handleConvertedMarkdown(htmlResult);
}

// html to markdown
function convertHTMLToMarkdown(source) {
//    var BASETESTCASE = '<html><body><p>Some text and <a class="someclass" href="#">a link</a></p>' +
//                       '<div id="foo">With a <script>With &lt; fancy " characters in it because' +
//                       '</script> that is fun.<span>And another node to make it harder</span></div><form><input type="text"/><input type="number"/>Here\'s a form</form></body></html>';
//    var doc = new JSDOMParser().parse(source)
//    var readDoc = new Readability(doc).parse();
//    var result = readDoc.content
    var converter = new showdown.Converter();
    var markdownResult = converter.makeMarkdown(source);
    consoleLog(result);
    handleConvertedHtml(result);
}
