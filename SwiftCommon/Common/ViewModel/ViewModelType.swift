//
//  ViewModelType.swift
//  Common
//
//  Created by JoFox on 2021/12/26.
//

import UIKit

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

