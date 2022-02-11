//
//  TwitterSettingsViewController.swift
//  Marindeck
//
//  Created by a on 2022/02/11.
//

import UIKit
import WebKit
import RxWebKit
import RxSwift
import RxCocoa

class TwitterSettingsViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    public var url = "https://mobile.twitter.com/settings"

    var webView: WKWebView!
    
    private var disposeBag = DisposeBag()

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
        
        webView.rx.url
            .subscribe(onNext: {
                if !($0?.path.contains("/settings") ?? true) {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }


    @objc func onDismiss() {
        dismiss(animated: true, completion: nil)
    }
}
