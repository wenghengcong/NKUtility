//
//   NKWebViewControllerActivity.swift
//
//  Created by Myles Ringle on 24/06/2015.
//  Transcribed from code used in SVWebViewController.
//  Copyright (c) 2015 Myles Ringle & Sam Vermette. All rights reserved.
//

import UIKit


class  NKWebViewControllerActivity: UIActivity {

    var URLToOpen: URL?
    var schemePrefix: String?
    
    override var activityType : UIActivity.ActivityType? {
        let typeArray = "\(type(of: self))".components(separatedBy: ".")
        let _type: String = typeArray[typeArray.count-1]
        return UIActivity.ActivityType(rawValue: _type)
    }
    
    /// 注意图片命名
    override var activityImage : UIImage {
        if let type = activityType?.rawValue {
            let name = type + "Icon"
            let img = UIImage(nkBundleNamed: name)
            return img!
        }
        else{
            assert(false, "Unknow type")
            return UIImage()
        }
    }
            
    override func prepare(withActivityItems activityItems: [Any]) {
        for activityItem in activityItems {
            if activityItem is URL {
                URLToOpen = activityItem as? URL
            }
        }
    }

}
