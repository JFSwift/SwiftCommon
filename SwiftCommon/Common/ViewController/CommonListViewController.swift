//
//  CommonTableViewController.swift
//  Common
//
//  Created by JoFox on 2021/12/25.
//

import UIKit
import RxSwift
import RxRelay
import NSObject_Rx

public protocol CommonListViewController: CommonFullViewController {

    /// 获取当前页面的ScrollView
    /// - Returns: description
    func commonListGetListView() -> UIScrollView?

}

/// 自定义上下拉刷新
public protocol CommonListCustomRefresh {

    /// 默认使用common的load框 可通过此方法自定义绑定load
    var customHeaderRefresh: Binder<Bool> { get }

    /// 默认使用common的load框 可通过此方法自定义绑定load
    var customFooterRefresh: Binder<Bool> { get }

}

private var kListHeaderLoading = "kListHeaderLoading"
private var kListFooterLoading = "kListFooterLoading"
private var kListRefreshStatus = "kListRefreshStatus"

private var kHeaderRefreshTrigger = "kHeaderRefreshTrigger"
private var kFooterRefreshTrigger = "kFooterRefreshTrigger"

public extension CommonListViewController {

    // MARK: - getters and setters

    // 上下拉刷新事件
    var isHeaderLoading: BehaviorRelay<Bool> {
        getAssociatedObjectIfNilSetDefaultValue(key: &kListHeaderLoading) {
            BehaviorRelay(value: false)
        }
    }

    var isFooterLoading: BehaviorRelay<Bool> {
        getAssociatedObjectIfNilSetDefaultValue(key: &kListFooterLoading) {
            BehaviorRelay(value: false)
        }
    }

    // MJRefresh状态事件
    var refreshStatus: BehaviorRelay<MJRefreshAction> {
        getAssociatedObjectIfNilSetDefaultValue(key: &kListRefreshStatus) {
            BehaviorRelay<MJRefreshAction>(value: .idle)
        }
    }

    // 主动触发上下拉刷新事件
    var headerRefreshTrigger: PublishSubject<Void> {
        getAssociatedObjectIfNilSetDefaultValue(key: &kHeaderRefreshTrigger) {
            PublishSubject<Void>()
        }
    }

    var footerRefreshTrigger: PublishSubject<Void> {
        getAssociatedObjectIfNilSetDefaultValue(key: &kFooterRefreshTrigger) {
            PublishSubject<Void>()
        }
    }

}
