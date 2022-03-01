//
//  ViewModel.swift
//  RxSwiftDemo
//
//  Created by JoFox on 2021/12/26.
//

import UIKit
import RxSwift
import RxRelay

class ViewModel: NSObject, CommonViewModel, ViewModelType {

    struct Input {
        let request: Observable<Void>
    }

    struct Output {
        /// 请求的结果
        let result = BehaviorRelay<String>(value: "")
    }

    /// 处理页面绑定
    /// - Parameter input: 输入源
    /// - Returns: 输出源
    func transform(input: Input) -> Output {
        let output = Output()
        input.request.flatMapLatest { [weak self] _ -> Observable<String> in
            guard let self = self else { return Observable.just("") }
            return self.requestNetForData()
        }.bind(to: output.result).disposed(by: rx.disposeBag)
        return output
    }

    func requestNetForData() -> Observable<String> {
        Observable<String>.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                observer.onNext("请求的返回结果 \(arc4random() % 10)")
                observer.onCompleted()
            }
            return Disposables.create {
            }
        }.trackError(error).trackActivity(loading)
    }

}
