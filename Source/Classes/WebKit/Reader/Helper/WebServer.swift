/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import GCDWebServer
import NKUtility
//import Shared

public class WebServer {

    static let WebServerSharedInstance = WebServer()

    public class var sharedInstance: WebServer {
        return WebServerSharedInstance
    }

    let server: GCDWebServer = GCDWebServer()

    var base: String {
        return "http://localhost:\(server.port)"
    }

    
    public func setUpWebServer() {
        let server = WebServer.sharedInstance
        guard !server.server.isRunning else { return }

        ReaderModeHandlers.register(server)

        // Bug 1223009 was an issue whereby CGDWebserver crashed when moving to a background task
        // catching and handling the error seemed to fix things, but we're not sure why.
        // Either way, not implicitly unwrapping a try is not a great way of doing things
        // so this is better anyway.
        do {
            try server.start()
        } catch let err as NSError {
            print("Error: Unable to start WebServer \(err)")
        }
    }
    
    /// The private credentials for accessing resources on this Web server.
    let credentials: URLCredential

    /// A random, transient token used for authenticating requests.
    /// Other apps are able to make requests to our local Web server,
    /// so this prevents them from accessing any resources.
    fileprivate let sessionToken = UUID().uuidString

    init() {
        credentials = URLCredential(user: sessionToken, password: "", persistence: .forSession)
    }

    @discardableResult func start() throws -> Bool {
        if !server.isRunning {
            try server.start(options: [
                GCDWebServerOption_Port: WebServerInfo.port,
                GCDWebServerOption_BindToLocalhost: true,
                GCDWebServerOption_AutomaticallySuspendInBackground: false, // done by the app in AppDelegate
                GCDWebServerOption_AuthenticationMethod: GCDWebServerAuthenticationMethod_Basic,
                GCDWebServerOption_AuthenticationAccounts: [sessionToken: ""]
            ])
        }
        return server.isRunning
    }

    /// Convenience method to register a dynamic handler. Will be mounted at $base/$module/$resource
    func registerHandlerForMethod(_ method: String, module: String, resource: String, handler: @escaping (_ request: GCDWebServerRequest?) -> GCDWebServerResponse?) {
        // Prevent serving content if the requested host isn't a safelisted local host.
        let wrappedHandler = {(request: GCDWebServerRequest?) -> GCDWebServerResponse? in
            guard let request = request, InternalURL.isValid(url: request.url) else {
                return GCDWebServerResponse(statusCode: 403)
            }

            return handler(request)
        }
        server.addHandler(forMethod: method, path: "/\(module)/\(resource)", request: GCDWebServerRequest.self, processBlock: wrappedHandler)
    }

    /// Convenience method to register a resource in the main bundle. Will be mounted at $base/$module/$resource
    func registerMainBundleResource(_ resource: String, module: String) {
        let bundle = Bundle(for: NKBundleToken.self)
        if let path = bundle.path(forResource: resource, ofType: nil) {
            server.addGETHandler(forPath: "/\(module)/\(resource)", filePath: path, isAttachment: false, cacheAge: UInt.max, allowRangeRequests: true)
        }
    }

    /// Convenience method to register all resources in the main bundle of a specific type. Will be mounted at $base/$module/$resource
    func registerMainBundleResourcesOfType(_ type: String, module: String) {
        let bundle = Bundle(for: NKBundleToken.self)
        for path: String in Bundle.paths(forResourcesOfType: type, inDirectory: bundle.bundlePath) {
            if let resource = NSURL(string: path)?.lastPathComponent {
                server.addGETHandler(forPath: "/\(module)/\(resource)", filePath: path as String, isAttachment: false, cacheAge: UInt.max, allowRangeRequests: true)
            } else {
                NKlogger.warning("Unable to locate resource at path: '\(path)'")
            }
        }
    }

    /// Return a full url, as a string, for a resource in a module. No check is done to find out if the resource actually exist.
    func URLForResource(_ resource: String, module: String) -> String {
        return "\(base)/\(module)/\(resource)"
    }

    func baseReaderModeURL() -> String {
        return WebServer.sharedInstance.URLForResource("page", module: "reader-mode")
    }
}
