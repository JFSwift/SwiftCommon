//
//  CommonViewModel.swift
//  Common
//
//  Created by JoFox on 2021/12/25.
//

import UIKit

public protocol CommonViewModel where Self: NSObject {

}

private var kError = "kError"
private var kLoading = "kLoading"

extension CommonViewModel {

    // MARK: - getters and setters
    // 页面加载loading
    public var loading: ActivityIndicator {
        getAssociatedObjectIfNilSetDefaultValue(key: &kLoading) {
            ActivityIndicator()
        }
    }

    public var error: ErrorTracker {
        getAssociatedObjectIfNilSetDefaultValue(key: &kError) {
            ErrorTracker()
        }
    }

}
