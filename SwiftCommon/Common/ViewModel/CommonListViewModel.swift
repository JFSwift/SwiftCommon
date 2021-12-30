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
private var kpageNow = "kpageNow"

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
    
    //MARK: - getters and setters
    // 上下拉刷新事件
    var headerLoading: ActivityIndicator {
        get {
            if let aValue = objc_getAssociatedObject(self, &kHeaderLoading) as? ActivityIndicator {
                return aValue
            }else {
                let aValue = ActivityIndicator()
                objc_setAssociatedObject(self, &kHeaderLoading, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
    }
    
    var footerLoading: ActivityIndicator {
        get {
            if let aValue = objc_getAssociatedObject(self, &kFooterLoading) as? ActivityIndicator {
                return aValue
            }else {
                let aValue = ActivityIndicator()
                objc_setAssociatedObject(self, &kFooterLoading, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
    }
    
    var refreshStatus: BehaviorRelay<MJRefreshAction> {
        get {
            if let aValue = objc_getAssociatedObject(self, &kRefreshStatus) as? BehaviorRelay<MJRefreshAction> {
                return aValue
            }else {
                let aValue = BehaviorRelay<MJRefreshAction>(value: .idle)
                objc_setAssociatedObject(self, &kRefreshStatus, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
    }
    
    var pageNow: Int {
        get {
            if let aValue = objc_getAssociatedObject(self, &kpageNow) as? Int {
                return aValue
            }else {
                let aValue = 1
                objc_setAssociatedObject(self, &kpageNow, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
        set {
            
        }
    }

}
