//
//  ViewController+WKNavigationDelegate.swift
//  Marindeck
//
//  Created by a on 2022/02/05.
//
import WebKit
import SafariServices

extension ViewController: WKNavigationDelegate {
    // MARK: - 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        guard let host = url?.host else {
            decisionHandler(.cancel)
            return
        }

        if ((url?.absoluteString.contains("twitter.com/i/cards")) ?? false) ||
            (url?.absoluteString.contains("youtube.com/embed") ?? false)
        {
            decisionHandler(.cancel)
            return
        }
        
        if host == "tweetdeck.twitter.com" {
            decisionHandler(.allow)
//        }else if host.hasPrefix("t.co") {
//            decisionHandler(.cancel)
        } else if host == "mobile.twitter.com" {
            let vc = LoginViewController()
            vc.delegate = self
            let nvc = UINavigationController(rootViewController: vc)
            present(nvc, animated: true, completion: nil)
            decisionHandler(.cancel)
        }else {
            let safariVC = SFSafariViewController(url: url!)
            present(safariVC, animated: true, completion: nil)

            decisionHandler(.cancel)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.loadJsFile(forResource: "moduleraid")
//        loadJsFile(forResource: "marindeck-css")
        webView.loadJsFile(forResource: "msecdeck.bundle")
        webView.loadJsFile(forResource: "marindeck")
        webView.loadCSSFile(forResource: "marindeck")

        let cjss = try! dbQueue.read { db in
            try CustomJS.fetchAll(db)
        }
            .filter { $0.isLoad }
            .sorted(by: { $0.loadIndex < $1.loadIndex })
        for item in cjss {
            debugJS(script: item.js)
        }

        let csss = try! dbQueue.read { db in
            try CustomCSS.fetchAll(db)
        }
            .filter { $0.isLoad }
            .sorted(by: { $0.loadIndex < $1.loadIndex })
        for item in csss {
            debugCSS(css: item.css)
        }


        let theme = fetchTheme()
        debugJS(script: theme.js)

    }

}
