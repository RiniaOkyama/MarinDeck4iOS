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

        present(giphy, animated: true, completion: nil)
    }

    // 画像を選択
    @objc
    func openSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    // 設定を開く
    func openSettings() {
        //        self.performSegue(withIdentifier: "toSettings", sender: nil)
        let vc = storyboard?.instantiateViewController(identifier: "Settings") as! SettingsTableViewController
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(vc!, animated: true)
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

    // 下書きに保存するかどうかのアラート
    func openIfDraftAlert(text: String) {
        let alert = UIAlertController(title: "下書きに保存しますか？", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            self?.saveDraft(text: text)
        }))

        present(alert, animated: true, completion: nil)
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
        present(vc, animated: true, completion: nil)
    }

    // デバッグボタンタップ時の動作
    @objc
    func openDebugModal() {
        let vc = DebugerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    func imagePreviewer(index: Int, urls: [String]) {
        imagePreviewSelectedIndex = index

        let imgUrls = urls.map({
            TDTools.url2NomalImg($0)
        })
        print("parsed", imgUrls)

        if imgUrls.count == 0 {
            return
        }
        if imgUrls[0] == "" {
            print("imgUrl is nil")
            return
        }

        let imgs = imgUrls.compactMap({
            UIImage(url: $0)
        })

        if imgs.isEmpty {
            return
        }

        let imageViewer = Optik.imageViewer(
            withImages: imgs,
            initialImageDisplayIndex: imagePreviewSelectedIndex,
            delegate: self
        )

        imageView.image = imgs[imagePreviewSelectedIndex]
        setPreviewImagePosition()
        view.addSubview(imageView)
        //            imageViewer.presentationController?.delegate = self
        present(imageViewer, animated: true, completion: nil)
    }
}
