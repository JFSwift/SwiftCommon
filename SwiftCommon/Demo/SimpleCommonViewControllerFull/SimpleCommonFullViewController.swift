//
//  SimpleCommonFullViewController.swift
//  RxSwiftDemo
//
//  Created by JoFox on 2021/12/25.
//

import UIKit
import RxSwift

class SimpleCommonFullViewController: UIViewController, CommonFullViewController {

    // MARK: - Life Cycle

    /// 加载View
    func commonViewDidLoad() {
        view.addSubview(contentLabel)
        view.addSubview(netButton)
        view.addSubview(contentLabel1)
        view.addSubview(netButton1)
    }

    /// 设置View约束
    func commonLayoutSubViews() {
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(100)
            make.top.equalTo(108)
        }
        netButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
        }

        contentLabel1.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(100)
            make.top.equalTo(netButton.snp.bottom).offset(15)
        }
        netButton1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentLabel1.snp.bottom).offset(15)
        }
    }

    /// 业务逻辑
    func commonFunctionalBusiness() {
        netButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.requestToNet()
        }).disposed(by: rx.disposeBag)
    }

    /// 绑定ViewModel
    func commonBindViewModel() {
        // viewModel input调用
        netButton1.rx.tap.bind(to: request).disposed(by: rx.disposeBag)
        let input = ViewModel.Input(request: request)
        let output = viewModel.transform(input: input)
        output.result.bind(to: contentLabel1.rx.text).disposed(by: rx.disposeBag)
    }

    /// 获取当前ViewModel进行绑定load
    /// - Returns: description
    func commonGetViewModel() -> CommonViewModel? {
        viewModel
    }

    // MARK: - Request

    /// 直接调用
    func requestToNet() {
        viewModel.requestNetForData().bind(to: contentLabel.rx.text).disposed(by: rx.disposeBag)
    }

    // MARK: - lazy

    let request: PublishSubject<Void> = PublishSubject()

    let viewModel = ViewModel()

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    lazy var netButton: UIButton = {
        let button = UIButton()
        button.setTitle("常规网络请求", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    lazy var contentLabel1: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    lazy var netButton1: UIButton = {
        let button = UIButton()
        button.setTitle("rx方式网络请求", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

}
