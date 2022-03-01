//
//  MJRefresh+Rx.swift
//  Common
//
//  Created by JoFox on 2021/12/25.
//

import UIKit
import RxSwift
import MJRefresh

// MARK: - 枚举

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

// MARK: - Rx扩展

extension Reactive where Base: MJRefreshComponent {
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { refreshControl, active in
            if active {
                // 打开会多次调用刷新
                // refreshControl.beginRefreshing()
            } else {
                if refreshControl.state != .noMoreData {
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}

// MARK: - UI扩展

extension Extension where Base: UIScrollView {

    /// 添加刷新头部
    /// - Parameter block: 回调
    func addRefreshHeader(block:@escaping MJRefreshComponentAction) {
        base.mj_header = MJRefreshNormalHeader(refreshingBlock: block)
    }

    /// 添加刷新尾部
    /// - Parameter block: block description
    func addRefreshFooter(block:@escaping MJRefreshComponentAction) {
        if base.mj_footer == nil {
            let footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
            footer.setTitle("点击或上拉加载更多", for: .idle)
            footer.setTitle("已经到底啦~", for: .noMoreData)
            footer.setTitle("加载中...", for: .refreshing)
            footer.isHidden = true
            base.mj_footer = footer
        }
    }

    /// 重置footer闲置状态
    /// - Parameter error: error description
    func resetFooterRefreshIdle(_ error: Bool) {
        guard let footer = base.mj_footer as? MJRefreshAutoNormalFooter else {
            return
        }
        footer.endRefreshing()
        DispatchQueue.main.async {
            footer.setTitle(error ? "加载失败，请重试！":"点击或上拉加载更多", for: .idle)
        }
    }

}
