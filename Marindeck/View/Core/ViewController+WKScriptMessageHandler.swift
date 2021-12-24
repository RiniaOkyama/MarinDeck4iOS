//
//  ViewController+WKScriptMessageHandler.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/08.
//

import UIKit
import WebKit

// MARK: JS Binding
extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // FIXME
        
        switch JSCallbackFlag(rawValue: message.name) {
                // MARK: WKWebView Didload
        case .viewDidLoad:
            self.loadingIndicator.stopAnimating()
            if !isMainDeckViewLock {
                self.tweetFloatingBtn.isHidden = false
                self.mainDeckView.isHidden = false
            }
//            self.mainDeckView.addSubview(webView)
//            self.view.addSubview(mainDeckBlurView)

            self.view.backgroundColor = .backgroundColor
            self.webView.backgroundColor = .backgroundColor
            self.bottomBackView.backgroundColor = .backgroundColor
//            self.topBackView.backgroundColor = .topBarColor
            self.menuVC.loadViewIfNeeded()
            self.menuVC.viewDidLoad()
            self.setupWebViewToolBar()

//            self.bottomBackView.isHidden = false
            getTheme { [weak self] theme in
                if theme == .light {
                    self?.topBackView.backgroundColor = .lightTopBarColor
                    self?.setStatusBarStyle(style: fetchTheme().lightStatusBarColor)
                }else {
                    self?.topBackView.backgroundColor = .darkTopBarColor
                    self?.setStatusBarStyle(style: fetchTheme().darkStatusBarColor)
                }
            }

            webView.frame = mainDeckView.bounds
            
            if !userDefaults.bool(forKey: UserDefaultsKey.marginSafeArea) {
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                setStatusBarSpace(height: Int(statusBarHeight))
            }
            notchLogoSetup()

            menuVC.setUserIcon(url: getUserIcon())

        case .jsCallbackHandler:
            print("JS Log:", (message.body as? [String])?.joined(separator: " ") ?? "\(message.body)")

        case .imageViewPos:
            guard let imgpos = message.body as? [[Float]] else {
                return
            }
            print("IMGPOS!!!: ", imgpos)
            imagePreviewImagePositions = imgpos
//            imageView.center = view.center
//            imageView.frame.origin.y = view.frame.origin.y
            setPreviewImagePosition()

        case .openSettings:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.openSettings()
            }


        case .loadImage:
//            guard let url = (message.body as? String) else {
//                return
//            }
//            print("loading image", url)
//            url2UIImage(url: url2NomalImg(url))
            break


        case .imagePreviewer:
            guard let valueStrings = message.body as? [Any] else { return }
            guard let index = valueStrings[0] as? Int else { return }
            guard let urls = valueStrings[1] as? [String] else { return }
            self.imagePreviewer(index: index, urls: urls)

        case .isTweetButtonHidden:
            tweetFloatingBtn.isHidden = message.body as? Bool ?? false
            
        case .openYoutube:
            guard let url = message.body as? String else { return }
            guard let range = url.range(of: "?v=") else { return }
            let youtubeId = url[range.upperBound...]
            
            if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
                UIApplication.shared.canOpenURL(youtubeURL) {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else if let youtubeURL = URL(string: url) {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            }
            
        default:
            return
        }
    }
}
