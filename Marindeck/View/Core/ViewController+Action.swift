//
//  ViewController+Action.swift
//  Marindeck
//
//  Created by a on 2022/02/05.
//

import Foundation
import UIKit

protocol ViewControllerAction {
    func getPositionElements(x: Int, y: Int) -> (Int, [String])
    func openWebViewTweetModal()
    func presentAlert(_ msg: String)
}

extension ViewController: ViewControllerAction {
    // x, yに画像があれば取ってくる
    func getPositionElements(x: Int, y: Int) -> (Int, [String]) {
        guard let value = webView.evaluate(javaScript: "positionElement(\(x), \(y))") else {
            return (0, [])
        }
        let valueStrings = value as! [Any]
        let index = valueStrings[0] as! Int
        let urls = valueStrings[1] as! [String]

        let imgUrls = urls.map({
            TDTools.url2NomalImg($0)
        })
        print("getPositionElements", index, imgUrls)

        return (index, imgUrls)
    }

    // TweetDeckのツイートモーダルに遷移
    func openWebViewTweetModal() {
        webView.evaluateJavaScript("document.querySelector('.tweet-button.js-show-drawer:not(.is-hidden)').click()") { _, error in
            print("webViewLog : ", error ?? "成功")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.td.actions.focusTweetTextArea()
            }
        }
    }
    
    func presentAlert(_ msg: String) {
        let alert = UIAlertController(title: "Debugger", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
