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

        var image: UIImage?

        let vc = ImageHapticPreviewViewController(image: image)

        let previewProvider: () -> ImageHapticPreviewViewController? = { [] in
            vc
        }

        DispatchQueue.global().async {
            image = UIImage(url: imgurl.1[imgurl.0])

            DispatchQueue.main.async {
                self.imageView.image = image
                self.view.addSubview(self.imageView)
                vc.image = image
            }
        }

        setPreviewImagePosition()

        return UIContextMenuConfiguration(identifier: nil, previewProvider: previewProvider) { _ in
            let tweetAction = UIAction(title: L10n.ContextMenu.TweetImage.title,
                                       image: Asset.tweet.image.withRenderingMode(.alwaysTemplate)) { _ in
                guard let base64img = image?.pngData()?.base64EncodedString(options: []) else {
                    return
                }
                self.webView
                    .evaluateJavaScript("addTweetImage(\"data:image/png;base64,\(base64img)\", \"image/png\", \"test.png\")") { _, error in
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
                guard let image = image else { return }
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
        animator.preferredCommitStyle = .pop
        animator.addCompletion {
            let imgs = self.imagePreviewImageStrings.compactMap({
                UIImage(url: $0)
            })
            if imgs.isEmpty {
                return
            }
            self.contextMenuStruct.isOpend = true
            self.view.addSubview(self.imageView)
            let imageViewer = Optik.imageViewer(
                withImages: imgs,
                initialImageDisplayIndex: self.imagePreviewSelectedIndex,
                delegate: self
            )
            self.present(imageViewer, animated: false, completion: nil)
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
