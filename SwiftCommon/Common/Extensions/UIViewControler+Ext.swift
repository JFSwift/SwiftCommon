//
//  UIViewControler+Ext.swift
//  SwiftCommon
//
//  Created by JoFox on 2022/1/21.
//

import UIKit
import NSObject_Rx

// MARK: - 方法交换 实现基类方法
extension UIViewController {

    @objc func ws_viewDidLoad() {
        // 1、判断是否遵守基础控制器协议
        guard let commonP = self as? CommonViewController else { return }
        // 实现基础协议
        commonViewController(commonP)

        // 2、基础业务协议
        guard let commonFull = self as? CommonFullViewController else { return }
        commonViewControllerFull(commonFull)

        // 3、基础列表功能业务协议
        guard let commonList = self as? CommonListViewController else {
            commonFull.commonBindViewModel()
            return
        }
        commonListViewController(commonList)
        commonList.commonBindViewModel()
    }

    /// 实现基础协议
    private func commonViewController(_ common: CommonViewController) {
        // 滑动返回手势处理
        if let nav = navigationController, let popGestureRe = nav.interactivePopGestureRecognizer {
            popGestureRe.delegate = nav
        }

        // 实现CommonViewController中的方法
        common.commonViewDidLoad()
        common.commonLayoutSubViews()
        common.commonFunctionalBusiness()
    }

    /// 实现基础业务协议
    private func commonViewControllerFull(_ common: CommonFullViewController) {
        // 这里获取ViewModel是为了常规业务中请求网络相关操作
        let viewModel = common.commonGetViewModel()
        if let pHud = common as? CommonCustomeHud {
            // 自定义加载框
            common.isLoading.asObservable().bind(to: pHud.customHud).disposed(by: rx.disposeBag)
        } else {
            // 绑定默认加载框
            common.isLoading.asObservable().bind(to: common.progressHud.rx.isAnimating).disposed(by: rx.disposeBag)
        }
        // viewMode中请求接口 trackActivity(loading)即可 此时便可显示loadingHUD
        viewModel?.loading.asObservable().bind(to: common.isLoading).disposed(by: rx.disposeBag)
    }

    /// 实现列表业务协议
    /// - Parameter common: common description
    private func commonListViewController(_ common: CommonListViewController) {
        // 绑定默认
        guard let scrollView = common.commonListGetListView() else { return }
        var customRefresh = false
        if let pRefresh = common as? CommonListCustomRefresh {
            customRefresh = true
            // 自定义
            common.isHeaderLoading.bind(to: pRefresh.customHeaderRefresh).disposed(by: rx.disposeBag)
            common.isFooterLoading.bind(to: pRefresh.customFooterRefresh).disposed(by: rx.disposeBag)
        } else {
            if let header = scrollView.mj_header {
                common.isHeaderLoading.bind(to: header.rx.isAnimating).disposed(by: rx.disposeBag)
            }
            if let footer = scrollView.mj_footer {
                common.isFooterLoading.bind(to: footer.rx.isAnimating).disposed(by: rx.disposeBag)
            }
        }
        guard let viewListModel = common.commonGetViewModel() as? CommonListViewModel else { return }
        // ViewModel绑定上下拉信号
        viewListModel.headerLoading.asObservable().bind(to: common.isHeaderLoading).disposed(by: rx.disposeBag)
        viewListModel.footerLoading.asObservable().bind(to: common.isFooterLoading).disposed(by: rx.disposeBag)

        // 处理默认上下拉刷新状态
        if !customRefresh {
            viewListModel.refreshStatus.asObservable().bind(to: common.refreshStatus).disposed(by: rx.disposeBag)
            common.refreshStatus.asObservable().subscribe(onNext: { action in
                switch action {
                case let .stopHeaderRefresh(hiddenFooter):
                    scrollView.common.resetFooterRefreshIdle(false)
                    if let footer = scrollView.mj_footer {
                        DispatchQueue.main.async {
                            footer.isHidden = hiddenFooter
                        }
                    }
                case let .stopFooterRefresh(showMore):
                    scrollView.common.resetFooterRefreshIdle(false)
                    if let footer = scrollView.mj_footer {
                        if showMore {
                            footer.endRefreshingWithNoMoreData()
                        } else {
                            footer.resetNoMoreData()
                        }
                    }
                case .loadMoreError:
                    scrollView.common.resetFooterRefreshIdle(true)
                default: break
                }
            }).disposed(by: rx.disposeBag)
        }
    }

}

// MARK: - 处理滑动返回手势
extension UINavigationController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count == 1 { return false }
        return true
    }

}
