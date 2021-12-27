//
//  ViewModel.swift
//  RxSwiftDemo
//
//  Created by JoFox on 2021/12/26.
//

import UIKit
import RxSwift

class ViewModel: NSObject, CommonViewModel {

    func requestNetForData() -> Observable<String> {
        Observable<String>.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                observer.onNext("data")
                observer.onCompleted()
            }
            return Disposables.create {
            }
        }.trackError(error).trackActivity(loading)
    }
}
