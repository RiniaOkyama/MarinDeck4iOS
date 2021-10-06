//
// Created by Rinia on 2021/07/16.
//


extension ViewController {
    func focusTweetTextArea() {
        webView.evaluateJavaScript("document.querySelector(\"body > div.application.js-app.is-condensed.hide-detail-view-inline > div.js-app-content.app-content.is-open > div:nth-child(1) > div > div > div > div > div > div.position-rel.compose-text-container.padding-a--10.br--4 > textarea\").focus()") { object, error in
            print("focusTweetTextArea : ", error ?? "成功")
        }
    }

    func positionTweetLike(x: Int, y: Int) {
        webView.evaluateJavaScript("touchPointTweetLike(\(x), \(y))", completionHandler: { object, error in
            print("touchPointTweetLike : ", error ?? "成功")
        })
    }

    func isColumnScroll(_ bool: Bool) {
        let isScroll = bool ? "on" : "off"
        webView.evaluateJavaScript("columnScroll.\(isScroll)()") { object, error in
            print("webViewLog : ", error ?? "成功")
        }
    }

    func getUserNameID() -> (String, String) {
        let userName = webView.evaluate(javaScript: "document.querySelector('body > div.application.js-app > header > div > div.js-account-summary > a > div > div > div > span').innerText") as? String ?? "unknown"
        let userID = webView.evaluate(javaScript: "document.querySelector('body > div.application.js-app > header > div > div.js-account-summary > a > div > div > span').innerText") as? String ?? "@unknown"
        return (userName, userID)
    }

    func getUserIcon() -> String {
        return (webView.evaluate(javaScript: "document.querySelector('body > div.application.js-app.is-condensed > header > div > div.js-account-summary > a > div > img').src") as? String) ?? "https://pbs.twimg.com/media/Ewk-ESrUYAAZYKe?format=jpg&name=medium"
    }
    
    // FIXME: あとから出てきたheaderに適用されない。
    func setStatusBarSpace(height: Int) {
        let headerHeight = height + 50
        webView.evaluateJavaScript("""
document.querySelectorAll(".column-header").forEach(function(item) {
    item.style.height = "\(headerHeight)px"
    item.style.maxHeight = "\(headerHeight)px"
    item.style.paddingTop = "\(height)px"
})
""") { _, error in
            print("setStatusBarSpace", error ?? "成功")
        }
    }

}
