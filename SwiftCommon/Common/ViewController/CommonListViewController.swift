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

public protocol CommonListViewController: CommonViewControllerFull {
    
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
private var kFooterRefreshTrigger = "kListFooterLoading"

public extension CommonListViewController {
        
    //MARK: - getters and setters
    // 上下拉刷新事件
    
    var isHeaderLoading: BehaviorRelay<Bool> {
        get {
            if let aValue = objc_getAssociatedObject(self, &kListHeaderLoading) as? BehaviorRelay<Bool> {
                return aValue
            }else {
                let aValue = BehaviorRelay(value: false)
                objc_setAssociatedObject(self, &kListHeaderLoading, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
    }
    
    var isFooterLoading: BehaviorRelay<Bool> {
        get {
            if let aValue = objc_getAssociatedObject(self, &kListFooterLoading) as? BehaviorRelay<Bool> {
                return aValue
            }else {
                let aValue = BehaviorRelay(value: false)
                objc_setAssociatedObject(self, &kListFooterLoading, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
    }
    
    var refreshStatus: BehaviorRelay<MJRefreshAction> {
        get {
            if let aValue = objc_getAssociatedObject(self, &kListRefreshStatus) as? BehaviorRelay<MJRefreshAction> {
                return aValue
            }else {
                let aValue = BehaviorRelay<MJRefreshAction>(value: .idle)
                objc_setAssociatedObject(self, &kListRefreshStatus, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
    }

    var headerRefreshTrigger: PublishSubject<Void> {
        get {
            if let aValue = objc_getAssociatedObject(self, &kHeaderRefreshTrigger) as? PublishSubject<Void> {
                return aValue
            }else {
                let aValue = PublishSubject<Void>()
                objc_setAssociatedObject(self, &kHeaderRefreshTrigger, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
    }

    var footerRefreshTrigger: PublishSubject<Void> {
        get {
            if let aValue = objc_getAssociatedObject(self, &kFooterRefreshTrigger) as? PublishSubject<Void> {
                return aValue
            }else {
                let aValue = PublishSubject<Void>()
                objc_setAssociatedObject(self, &kFooterRefreshTrigger, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
    }

}
