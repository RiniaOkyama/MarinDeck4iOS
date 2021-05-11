//
//  ViewController+WKScriptMessageHandler.swift
//  Marindeck
//
//  Created by craptone on 2021/05/08.
//

import UIKit
import WebKit

// MARK: JS Binding
extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // FIXME
        switch message.name {
                // MARK: WKWebView Didload
        case "viewDidLoad":
            self.loadingIndicator.stopAnimating()
            self.tweetFloatingBtn.isHidden = false
            self.mainDeckView.isHidden = false
//            self.mainDeckView.addSubview(webView)
//            self.view.addSubview(mainDeckBlurView)
            // FIXME
//            self.bottomBackView.backgroundColor = #colorLiteral(red: 0.1075549349, green: 0.1608583331, blue: 0.2208467424, alpha: 1)
//            self.view.backgroundColor = UIColor(hex: "F5F5F5")
//            self.bottomBackView.backgroundColor = UIColor(hex: "ffffff")
//            self.topBackView.backgroundColor = UIColor(hex: "F5F5F5")
//            self.bottomBackView.isHidden = false
            // webViewの制約設定時、AutoresizingMaskによって自動生成される制約と競合するため、自動生成をやめる
            webView.translatesAutoresizingMaskIntoConstraints = false

//            webView.anchorAll(equalTo: mainDeckView)
            webView.frame = mainDeckView.bounds
            
            #if DEBUG
//                webView.backgroundColor = .cyan
            #endif
            
            menuVC.setUserIcon(url: getUserIcon())

        case "jsCallbackHandler":
            print("JS Log:", (message.body as? [String])?.joined(separator: " ") ?? "\(message.body)")

        case "imageViewPos":
            guard let imgpos = message.body as? [Int] else {
                return
            }
            print("IMGPOS!!!: ", imgpos)
//            imageView.center = view.center
//            imageView.frame.origin.y = view.frame.origin.y

            imageView.frame = CGRect(x: imgpos[0], y: imgpos[1] + Int(UIApplication.shared.statusBarFrame.size.height), width: imgpos[2], height: imgpos[3])

        case "openSettings":
            print("openSettings")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.performSegue(withIdentifier: "toSettings", sender: nil)
            }


        case "loadImage":
//            guard let url = (message.body as? String) else {
//                return
//            }
//            print("loading image", url)
//            url2UIImage(url: url2NomalImg(url))
            break


        case "imagePreviewer":
            let valueStrings = message.body as! [Any]
            let index = valueStrings[0] as! Int
            let urls = valueStrings[1] as! [String]
            self.imagePreviewer(index: index, urls: urls)
            
        case "isTweetButtonHidden":
            tweetFloatingBtn.isHidden = message.body as? Bool ?? false
        default:
            return
        }
    }
}
