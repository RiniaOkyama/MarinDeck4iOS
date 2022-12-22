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
            jsCallback.viewDidLoad()
            
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

extension ViewController {
    final class Callback: JSCallback {
        let vc: ViewController
        
        init(vc: ViewController) {
            self.vc = vc
        }
        func viewDidLoad() {
            vc.loadingIndicator.stopAnimating()
            if !vc.isMainDeckViewLock {
                vc.tweetFloatingBtn.isHidden = false
                vc.mainDeckView.isHidden = false
            }
            //            self.mainDeckView.addSubview(webView)
            //            self.view.addSubview(mainDeckBlurView)
            
            vc.view.backgroundColor = .backgroundColor
            vc.webView.backgroundColor = .backgroundColor
            vc.bottomBackView.backgroundColor = .backgroundColor
            //            self.topBackView.backgroundColor = .topBarColor
            vc.menuVC.loadViewIfNeeded()
            vc.menuVC.viewDidLoad()
            vc.setupWebViewToolBar()
            
            //            self.bottomBackView.isHidden = false
            vc.td.settings.getTheme { [weak self] theme in
                if theme == .light {
                    self?.vc.topBackView.backgroundColor = .lightTopBarColor
                    self?.vc.setStatusBarStyle(style: fetchTheme().lightStatusBarColor)
                } else {
                    self?.vc.topBackView.backgroundColor = .darkTopBarColor
                    self?.vc.setStatusBarStyle(style: fetchTheme().darkStatusBarColor)
                }
            }
            
            vc.webView.frame = vc.mainDeckView.bounds
            
            if !vc.userDefaults.bool(forKey: UserDefaultsKey.marginSafeArea) {
                let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
                let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                vc.td.actions.setStatusBarSpace(height: Int(statusBarHeight))
            }
            //            notchLogoSetup()
            
            vc.td.account.getAccount { [weak self] account in
                self?.vc.menuVC.setUserIcon(url: account.profileImageUrl ?? "")
            }
        }
        
        func imagePreviewer(selectedIndex: Int, urls: [String]) {
            
        }
        
        func openSettings() {
            
        }
        
        func presentAlert(message: String) {
            
        }
        
        func jsCallbackHandler(log: Any?) {
        }
        
        func imageViewPos(positions: [[Float]]) {
            
        }
        
        func fetchImage(url: String) {
            
        }
        
        func isTweetButtonState(isHidden: Bool) {
            
        }
        
        func openYoutube(url: String) {
            
        }
        
        func sidebarState(isOpen: Bool) {
        }
        
        func setConfig(key: String, value: String) {
            
        }
        
        func getConfig(key: String) -> Any? {
            return nil
        }
        
        func openUrl(url: String) {
            
        }
    }
}
