//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by JoFox on 2021/12/25.
//

import UIKit
import RxSwift

class ViewController: UIViewController, CommonViewControllerFull {
    
    let viewModel = ViewModel()

    /// 加载View
    func commonViewDidLoad() {

    }
    
    /// 设置View约束
    func commonLayoutSubViews() {
        
    }
    
    /// 绑定ViewModel
    func commonBindViewModel() {
        
    }
    
    /// 获取当前ViewModel进行绑定load
    /// - Returns: description
    func commonGetViewModel() -> CommonViewModel? {
        viewModel
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        button.setTitle("点击跳转列表", for: .normal)
        view.addSubview(button)
        button.setTitleColor(.blue, for: .normal)
        button.center = view.center
        button.rx.tap.subscribe(onNext: { [weak self] in
            let vc = TableViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        isLoading.subscribe(onNext: { status in
            print(status)
        }).disposed(by: rx.disposeBag)
        requestToNet()
    }
        
    func requestToNet() {
        viewModel.requestNetForData().subscribe(onNext: { data in
            print("当前模拟请求为\(data)")
        }).disposed(by: rx.disposeBag)
    }

}
