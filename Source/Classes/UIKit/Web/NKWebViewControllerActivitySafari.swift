//
//   NKWebViewControllerActivitySafari.swift
//
//  Created by Myles Ringle on 24/06/2015.
//  Transcribed from code used in SVWebViewController.
//  Copyright (c) 2015 Myles Ringle & Sam Vermette. All rights reserved.
//

import UIKit

class  NKWebViewControllerActivitySafari :  NKWebViewControllerActivity {
    
    override var activityTitle : String {
        return NKWebViewConstants.OpenInSafari
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for activityItem in activityItems {
            if let activityItem = activityItem as? URL, UIApplication.shared.canOpenURL(activityItem) {
                return true
            }
        }
        return false
    }
    
    override func perform() {
        UIApplication.shared.open((URLToOpen! as URL), options: [:]) { (completed) in
            self.activityDidFinish(completed)
        }
    }
}
