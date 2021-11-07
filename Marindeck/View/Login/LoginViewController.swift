//
//  LoginViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/11/07.
//

import UIKit
import WebKit

protocol LoginViewControllerOutput {
    func logined()
}

class LoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    public var delegate: LoginViewControllerOutput?
    public var url = "https://mobile.twitter.com/login?hide_message=true&redirect_after_login=https://tweetdeck.twitter.com"

    var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        isModalInPresentation = true

        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(self.onDismiss))
        navigationController?.navigationBar.tintColor = .black

        let myURL = URL(string: url)
        let request = URLRequest(url: myURL!)


        let jsonString = """
                         [{
                           "trigger": {
                             "url-filter": ".*"
                           },
                           "action": {
                             "type": "css-display-none",
                             "selector": "div[aria-label=閉じる]"
                           }
                         }]
                         """

        WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "ContentBlockingRules", encodedContentRuleList: jsonString) { rulesList, error in
            if let error = error {
                print(error)
                return
            }
            guard let rulesList = rulesList else {
                return
            }
            let config = self.webView.configuration
            config.userContentController.add(rulesList)
            self.webView.load(request)
        }
    }


    @objc func onDismiss() {
        dismiss(animated: true, completion: nil)
    }


    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        guard let host = url?.host else {
            decisionHandler(.cancel)
            return
        }

        if host == "tweetdeck.twitter.com" || url?.lastPathComponent == "home" {
            decisionHandler(.cancel)
            dismiss(animated: true, completion: nil)
            delegate?.logined()
            return
        }

        decisionHandler(.allow)
    }

}
