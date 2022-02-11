//
//  WKWebView+loadFile.swift
//  Marindeck
//
//  Created by a on 2022/01/25.
//

import Foundation
import WebKit

extension WKWebView {
    // CSSファイルをロード
    func loadCSSFile(forResource: String, ofType: String = "css") {
        guard let mtPath = Bundle.main.path(forResource: forResource, ofType: ofType) else {
            print("failed load style.css")
            return
        }
        let mtFile = FileHandle(forReadingAtPath: mtPath)!
        let mtContentData = mtFile.readDataToEndOfFile()
        let css = String(data: mtContentData, encoding: .utf8)!
        mtFile.closeFile()
        var deletecomment = css.replacingOccurrences(of: "[\\s\\t]*/\\*/?(\\n|[^/]|[^*]/)*\\*/", with: "")
        deletecomment = deletecomment.replacingOccurrences(of: "\"", with: "\\\"")
        deletecomment = deletecomment.replacingOccurrences(of: "\n", with: "\\\n")
        let script = """
                     const h = document.documentElement;
                     const s = document.createElement('style');
                     s.insertAdjacentHTML('beforeend', "\(deletecomment)");
                     h.insertAdjacentElement('beforeend', s)
                     """
        self.evaluateJavaScript(script) { _, error in
            print("stylecss : ", error ?? "成功")
        }
    }

    // JSファイルをロード
    func loadJsFile(forResource: String, ofType: String = "js") {
        guard let mtPath = Bundle.main.path(forResource: forResource, ofType: ofType) else {
            print("ERROR")
            return
        }
        let mtFile = FileHandle(forReadingAtPath: mtPath)!
        let mtContentData = mtFile.readDataToEndOfFile()
        let mtContentString = String(data: mtContentData, encoding: .utf8)!
        mtFile.closeFile()

        let mtScript = mtContentString
        self.evaluateJavaScript(mtScript) { _, error in
            print("webViewLog : ", error ?? "成功")
        }
    }
}
