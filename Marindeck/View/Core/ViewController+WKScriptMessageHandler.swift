//
//  ViewController+WKScriptMessageHandler.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/08.
//

import UIKit
import WebKit
import Loaf

// MARK: JS Binding
extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name != "general" {
            return
        }

        let messageBody = (message.body as? [String: Any])

        guard let typeCast = messageBody?["type"] as? String else { return }
        let type = JSCallbackFlag(rawValue: typeCast)
        let body = messageBody?["body"] as? [String: Any]
        let uuid = messageBody?["uuid"] as? String

        // FIXME
        //        switch JSCallbackFlag(rawValue: message.name) {
        switch type {
        // MARK: WKWebView Didload
        case .viewDidLoad:
            loadingIndicator.stopAnimating()
            if !isMainDeckViewLock {
                tweetFloatingBtn.isHidden = false
                mainDeckView.isHidden = false
            }
            //            self.mainDeckView.addSubview(webView)
            //            self.view.addSubview(mainDeckBlurView)

            view.backgroundColor = .backgroundColor
            webView.backgroundColor = .backgroundColor
            bottomBackView.backgroundColor = .backgroundColor
            //            self.topBackView.backgroundColor = .topBarColor
            menuVC.loadViewIfNeeded()
            menuVC.viewDidLoad()
            setupWebViewToolBar()

            //            self.bottomBackView.isHidden = false
            td.settings.getTheme { [weak self] theme in
                if theme == .light {
                    self?.topBackView.backgroundColor = .lightTopBarColor
                    self?.setStatusBarStyle(style: fetchTheme().lightStatusBarColor)
                } else {
                    self?.topBackView.backgroundColor = .darkTopBarColor
                    self?.setStatusBarStyle(style: fetchTheme().darkStatusBarColor)
                }
            }

            webView.frame = mainDeckView.bounds

            if !userDefaults.bool(forKey: UserDefaultsKey.marginSafeArea) {
                let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
                let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                td.actions.setStatusBarSpace(height: Int(statusBarHeight))
            }
            //            notchLogoSetup()

            td.account.getAccount { [weak self] account in
                self?.menuVC.setUserIcon(url: account.profileImageUrl ?? "")
            }

        case .jsCallbackHandler:
            print("JS Log: \(String(describing: body))")

        case .imageViewPos:
            guard let imgpos = body?["positions"] as? [[Float]] else {
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
            
        case .presentAlert:
            guard let text = body?["text"] as? String else { return }
            presentAlert(text)

        case .loadImage:
            //            guard let url = (message.body as? String) else {
            //                return
            //            }
            //            print("loading image", url)
            //            url2UIImage(url: url2NomalImg(url))
            break

        // 使われていない。
        case .fetchImage:
            guard let imageUrl = body?["url"] as? String else { return }
            DispatchQueue(label: "fetchImage.async").async {
                let url: URL = URL(string: imageUrl)!
                guard let data = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.sync {
                    self.td.actions.setBlob(url: imageUrl,
                                            base64: data.base64EncodedString(options: []),
                                            mimeType: data.mimeType)
                }
            }

        case .imagePreviewer:
            guard let index = body?["selectedIndex"] as? Int else { return }
            guard let urls = body?["imageUrls"] as? [String] else { return }
            imagePreviewer(index: index, urls: urls)

        case .selectedImageBase64:
            break
        //            guard let base64 = message.body as? String else { return }
        //            let imageData = NSData(base64Encoded: base64, options: .ignoreUnknownCharacters)
        //            let iv = UIImageView(frame: view.bounds)
        //            iv.image = UIImage(data: imageData! as Data)
        //            view.addSubview(iv)

        case .isTweetButtonHidden:
            tweetFloatingBtn.isHidden = body?["value"] as? Bool ?? false

        case .openYoutube:
            guard let url = body?["url"] as? String else { return }
            guard let range = url.range(of: "?v=") else { return }
            let youtubeId = url[range.upperBound...]

            if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
               UIApplication.shared.canOpenURL(youtubeURL) {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else if let youtubeURL = URL(string: url) {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            }

        case .sidebar:
            if body?["value"] as? String == "open" {
                openMenu()
            } else if body?["value"] as? String == "close" {
                closeMenu()
            } else {}

        case .config:
            guard let action = body?["action"] as? String else { return }
            guard let key = body?["key"] as? String else { return }
            if action == "set" {
                guard let value = body?["value"] else { return }
                var configs = userDefaults.dictionary(forKey: .jsConfig)
                configs?[key] = value
                userDefaults.set(configs, forKey: .jsConfig)
            } else if action == "get" {
                let value = userDefaults.dictionary(forKey: .jsConfig)?[key]
                td.actions.send(uuid: uuid ?? "", value: value)
            } else {}
        case .openUrl:
            guard let url = body?["url"] as? String else { return }
            let vc = ModalBrowserViewController()
            vc.url = url
            present(vc, animated: true)

        case .none:
            Loaf("予期しないTypeを受信しました: \(typeCast)", state: .error, location: .top, sender: self).show()
        }
    }
}
