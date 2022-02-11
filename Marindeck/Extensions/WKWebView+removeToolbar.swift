//
//  WKWebView+removeToolbar.swift
//  Marindeck
//
//  Created by Rinia on 2021/04/18.
//

import Foundation
import WebKit

extension WKWebView {
    func removeToolBar() {
        guard let target = scrollView.subviews.first(where: {
            String(describing: type(of: $0)).hasPrefix("WKContent")
        }), let superclass = target.superclass else {
            return
        }

        let noInputAccessoryViewClassName = "\(superclass)_NoInputAccessoryView"
        var newClass: AnyClass? = NSClassFromString(noInputAccessoryViewClassName)

        if newClass == nil,
           let targetClass = object_getClass(target),
           let classNameCString = noInputAccessoryViewClassName.cString(using: .ascii) {
            newClass = objc_allocateClassPair(targetClass, classNameCString, 0)

            if let newClass = newClass {
                objc_registerClassPair(newClass)
            }
        }

        guard let noInputAccessoryClass = newClass,
              let originalMethod = class_getInstanceMethod(
                NoInputAccessoryView.self,
                #selector(getter: NoInputAccessoryView.inputAccessoryView)) else {
            return
        }
        class_addMethod(noInputAccessoryClass.self,
                        #selector(getter: NoInputAccessoryView.inputAccessoryView),
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod))
        object_setClass(target, noInputAccessoryClass)
    }
}

fileprivate final class NoInputAccessoryView: NSObject {
    @objc var inputAccessoryView: AnyObject? { return nil }
}

// https://qiita.com/mopiemon/items/8d0dd7d678c4dadeadd4s
private var ToolbarHandle: UInt8 = 0

extension WKWebView {
    func addIndexAccessoryView(toolbar: UIView?) {
        guard let toolbar = toolbar else { return }
        objc_setAssociatedObject(self,
                                 &ToolbarHandle,
                                 toolbar,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        var candidateView: UIView?
        for view in self.scrollView.subviews {
            let description: String = String(describing: type(of: view))
            if description.hasPrefix("WKContent") {
                candidateView = view
                break
            }
        }
        guard let targetView = candidateView else { return }
        let newClass: AnyClass? = classWithCustomAccessoryView(targetView: targetView)

        guard let targetNewClass = newClass else { return }
        object_setClass(targetView, targetNewClass)
    }

    func classWithCustomAccessoryView(targetView: UIView) -> AnyClass? {
        guard let _ = targetView.superclass else { return nil }
        let customInputAccessoryViewClassName = "_CustomInputAccessoryView"
        var newClass: AnyClass? = NSClassFromString(customInputAccessoryViewClassName)

        if newClass == nil {
            newClass = objc_allocateClassPair(object_getClass(targetView), customInputAccessoryViewClassName, 0)
        } else {
            return newClass
        }

        let newMethod = class_getInstanceMethod(WKWebView.self, #selector(WKWebView.getCustomInputAccessoryView))

        class_addMethod(newClass.self,
                        #selector(getter: WKWebView.inputAccessoryView),
                        method_getImplementation(newMethod!),
                        method_getTypeEncoding(newMethod!)
        )
        objc_registerClassPair(newClass!)
        return newClass
    }

    @objc func getCustomInputAccessoryView() -> UIView? {
        var superWebView: UIView? = self
        while (superWebView != nil) && !(superWebView is WKWebView) {
            superWebView = superWebView?.superview // == WKWebView
        }
        guard let webView = superWebView else { return nil }

        let customInputAccessory = objc_getAssociatedObject(webView, &ToolbarHandle)
        return customInputAccessory as? UIView
    }
}
