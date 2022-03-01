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
public protocol CommonCustomeHud where Self: UIViewController {

    /// 默认使用common的load框 可通过此方法自定义绑定load
    var customHud: Binder<Bool> { get }

}

/// 基础基类协议
public protocol CommonViewController where Self: UIViewController {

    // 加载默认设置
    func commonViewDidLoad()
    /// 设置页面约束
    func commonLayoutSubViews()
    /// 业务逻辑
    func commonFunctionalBusiness()

}

/// 完整的基类协议
public protocol CommonFullViewController: CommonViewController {

    /// 绑定viewModel的状态
    func commonBindViewModel()
    /// 获取当前viewModel
    /// - Returns: description
    func commonGetViewModel() -> CommonViewModel?

}

private var kIsLoading = "kIsLoading"
private var kProgressHud = "kProgressHud"

public extension CommonFullViewController {

    var progressHud: MBProgressHUD {
        getAssociatedObjectIfNilSetDefaultValue(key: &kProgressHud) { [weak self] in
            guard let self = self else {
                return MBProgressHUD()
            }
            let hud = MBProgressHUD(view: self.view)
            hud.mode = .indeterminate
            hud.bezelView.color = .black
            hud.bezelView.style = .solidColor
            hud.contentColor = .white
            self.view.addSubview(hud)
            return hud
        }
    }

    // load框绑定事件
    var isLoading: BehaviorRelay<Bool> {
        getAssociatedObjectIfNilSetDefaultValue(key: &kIsLoading) {
            BehaviorRelay(value: false)
        }
    }

}
