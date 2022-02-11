//
//  TwitterSettingsViewController.swift
//  Marindeck
//
//  Created by a on 2022/02/11.
//

import UIKit
import WebKit

class TwitterSettingsViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    public var url = "https://mobile.twitter.com/settings"

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

        navigationController?.navigationBar.barTintColor = .label
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(self.onDismiss))
        navigationController?.navigationBar.tintColor = .label

        let myURL = URL(string: url)
        let request = URLRequest(url: myURL!)


        let jsonString = """
                         [{
                           "trigger": {
                             "url-filter": ".*"
                           },
                           "action": {
                             "type": "css-display-none",
                             "selector": "#layers"
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
            return
        }

        decisionHandler(.allow)
    }

}
