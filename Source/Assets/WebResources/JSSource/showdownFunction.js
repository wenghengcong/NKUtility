// markdown to html
function convertMarkdownToHTML(source) {
    var converter = new showdown.Converter();
    var htmlResult = converter.makeHtml(source);
    
    consoleLog(htmlResult);
    
    handleConvertedMarkdown(htmlResult);
}

// html to markdown
function convertHTMLToMarkdown(source) {
    var converter = new showdown.Converter();
    var markdownResult = converter.makeMarkdown(source);
    
    consoleLog(markdownResult);
    
    handleConvertedMarkdown(htmlResult);
}
