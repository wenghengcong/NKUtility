//
//  UIResponder+Scene.swift
//  NKUtility
//
//  Created by Hunt on 2021/1/24.
//

import Foundation
import UIKit

// source from https://stackoverflow.com/a/56589151/4124634
/** get scene in iOS 13
 As of iOS 13, UIApplication has the connectedScenes property which is Set<UIScene>. Each of those scenes has a delegate which is a UISceneDelegate. So you could access all of the delegates that way.
 
 A scene can manage one or more windows (UIWindow) and you can get a window's UIScene from its windowScene property.

 If you want the scene delegate for a specific view controller then note the following. From a UIViewController you can get its window from its view. From the window you can get its scene and of course from the scene you can get its delegate.

 In short, from a view controller, you can do:

 `let mySceneDelegate = self.view.window.windowScene.delegate`
 
 However, there are plenty of times where a view controller has no window. This happens when a view controller presents another full screen view controller. This can happened when the view controller is in a navigation controller and the view controller is not the top, visible view controller.

 This requires a different approach to finding the view controller's scene. Ultimately you need to use a combination of walking the responder chain and the view controller hierarchy until you find a path that leads to the scene.

 The following extension will (may) get you a UIScene from a view or view controller. Once you have the scene, you can access its delegate.
 
 This can be called from any view or view controller to get its scene. But note that you can only get the scene from a view controller only after viewDidAppear has been called at least once. If you try any sooner then the view controller may not yet be part of the view controller hierarchy.

 This will work even if the window of the view of the view controller is nil as long as the view controller is part of a view controller hierarchy and somewhere up that hierarchy, it is attached to a window.
 */
@available(iOS 13.0, *)
extension UIResponder {
    @objc var scene: UIScene? {
        return nil
    }
}

@available(iOS 13.0, *)
extension UIScene {
    @objc override var scene: UIScene? {
        return self
    }
}

@available(iOS 13.0, *)
extension UIView {
    @objc override var scene: UIScene? {
        if let window = self.window {
            return window.windowScene
        } else {
            return self.next?.scene
        }
    }
}

@available(iOS 13.0, *)
extension UIViewController {
    @objc override var scene: UIScene? {
        // Try walking the responder chain
        var res = self.next?.scene
        if (res == nil) {
            // That didn't work. Try asking my parent view controller
            res = self.parent?.scene
        }
        if (res == nil) {
            // That didn't work. Try asking my presenting view controller
            res = self.presentingViewController?.scene
        }

        return res
    }
}
