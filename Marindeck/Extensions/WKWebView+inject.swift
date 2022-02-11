//
//  WKWebView+inject.swift
//  Marindeck
//
//  Created by a on 2022/02/11.
//

import Foundation
import WebKit

extension WKWebView {
    
    // FIXME: evaluteWithErrorは使用しない実装に変更
    // JS デバッグ
    @discardableResult
    func inject(js: String) -> (String, Error?) {
        let (ret, error) = evaluateWithError(javaScript: js)
        return ((ret as? String) ?? "", error)
    }

    // CSSをjsに変換
    static func css2JS(css: String) -> String {
        var deletecomment = css.replacingOccurrences(of: "[\\s\\t]*/\\*/?(\\n|[^/]|[^*]/)*\\*/", with: "")
        deletecomment = deletecomment.replacingOccurrences(of: "\"", with: "\\\"")
        deletecomment = deletecomment.replacingOccurrences(of: "\n", with: "\\\n")
        let script = """
                     (() => {
                     const h = document.documentElement;
                     const s = document.createElement('style');
                     s.insertAdjacentHTML('beforeend', "\(deletecomment)");
                     h.insertAdjacentElement('beforeend', s);
                     })();
                     """
        return script
    }

    // CSS デバッグ
    func inject(css: String) {
        let script = WKWebView.css2JS(css: css)
        evaluateJavaScript(script) { object, error in
            print("stylecss : ", error ?? "成功")
        }
    }

}
