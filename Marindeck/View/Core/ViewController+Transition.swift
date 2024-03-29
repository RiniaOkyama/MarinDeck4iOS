//
//  ViewController+Transition.swift
//  Marindeck
//
//  Created by a on 2022/02/05.
//

import UIKit
import GiphyUISDK
import Optik
import class SwiftUI.UIHostingController

protocol Transition {
    func openSelectGif()
    func openSelectPhoto()
    func openSettings()
    func openNativeTweetModal(tweetText: String)
    func openIfDraftAlert(text: String)
    func openDraft()
    func openDebugModal()
    func imagePreviewer(index: Int, urls: [String])
    func presentDatePicker()
}

extension ViewController: Transition {
    // GIF選択画面に遷移
    @objc
    func openSelectGif() {
        let giphy = GiphyViewController()
        GiphyViewController.trayHeightMultiplier = 0.7
        giphy.shouldLocalizeSearch = true
        giphy.delegate = self
        giphy.dimBackground = true
        giphy.modalPresentationStyle = .overCurrentContext
        
        present(giphy, animated: true)
    }
    
    // 画像を選択
    @objc
    func openSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    // 設定を開く
    func openSettings() {
        let vc = storyboard?.instantiateViewController(identifier: "Settings") as! SettingsTableViewController
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
    
    // ネイティブのツイートモーダルを表示
    func openNativeTweetModal(tweetText: String = "") {
        let alert = UIAlertController(
            title: "Tweet Faster",
            message: "What's Happening!?",
            preferredStyle: .alert)
        alert.addTextField(
            configurationHandler: { _ in }
        )
        alert.textFields?[0].text = tweetText
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel) { [weak self] _ in
                    let text = alert.textFields![0].text!
                    if text == "" { return }
                    self?.openIfDraftAlert(text: text)
                }
        )
        alert.addAction(
            UIAlertAction(
                title: "Tweet",
                style: UIAlertAction.Style.default) { [weak self] _ in
                    self?.td.actions.tweet(text: alert.textFields![0].text!)
                }
        )
        present(alert, animated: true, completion: nil)
    }
    
    func openTwitterAppTweetModal() {
        if let twitterURL = URL(string: "twitter://post"),
           UIApplication.shared.canOpenURL(twitterURL) {
            UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
        } else {
            // TODO: Twitterアプリが入ってないアラート
        }
    }
    
    // 下書きに保存するかどうかのアラート
    func openIfDraftAlert(text: String) {
        let alert = UIAlertController(title: "下書きに保存しますか？", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            self?.saveDraft(text: text)
        }))
        
        present(alert, animated: true)
    }
    
    // ツイート下書きに遷移
    func openDraft() {
        let drafts = try! dbQueue.read { db in
            try Draft.fetchAll(db)
        }
        let vc = UIHostingController(rootView: DraftView(selected: { [weak self] index in
            self?.openNativeTweetModal(tweetText: drafts[index].text)
            
            _ = try! self?.dbQueue.write { db in
                try drafts[index].delete(db)
            }
        }, drafts: drafts))
        present(vc, animated: true)
    }
    
    // デバッグボタンタップ時の動作
    @objc
    func openDebugModal() {
        debuggerVC = DebugerViewController()
        debuggerVC!.delegate = self
        present(debuggerVC!, animated: true, completion: nil)
    }
    
    func imagePreviewer(index: Int, urls: [String]) {
        imagePreviewSelectedIndex = index
        loadingIndicator.startAnimating()
        mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let imgUrls = urls.map({
            TDTools.url2NomalImg($0)
        })
        print("imgUrls:", imgUrls)
        
        if imgUrls.isEmpty,
           imgUrls[0] == "" {
            return
        }
        
        Task {
            async let task1 = Task { () -> UIImage? in
                guard let imgUrl = imgUrls[safe: 0] else { return nil }
                return try? await UIImage(url: imgUrl)
            }
            async let task2 = Task { () -> UIImage? in
                guard let imgUrl = imgUrls[safe: 1] else { return nil }
                return try? await UIImage(url: imgUrl)
            }
            async let task3 = Task { () -> UIImage? in
                guard let imgUrl = imgUrls[safe: 2] else { return nil }
                return try? await UIImage(url: imgUrl)
            }
            async let task4 = Task { () -> UIImage? in
                guard let imgUrl = imgUrls[safe: 3] else { return nil }
                return try? await UIImage(url: imgUrl)
            }
            let imgs = try! await [task1.result.get(), task2.result.get(), task3.result.get(), task4.result.get()].compactMap { $0 }
            
            if imgs.isEmpty {
                return
            }
            
            let imageViewer = Optik.imageViewer(
                withImages: imgs,
                initialImageDisplayIndex: imagePreviewSelectedIndex,
                delegate: self
            )
            
            Task { @MainActor in
                imageView.image = imgs[safe: imagePreviewSelectedIndex]
                setPreviewImagePosition()
                view.addSubview(imageView)
                present(imageViewer, animated: true)
                
                loadingIndicator.stopAnimating()
                mainDeckBlurView.backgroundColor = .clear
            }
        }
    }
    
    @objc func presentDatePicker() {
        let alert = UIAlertController(title: "日付を選択", message: "", preferredStyle: .alert)
        let dp = UIDatePicker()
        let loc = Locale(identifier: "us")
        dp.locale = loc
        alert.view.addSubview(dp)
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50).isActive = true
        dp.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dp.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        alert.view.heightAnchor.constraint(equalToConstant: 142).isActive = true

        alert.addAction(.init(title: L10n.Alert.Cancel.title, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: L10n.Alert.Ok.title, style: .default, handler: { [weak self] _ in
            self?.td.actions.setSchedule(date: dp.date)
        }))
        present(alert, animated: true)
    }
}
