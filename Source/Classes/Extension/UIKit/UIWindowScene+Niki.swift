//
//  UIWindowScene+Niki.swift
//  Pods
//
//  Created by Hunt on 2021/10/16.
//

import Foundation

public extension UIWindowScene {
    
    @available(iOS 13.0, tvOS 13.0, *)
    public static func topScene() -> UIWindowScene? {
        let connectedScenes = UIApplication.shared.connectedScenes
        if let windowActiveScene = connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            return windowActiveScene
        } else if let windowInactiveScene = connectedScenes.first(where: { $0.activationState == .foregroundInactive }) as? UIWindowScene {
            return windowInactiveScene
        }  else if let windowInactiveScene = connectedScenes.first(where: { $0.activationState == .background }) as? UIWindowScene {
            return windowInactiveScene
        } else if let windowInactiveScene = connectedScenes.first(where: { $0.activationState == .unattached }) as? UIWindowScene {
            return windowInactiveScene
        } else {
            return nil
        }
    }
}
