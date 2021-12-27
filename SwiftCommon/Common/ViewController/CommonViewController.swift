//
//  CommonViewController.swift
//  Common
//
//  Created by JoFox on 2021/12/25.
//

import UIKit
import RxRelay
import RxSwift
import MBProgressHUD

/// 自定义load绑定
public protocol CommonCustomeHud where Self : UIViewController  {
    
    /// 默认使用common的load框 可通过此方法自定义绑定load
    var customHud: Binder<Bool> { get }

}

/// 基础基类协议
public protocol CommonViewController where Self : UIViewController {

    // 加载默认设置
    func commonViewDidLoad()
    
    /// 设置页面约束
    func commonLayoutSubViews()
        
}

/// 完整的基类协议
public protocol CommonViewControllerFull: CommonViewController {
    
    /// 绑定viewModel的状态
    func commonBindViewModel()
        
    /// 获取当前viewModel
    /// - Returns: description
    func commonGetViewModel() -> CommonViewModel?

}


private var kIsLoading = "kIsLoading"
private var kProgressHud = "kProgressHud"

public extension CommonViewControllerFull  {
    
    var progressHud: MBProgressHUD {
        get {
            if let aValue = objc_getAssociatedObject(self, &kProgressHud) as? MBProgressHUD {
                return aValue
            }else {
                let hud = MBProgressHUD(view: self.view)
                self.view.addSubview(hud)
                hud.bezelView.style = .solidColor
                objc_setAssociatedObject(self, &kProgressHud, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return hud
            }
        }
    }
    
    var isLoading: BehaviorRelay<Bool> {
        get {
            if let aValue = objc_getAssociatedObject(self, &kIsLoading) as? BehaviorRelay<Bool> {
                return aValue
            }else {
                let aValue = BehaviorRelay(value: false)
                objc_setAssociatedObject(self, &kIsLoading, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
    }

}
