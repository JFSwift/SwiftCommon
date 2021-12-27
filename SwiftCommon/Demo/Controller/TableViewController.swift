//
//  TableViewController.swift
//  RxSwiftDemo
//
//  Created by JoFox on 2021/12/26.
//

import UIKit
import NSObject_Rx
import SwifterSwift

class TableViewController: UIViewController, CommonListViewController {

    let tableView = UITableView(frame: .zero, style: .grouped)
    let viewModel = TableViewModel()

    /// 加载View
    func commonViewDidLoad() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(cellWithClass: UITableViewCell.self)
    }
    
    /// 设置View约束
    func commonLayoutSubViews() {
        
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
    
}
