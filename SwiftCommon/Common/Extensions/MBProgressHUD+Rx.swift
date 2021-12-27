//
//  MBProgressHUD+Rx.swift
//  Common
//
//  Created by JoFox on 2021/12/26.
//

import UIKit
import RxSwift
import MBProgressHUD

extension Reactive where Base: MBProgressHUD {
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { target, active in
            if active {
                target.show(animated: true)
            } else {
                target.hide(animated: true)
            }
        }
    }
}
