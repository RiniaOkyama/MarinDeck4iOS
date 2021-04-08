//
//  WKWebView+evalute.swift
//  Marindeck
//
//  Created by craptone on 2021/04/07.
//

import WebKit

extension WKWebView {
    @discardableResult
    func evaluate(javaScript script: String) -> Any? {
        var result: Any?
        var isCompletion: Bool = false

        self.evaluateJavaScript(script) { value, _ in
            result = value
            isCompletion = true
        }

        while !isCompletion {
            RunLoop.current.run(mode: .default, before: Date() + 0.1)
        }
        return result
    }

    @discardableResult
    func evaluateWithError(javaScript script: String) -> (Any?, Error?) {
        var result: Any?
        var error: Error?
        var isCompletion: Bool = false

        self.evaluateJavaScript(script) { value, errorLog in
            result = value
            error = errorLog
            isCompletion = true
        }

        while !isCompletion {
            RunLoop.current.run(mode: .default, before: Date() + 0.1)
        }
        return (result, error)
    }
}
