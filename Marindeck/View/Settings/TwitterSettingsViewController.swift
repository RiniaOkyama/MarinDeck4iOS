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
    lazy var dismissButton: UIButton = {
        let btn = UIButton()
        let cf = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium, scale: .default)
        btn.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: cf), for: .normal)
        btn.tintColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(dismissButton)

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            dismissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            dismissButton.widthAnchor.constraint(equalToConstant: 28),
            dismissButton.heightAnchor.constraint(equalToConstant: 28)
        ])

        dismissButton.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)

        view.bringSubviewToFront(webView)

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

    @objc
    func onDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if !(url?.path.contains("/settings") ?? true) || !(url?.host == "mobile.twitter.com") {
            decisionHandler(.cancel)
            self.dismiss(animated: true, completion: nil)
        } else {
            decisionHandler(.allow)
        }
    }
}
