//
//  TD+Actions.swift
//  Marindeck
//
//  Created by a on 2022/01/25.
//
import Foundation

extension TD.ActionsController {
    // ツイート画面のTextViewにフォーカスする
    func focusTweetTextArea() {
        webView?.evaluateJavaScript("document.querySelector(\".js-compose-text\").focus()") { _, error in
            print("focusTweetTextArea : ", error ?? "成功")
        }
    }

    // 座標の位置にあるツイートをいいね
    func positionTweetLike(x: Int, y: Int) {
        webView?.evaluateJavaScript("touchPointTweetLike(\(x), \(y))", completionHandler: { _, error in
            print("touchPointTweetLike : ", error ?? "成功")
        })
    }

    // カラムスクロールの制御（正常に動作しません。）
    func isColumnScroll(_ bool: Bool) {
        let isScroll = bool ? "on" : "off"
        webView?.evaluateJavaScript("columnScroll.\(isScroll)()") { _, error in
            print("webViewLog : ", error ?? "成功")
        }
    }

    // ツイート
    func tweet(text: String) {
        webView?.evaluateJavaScript("postTweet('" + text + "')") { _, error in
            print("tweet : ", error ?? "成功")
        }
    }

    // FIXME: あとから出てきたheaderに適用されない。
    // top-margin
    func setStatusBarSpace(height: Int) {
        let headerHeight = height + 50
        webView?.evaluateJavaScript("""
                                   document.querySelectorAll(".column-header").forEach(function(item) {
                                       item.style.height = "\(headerHeight)px"
                                       item.style.maxHeight = "\(headerHeight)px"
                                       item.style.paddingTop = "\(height)px"
                                   })
                                   """) { _, error in
            print(#function, error ?? "成功")
        }
        webView?.evaluateJavaScript("""
                                   document.querySelectorAll(".js-detail-header").forEach(function(item) {
                                       item.style.height = "\(headerHeight)px"
                                       item.style.maxHeight = "\(headerHeight)px"
                                       item.style.paddingTop = "\(height)px"
                                   })
                                   """) { _, error in
            print(#function, error ?? "成功")
        }
    }

    // MARK: Blob
    func setBlob(url: String, base64: String, mimeType: String) {
        webView?.evaluateJavaScript("MD4iOS.Blob.set(\(url), \(base64), \(mimeType)")
    }
    
    func setSchedule(date: Date) {
        let calendar = Calendar.current
        let Y = calendar.component(.year, from: date)
        let M = calendar.component(.month, from: date)
        let D = calendar.component(.day, from: date)
        let h = calendar.component(.hour, from: date)
        let m = calendar.component(.minute, from: date)
        
        webView?.evaluateJavaScript("updateSchedule(\(Y), \(M), \(D), \(h), \(m))") { _, error in
            print(#function, error ?? "成功")
        }
    }
}
