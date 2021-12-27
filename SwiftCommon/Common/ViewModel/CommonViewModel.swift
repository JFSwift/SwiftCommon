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
    
    //MARK: - getters and setters
    // 页面加载loading
    public var loading: ActivityIndicator {
        if let aValue = objc_getAssociatedObject(self, &kLoading) as? ActivityIndicator {
            return aValue
        }else {
            let aValue = ActivityIndicator()
            objc_setAssociatedObject(self, &kLoading, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return aValue
        }
    }
    
    public var error: ErrorTracker {
        get {
            if let aValue = objc_getAssociatedObject(self, &kError) as? ErrorTracker {
                return aValue
            }else {
                let aValue = ErrorTracker()
                objc_setAssociatedObject(self, &kError, aValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aValue
            }
        }
    }
    
}
