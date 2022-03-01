//
//  SimpleCommonViewController.swift
//  SwiftCommon
//
//  Created by JoFox on 2022/1/21.
//

import UIKit

/// 遵循CommonViewController协议
class SimpleCommonViewController: UIViewController, CommonViewController {

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    // 加载视图
    func commonViewDidLoad() {
        view.addSubview(contentLabel)
    }

    // 视图约束
    func commonLayoutSubViews() {
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // 业务逻辑
    func commonFunctionalBusiness() {

    }

    // MARK: - Request

    // MARK: - Event Response

    // MARK: - lazy

    
    lazy var contentLabel: UILabel = {
        let label = UILabel(text: """
    *************代码结构*************

    // 生命周期
    //MARK: - Life Cycle

    // 加载视图
    func commonViewDidLoad() {

    }

    // 视图约束
    func commonLayoutSubViews() {

    }

    // 业务逻辑
    func commonFunctionalBusiness() {

    }

    // 网络请求
    //MARK: - Request

    // 点击事件
    //MARK: - Event Response

    // 懒加载属性
    //MARK: - lazy

""", style: .subheadline)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

}
