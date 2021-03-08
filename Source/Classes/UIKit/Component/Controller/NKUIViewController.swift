//
//  NKUIViewController.swift
//  FireFly
//
//  Created by Hunt on 2020/11/4.
//

import UIKit

open class NKUIViewController: UIViewController {
    
    /// 横竖屏切换时的调用，根据需要配置
    open var viewWillTransitionHanlder: ((_ size: CGSize, _ coordinator: UIViewControllerTransitionCoordinator)->Void)?
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
        } else {
            // Fallback on earlier versions
        }
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        viewWillTransitionHanlder?(size, coordinator)
    }
}
