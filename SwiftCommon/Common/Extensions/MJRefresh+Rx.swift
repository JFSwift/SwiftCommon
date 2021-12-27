//
//  MJRefresh+Rx.swift
//  Common
//
//  Created by JoFox on 2021/12/25.
//

import UIKit
import RxSwift
import MJRefresh

public enum MJRefreshAction {
    // 闲置
    case idle
    /// 停止刷新
    case stopHeaderRefresh(hiddenFooter: Bool = true)
    /// 停止加载更多
    case stopFooterRefresh(showMore: Bool = false)
    /// 请求错误
    case loadMoreError
}

extension Reactive where Base: MJRefreshComponent {
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { refreshControl, active in
            if active {
                // 打开会多次调用刷新
                // refreshControl.beginRefreshing()
            } else {
                if refreshControl.state == .noMoreData {
                }else {
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}

extension Reactive where Base: UIScrollView {
    // 状态更新回调
    var refreshStatus: Binder <MJRefreshAction> {
        return Binder(base) { target, action in
            switch action {
            case let .stopHeaderRefresh(hiddenFooter):
                resetFooterRefreshIdle(false)
                if let footer = target.mj_footer {
                    DispatchQueue.main.async {
                        footer.isHidden = hiddenFooter
                    }
                }
            case let .stopFooterRefresh(showMore):
                resetFooterRefreshIdle(false)
                if let footer = target.mj_footer {
                    if (showMore) {
                        footer.endRefreshingWithNoMoreData()
                    }else {
                        footer.resetNoMoreData()
                    }
                }
            case .loadMoreError:
                resetFooterRefreshIdle(true)
            default: break
            }
        }
    }
    
    /// 添加刷新头部
    /// - Parameter block: 回调
    func addRefreshHeader(block:@escaping MJRefreshComponentAction){
        base.mj_header = MJRefreshNormalHeader(refreshingBlock:block)
    }
    
    /// 添加刷新尾部
    /// - Parameter block: block description
    func addListViewRefreshFooter(block:@escaping MJRefreshComponentAction){
        if base.mj_footer == nil {
            let footer = MJRefreshAutoNormalFooter(refreshingBlock:block)
            footer.setTitle("点击或上拉加载更多", for: .idle)
            footer.setTitle("已经到底啦~", for: .noMoreData)
            footer.setTitle("加载中...", for: .refreshing)
            base.mj_footer = footer
        }
    }
    
    /// 重置footer闲置状态
    /// - Parameter error: error description
    func resetFooterRefreshIdle(_ error: Bool){
        guard let footer = base.mj_footer as? MJRefreshAutoNormalFooter else {
            return
        }
        footer.endRefreshing()
        DispatchQueue.main.async {
            footer.setTitle(error ? "加载失败，请重试！":"点击或上拉加载更多", for: .idle)
        }
    }

}
