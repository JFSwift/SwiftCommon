//
//  SimpleCommonListController.swift
//  RxSwiftDemo
//
//  Created by JoFox on 2021/12/26.
//

import UIKit
import NSObject_Rx
import SwifterSwift
import SnapKit
import MJRefresh

class SimpleCommonListController: UIViewController, CommonListViewController {

    // MARK: - Life Cycle

    /// 加载View
    func commonViewDidLoad() {
        view.addSubview(tableView)
        tableView.register(cellWithClass: UITableViewCell.self)
        tableView.common.addRefreshHeader { [weak self] in
            self?.headerRefreshTrigger.onNext(())
        }
        tableView.common.addRefreshFooter { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        }

    }

    /// 设置View约束
    func commonLayoutSubViews() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// 业务逻辑
    func commonFunctionalBusiness() {

    }

    /// 绑定ViewModel
    func commonBindViewModel() {
        let input = TableViewModel.Input(headerRefresh: headerRefreshTrigger, footerRefresh: footerRefreshTrigger)
        let output = viewModel.transform(input: input)
        output.items.bind(to: tableView.rx.items) { tableView, _, element in
            let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self)
            cell.textLabel?.text = "\(element)"
            return cell
        }.disposed(by: rx.disposeBag)
        headerRefreshTrigger.onNext(())
    }

    /// 获取当前ViewModel进行绑定load
    /// - Returns: description
    func commonGetViewModel() -> CommonViewModel? {
        viewModel
    }

    /// 返回当前listView
    /// - Returns: description
    func commonListGetListView() -> UIScrollView? {
        tableView
    }

    // MARK: - lazy

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    var viewModel = TableViewModel()

}
