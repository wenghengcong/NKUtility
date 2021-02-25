//
//  NKUINavigationController.swift
//  FireFly
//
//  Created by Hunt on 2020/11/4.
//

import UIKit

open class NKUINavigationController: UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            NKThemeProvider.shared.checkFollowingSystem()
        } else {
            // Fallback on earlier versions
        }
    }
}
