//
//  CommonListViewModel.swift
//  Common
//
//  Created by JoFox on 2021/12/25.
//

import UIKit
import RxRelay

public protocol CommonListViewModel: CommonViewModel {

    /// 重置当前列表的刷新状态
    /// - Parameter action: action description
    func resetRefreshStatus(action: MJRefreshAction)

}

private var kHeaderLoading = "kHeaderLoading"
private var kFooterLoading = "kFooterLoading"
private var kRefreshStatus = "kRefreshStatus"
private var kPageNow = "kPageNow"

public extension CommonListViewModel {

    /// 重置当前列表的刷新状态
    /// - Parameter action: action description
    func resetRefreshStatus(action: MJRefreshAction) {
        refreshStatus.accept(action)
        switch action {
        case .loadMoreError:
            if pageNow > 1 {
                self.pageNow -= 1
            }
        default: break
        }
    }

    // MARK: - getters and setters
    // 上下拉刷新事件
    var headerLoading: ActivityIndicator {
        getAssociatedObjectIfNilSetDefaultValue(key: &kHeaderLoading) {
            ActivityIndicator()
        }
    }

    var footerLoading: ActivityIndicator {
        getAssociatedObjectIfNilSetDefaultValue(key: &kFooterLoading) {
            ActivityIndicator()
        }
    }

    var refreshStatus: BehaviorRelay<MJRefreshAction> {
        getAssociatedObjectIfNilSetDefaultValue(key: &kRefreshStatus) {
            BehaviorRelay<MJRefreshAction>(value: .idle)
        }
    }

    var pageNow: Int {
        get {
            getAssociatedObjectIfNilSetDefaultValue(key: &kPageNow) {
                1
            }
        }
        set {
            objc_setAssociatedObject(self, &kPageNow, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}
