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
    var markdownResult = new Readability(source).parse();
//    var converter = new showdown.Converter();
//    var markdownResult = converter.makeMarkdown(source);
    consoleLog(markdownResult);    
    handleConvertedHtml(markdownResult);
}
