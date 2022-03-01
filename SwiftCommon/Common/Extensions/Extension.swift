//
//  CommonCompatible.swift
//  SwiftCommon
//
//  Created by JoFox on 2022/1/21.
//

import UIKit

class Extension<Base>: NSObject {

    var base: Base

    init(_ base: Base) {
        self.base = base
    }

}

/// 兼容协议
protocol CommonCompatible {

}

extension CommonCompatible {

    var common: Extension<Self> {
        Extension(self)
    }

    static var common: Extension<Self>.Type {
        Extension<Self>.self
    }

}
