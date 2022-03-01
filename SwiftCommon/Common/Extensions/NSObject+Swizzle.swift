//
//  NSObject+Swizzle.swift
//  SwiftCommon
//
//  Created by JoFox on 2022/1/21.
//

import UIKit

extension NSObject: CommonCompatible {}

// MARK: - 枚举

enum SwizzleResult {
    case success
    case failed(String)
}

// MARK: - NSObject扩展runtime方法

extension Extension where Base: NSObject {

    static func swizzleMethod(originSel: Selector, altClass: AnyClass, altSel: Selector) -> SwizzleResult {
        guard let originMethod = class_getInstanceMethod(Base.self, originSel) else {
            return .failed("original method \(originSel.description) not found for class \(Base.self.description())")
        }

        guard let altMehod = class_getInstanceMethod(altClass, altSel) else {
            return .failed("alternate method \(altSel.description) not found for class \(Base.self.description())")
        }

        guard let originIMP = class_getMethodImplementation(Base.self, originSel) else { return .failed("originIMP not found for class \(Base.self.description())") }
        guard let altIMP = class_getMethodImplementation(altClass, altSel) else { return .failed("altIMP not found for class \(Base.self.description())") }

        guard let originTypes = method_getTypeEncoding(originMethod) else { return .failed("originTypes not found for class \(Base.self.description())") }
        guard let altTypes = method_getTypeEncoding(altMehod) else { return .failed("altTypes not found for class \(Base.self.description())") }

        class_addMethod(Base.self, originSel, originIMP, originTypes)
        class_addMethod(altClass, altSel, altIMP, altTypes)

        let altedMethod = method_getImplementation(altMehod)

        let isAdded = class_addMethod(Base.self, altSel, altedMethod, altTypes)

        if isAdded, let altededMethod = class_getInstanceMethod(Base.self, altSel) {
            method_exchangeImplementations(originMethod, altededMethod)
            return .success
        }
        return .failed("")
    }

    static func swizzleMethod(originSel: Selector, altSel: Selector) -> SwizzleResult {
        guard let originMethod = class_getInstanceMethod(Base.self, originSel) else {
            return .failed("original method \(originSel.description) not found for Class \(Base.self.description())")
        }
        guard let altMethod = class_getInstanceMethod(Base.self, altSel) else {
            return .failed("alternate method \(altSel.description) not found for Class \(Base.self.description())")
        }

        guard let originIMP = class_getMethodImplementation(Base.self, originSel) else { return .failed("originIMP not found for Class \(Base.self.description())") }
        guard let altIMP = class_getMethodImplementation(Base.self, altSel) else { return .failed("altIMP not found for Class \(Base.self.description())") }

        guard let originTypes = method_getTypeEncoding(originMethod) else { return .failed("originTypes not found for Class \(Base.self.description())") }
        guard let altTypes = method_getTypeEncoding(altMethod) else { return .failed("altTypes not found for Class \(Base.self.description())") }

        class_addMethod(Base.self, originSel, originIMP, originTypes)
        class_addMethod(Base.self, altSel, altIMP, altTypes)

        if let oMethod = class_getInstanceMethod(Base.self, originSel), let aMethod = class_getInstanceMethod(Base.self, altSel) {
            method_exchangeImplementations(oMethod, aMethod)
            return .success
        }
        return .failed("")

    }
}

// MARK: 扩展中新增实例
protocol AssociatedObject {

}

extension AssociatedObject where Self: NSObject {

    /// 协议中新增实例
    /// - Returns: 当前实例
    func getAssociatedObjectIfNilSetDefaultValue<R>(key: UnsafePointer<String>, initialiser: () -> R) -> R {
        if let lookup = objc_getAssociatedObject(self, key) as? R {
            return lookup
        } else {
            let value = initialiser()
            objc_setAssociatedObject(self, key, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
    }
}

extension NSObject: AssociatedObject {}
