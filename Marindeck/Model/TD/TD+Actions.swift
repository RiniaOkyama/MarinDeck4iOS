//
//  TD+Actions.swift
//  Marindeck
//
//  Created by a on 2022/01/25.
//

extension TD.ActionsController {
    // ツイート画面のTextViewにフォーカスする
    func focusTweetTextArea() {
        webView?.evaluateJavaScript("document.querySelector(\".js-compose-text\").focus()") { object, error in
            print("focusTweetTextArea : ", error ?? "成功")
        }
    }

    // 座標の位置にあるツイートをいいね
    func positionTweetLike(x: Int, y: Int) {
        webView?.evaluateJavaScript("touchPointTweetLike(\(x), \(y))", completionHandler: { object, error in
            print("touchPointTweetLike : ", error ?? "成功")
        })
    }

    // カラムスクロールの制御（正常に動作しません。）
    func isColumnScroll(_ bool: Bool) {
        let isScroll = bool ? "on" : "off"
        webView?.evaluateJavaScript("columnScroll.\(isScroll)()") { object, error in
            print("webViewLog : ", error ?? "成功")
        }
    }

    // ツイート
    func tweet(text: String) {
        webView?.evaluateJavaScript("postTweet('" + text + "')") { object, error in
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
}

