//
//  CommonManager.swift
//  Common
//
//  Created by JoFox on 2021/12/26.
//

import UIKit
import Aspects
import NSObject_Rx
import MJRefresh

public struct Common {
    
    /// 注入hook
    static func registrationHook() {
        
        let vcInitBlock:@convention(block) (AspectInfo)-> Void = { aspectInfo in
            guard let vc: UIViewController = aspectInfo.instance() as? UIViewController else { return }
            // 判断是否遵守协议
            if let _ = vc as? CommonViewController {
                vc.hidesBottomBarWhenPushed = true
            }
        }
        let vcInitObjc: AnyObject = unsafeBitCast(vcInitBlock, to: AnyObject.self)
        do {
            try UIViewController.aspect_hook(#selector(UIViewController.init(nibName:bundle:)), with: AspectOptions.positionBefore, usingBlock:vcInitObjc)
        }catch{
            print(error)
        }

        let vcLoadBlock:@convention(block) (AspectInfo)-> Void = { aspectInfo in
            guard let vc: UIViewController = aspectInfo.instance() as? UIViewController else { return }
            // 判断是否遵守协议
            if let p = vc as? CommonViewController {
                if let interactivePopGestureRecognizer = vc.navigationController?.interactivePopGestureRecognizer {
                    interactivePopGestureRecognizer.delegate = vc as? UIGestureRecognizerDelegate
                }
                p.commonViewDidLoad()
                p.commonLayoutSubViews()
                if let pFull = vc as? CommonViewControllerFull {
                    let viewModel = pFull.commonGetViewModel()
                    if let pHud = p as? CommonCustomeHud {
                        // 自定义加载框
                        pFull.isLoading.asObservable().bind(to: pHud.customHud).disposed(by: vc.rx.disposeBag)
                    }else {
                        // 绑定默认加载框
                        pFull.isLoading.asObservable().bind(to: pFull.progressHud.rx.isAnimating).disposed(by: vc.rx.disposeBag)
                    }
                    viewModel?.loading.asObservable().bind(to: pFull.isLoading).disposed(by: vc.rx.disposeBag)
                    pFull.commonBindViewModel()
                }
            }
            if let pList = vc as? CommonListViewController {
                if let pRefresh = pList as? CommonListCustomRefresh {
                    // 自定义
                    pList.isHeaderLoading.bind(to: pRefresh.customHeaderRefresh).disposed(by: vc.rx.disposeBag)
                    pList.isFooterLoading.bind(to: pRefresh.customFooterRefresh).disposed(by: vc.rx.disposeBag)
                }else {
                    // 绑定默认
                    guard let scrollView = pList.commonListGetListView() else { return }
                    if let header = scrollView.mj_header {
                        pList.isHeaderLoading.bind(to: header.rx.isAnimating).disposed(by: vc.rx.disposeBag)
                    }
                    if let footer = scrollView.mj_footer {
                        pList.isFooterLoading.bind(to: footer.rx.isAnimating).disposed(by: vc.rx.disposeBag)
                    }
                }
                if let viewListModel = pList.commonGetViewModel() as? CommonListViewModel {
                    // ViewModel绑定上下拉信号
                    viewListModel.headerLoading.asObservable().bind(to: pList.isHeaderLoading).disposed(by: vc.rx.disposeBag)
                    viewListModel.footerLoading.asObservable().bind(to: pList.isFooterLoading).disposed(by: vc.rx.disposeBag)
                }
            }

        }
        let vcLoadObjc: AnyObject = unsafeBitCast(vcLoadBlock, to: AnyObject.self)
        do {
            try UIViewController.aspect_hook(#selector(UIViewController.viewDidLoad), with: AspectOptions.positionBefore, usingBlock:vcLoadObjc)
        }catch{
            print(error)
        }

    }
    
}

