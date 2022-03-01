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

    /// 处理页面绑定
    /// - Parameter input: 输入源
    /// - Returns: 输出源
    func transform(input: Input) -> Output {
        let output = Output()
        input.headerRefresh.flatMapLatest { [weak self] _ -> Observable<[Int]> in
            guard let self = self else { return Observable.just([]) }
            self.pageNow = 1
            return self.requestResultList().trackActivity(self.headerLoading)
        }.bind(to: output.items).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest { [weak self] _ -> Observable<[Int]> in
            guard let self = self else { return Observable.just([]) }
            self.pageNow += 1
            return self.requestResultList().trackActivity(self.footerLoading)
            }.subscribe(onNext: { items in
                output.items.accept(output.items.value + items)
            }).disposed(by: rx.disposeBag)
        return output
    }

    func requestResultList() -> Observable<[Int]> {
        Observable<[Int]>.create { [weak self] observer in
            let disposables = Disposables.create()
            guard let self = self else { return disposables }
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                observer.onNext(
                    Array(1...20)
                )
                if self.pageNow == 1 {
                    self.resetRefreshStatus(action: .stopHeaderRefresh(hiddenFooter: false))
                } else {
                    self.resetRefreshStatus(action: .stopFooterRefresh(showMore: false))
                }
                observer.onCompleted()
            }
            return disposables
        }.trackError(error).trackActivity(loading)
    }

}
