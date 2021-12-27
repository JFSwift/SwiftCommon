//
//  CommonSectionModelType.swift
//  Common
//
//  Created by JoFox on 2021/12/26.
//

import UIKit

// RxDataSources结合使用
public protocol CommonSectionModelType {
    associatedtype Item
    var items: [Item] { get }
    
    init(original: Self, items: [Item])
}

public struct TableSectionItem<T> {
    var header: String
    public var items: [T]
}

extension TableSectionItem: CommonSectionModelType {
    public typealias Item = T
    
    public init(original: TableSectionItem, items: [T]) {
        self = original
        self.items = items
    }
}
