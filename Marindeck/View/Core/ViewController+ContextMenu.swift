//
//  ViewController+ContextMenu.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/08.
//

import UIKit
import WebKit

import Optik
import SPAlert

// MARK: - WKWebView ui delegate
extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
        print(#function, message, frame)
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(alert, animated: true, completion: nil)
//            self.debuggerVC?.present(alert, animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default) { _ in completionHandler(true) }
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(false)}
        )
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default) { _ in
                if let textField = alert.textFields?.first {
                    completionHandler(textField.text)
                } else {
                    completionHandler("")
                }
            }
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {
            _ in completionHandler(nil)
        }
        )
        alert.addTextField { $0.text = defaultText }
        present(alert, animated: true, completion: nil)
    }
}

struct ContextMenuStruct {
    var isOpend: Bool = false
}

extension ViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let imgurl = getPositionElements(x: Int(location.x), y: Int(location.y))
        if imgurl.1.count == 0 {
            return nil
        }
        if imgurl.1[0] == "" {
            print("img is nil...")
            return nil
        }

        imagePreviewSelectedIndex = imgurl.0
        imagePreviewImageStrings = imgurl.1

        let vc = ImageHapticPreviewViewController(image: nil)

        let previewProvider: () -> ImageHapticPreviewViewController? = { [] in
            vc
        }
        
        Task {
            guard let image = try? await UIImage(url: imgurl.1[imgurl.0]) else { return }
            
            Task { @MainActor in
                self.imageView.image = image
                self.view.addSubview(self.imageView)
                vc.image = image
            }
        }

        setPreviewImagePosition()

        return UIContextMenuConfiguration(identifier: nil, previewProvider: previewProvider) { _ in
            let tweetAction = UIAction(title: L10n.ContextMenu.TweetImage.title,
                                       image: Asset.tweet.image.withRenderingMode(.alwaysTemplate)) { _ in
                guard let base64img = vc.image?.pngData()?.base64EncodedString(options: []) else {
                    return
                }
                self.webView
                    .evaluateJavaScript("window.MarinDeckInputs.addTweetImage(\"data:image/png;base64,\(base64img)\", \"image/png\", \"test.png\")") { _, error in
                        print("gifLoad : ", error ?? "成功")
                    }

            }
            let likeAction = UIAction(title: L10n.ContextMenu.Like.title,
                                      image: UIImage(systemName: "heart.fill")!
                                        .withRenderingMode(.alwaysTemplate)) { [weak self] _ in
                self?.td.actions.positionTweetLike(x: Int(location.x), y: Int(location.y))
            }
            let saveAction = UIAction(title: L10n.ContextMenu.SaveImage.title,
                                      image: UIImage(systemName: "square.and.arrow.down")) { [weak self] _ in
                guard let image = vc.image else { return }
                UIImageWriteToSavedPhotosAlbum(image,
                                               self,
                                               #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            return UIMenu(title: "", children: [tweetAction, likeAction, saveAction])
        }
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                                animator: UIContextMenuInteractionCommitAnimating) {
        loadingIndicator.startAnimating()
        mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        animator.preferredCommitStyle = .pop
        animator.addCompletion {
            Task {
                async let task1 = Task { () -> UIImage? in
                    guard let imgUrl = await self.imagePreviewImageStrings[safe: 0] else { return nil }
                    return try? await UIImage(url: imgUrl)
                }
                async let task2 = Task { () -> UIImage? in
                    guard let imgUrl = await self.imagePreviewImageStrings[safe: 1] else { return nil }
                    return try? await UIImage(url: imgUrl)
                }
                async let task3 = Task { () -> UIImage? in
                    guard let imgUrl = await self.imagePreviewImageStrings[safe: 2] else { return nil }
                    return try? await UIImage(url: imgUrl)
                }
                async let task4 = Task { () -> UIImage? in
                    guard let imgUrl = await self.imagePreviewImageStrings[safe: 3] else { return nil }
                    return try? await UIImage(url: imgUrl)
                }
                let imgs = try! await [task1.result.get(), task2.result.get(), task3.result.get(), task4.result.get()].compactMap { $0 }
                
                if imgs.isEmpty {
                    return
                }
                
                let imageViewer = Optik.imageViewer(
                    withImages: imgs,
                    initialImageDisplayIndex: self.imagePreviewSelectedIndex,
                    delegate: self
                )
                
                Task { @MainActor in
                    self.imageView.image = imgs[safe: self.imagePreviewSelectedIndex]
                    self.setPreviewImagePosition()
                    self.view.addSubview(self.imageView)
                    self.present(imageViewer, animated: true)
                    
                    self.loadingIndicator.stopAnimating()
                    self.mainDeckBlurView.backgroundColor = .clear
                }
            }
        }
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        view.addSubview(imageView)
        return UITargetedPreview(view: imageView)
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                willEndFor configuration: UIContextMenuConfiguration,
                                animator: UIContextMenuInteractionAnimating?) {
        animator?.addCompletion {
            if !self.contextMenuStruct.isOpend {
                self.imageView.removeFromSuperview()
            }
        }
    }

    @objc
    func image(_ image: UIImage,
               didFinishSavingWithError error: Error?,
               contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            return
        }
        let alertView = SPAlertView(title: L10n.ContextMenu.Saved.title, preset: .done)
        alertView.duration = 0.3
        alertView.present()
    }

}
