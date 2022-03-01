//
//  CommonManager.swift
//  Common
//
//  Created by JoFox on 2021/12/26.
//

import UIKit

public struct Common {

    /// 注入方法拦截
    static func registrationHook() {
        viewDidLoadSwizzle()

    }

    /// Hook控制器的viewDidLoad
    private static func viewDidLoadSwizzle() {
        let originalSelector = #selector(UIViewController.viewDidLoad)
        let swizzledSelector = #selector(UIViewController.ws_viewDidLoad)
        let result = UIViewController.common.swizzleMethod(originSel: originalSelector, altSel: swizzledSelector)
        switch result {
        case .success:
            break
        case .failed(let error):
            debugPrint(error)
        }
    }
    
}
