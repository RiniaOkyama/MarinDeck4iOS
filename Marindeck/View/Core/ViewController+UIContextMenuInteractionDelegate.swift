//
//  ViewController+UIContextMenuInteractionDelegate.swift
//  Marindeck
//
//  Created by craptone on 2021/05/08.
//

import UIKit
import WebKit

import Optik
import SPAlert

// MARK: - WKWebView ui delegate
extension ViewController: WKUIDelegate {
    // delegate
//    func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
//        guard let url = elementInfo.linkURL?.absoluteString else {
//            completionHandler(nil)
//            return
//        }
//        print(url)
//        if url == "https://tweetdeck.twitter.com/#" {
//            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil)
//            completionHandler(configuration)
//            return
//        }
//        // FIXME
//        else if url.hasPrefix("https://twitter.com/") {
////            completionHandler(nil)
//            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil)
//            completionHandler(configuration)
//            return
//        }
//
//        else if url.hasPrefix("https://t.co/") {
//            let imageTweet = UIAction(title: "写真をツイート（できん）", image: UIImage(named: "tweet")!.withRenderingMode(.alwaysTemplate)) { _ in print("Send to Friend") }
//            let imageSave = UIAction(title: "写真を保存（できん）", image: UIImage(systemName: "square.and.arrow.down")) { _ in print("Send to Friend") }
//
////            let previewProvider: () -> SFSafariViewController? = { [unowned self] in
////                    return SFSafariViewController(url: elementInfo.linkURL!)
////                }
//
//            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
//              UIMenu(title: "", children: [imageTweet, imageSave])
//            }
//            completionHandler(configuration)
//        }else {
//            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil)
//            completionHandler(configuration)
//        }
//    }
}

extension ViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
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
        guard let image = url2UIImage(url: imgurl.1[imgurl.0]) else { return nil }

        let previewProvider: () -> UIViewController? = { [unowned self] in
            return ImageHapticPreviewViewController(image: image)
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: previewProvider) { suggestedActions in
            let tweetAction = UIAction(title: "画像をツイート", image: UIImage(named: "tweet")!.withRenderingMode(.alwaysTemplate)) { action in
                guard let base64img = image.pngData()?.base64EncodedString(options: []) else { return }
                self.webView.evaluateJavaScript("addTweetImage(\"data:image/png;base64,\(base64img)\", \"image/png\", \"test.png\")") { object, error in
                    print("gifLoad : ", error ?? "成功")
                }
                
            }
            let likeAction = UIAction(title: "いいね", image: UIImage(systemName: "heart.fill")!.withRenderingMode(.alwaysTemplate)) { action in
                self.positionTweetLike(x: Int(location.x), y: Int(location.y))
            }
            let saveAction = UIAction(title: "画像を保存", image: UIImage(systemName: "square.and.arrow.down")) { action in
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil);
            }
            return UIMenu(title: "", children: [tweetAction, likeAction, saveAction])
        }
    }
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.preferredCommitStyle = .pop
        animator.addCompletion {
            let imgs = self.imagePreviewImageStrings.compactMap({
                url2UIImage(url: $0)
            })
            if imgs.isEmpty { return }
            self.view.addSubview(self.imageView)
            let imageViewer = Optik.imageViewer(
                    withImages: imgs,
                    initialImageDisplayIndex: self.imagePreviewSelectedIndex,
                    delegate: self
            )
            self.present(imageViewer, animated: false, completion: nil)
        }
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            return
        }
        let alertView = SPAlertView(title: "保存しました", preset: .done)
        alertView.present(duration: 0.7)
    }
        
}

