//
//  TableViewModel.swift
//  RxSwiftDemo
//
//  Created by JoFox on 2021/12/26.
//

import UIKit
import RxSwift
import RxRelay
import NSObject_Rx

class TableViewModel: NSObject, CommonListViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output {
        let items = BehaviorRelay<[Int]>(value: [])
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        input.headerRefresh.flatMapLatest { [weak self] _ -> Observable<[Int]> in
            guard let self = self else { return Observable.just([]) }
            self.pageSize = 1
            return self.requestResultList().trackActivity(self.headerLoading)
        }.bind(to: output.items).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest { [weak self] _ -> Observable<[Int]> in
            guard let self = self else { return Observable.just([]) }
            self.pageSize += 1
            return self.requestResultList().trackActivity(self.footerLoading)
            }.subscribe(onNext: { items in
                output.items.accept(output.items.value + items)
            }).disposed(by: rx.disposeBag)
         
        return output
    }
    
    func requestResultList() -> Observable<[Int]> {
        Observable<[Int]>.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                observer.onNext([11, 22, 33, 44])
                observer.onCompleted()
            }
            return Disposables.create {
            }
        }.trackError(error).trackActivity(loading)
    }
}
