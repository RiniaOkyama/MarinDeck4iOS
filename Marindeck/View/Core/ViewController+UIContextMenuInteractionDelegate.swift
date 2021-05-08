//
//  ViewController+UIContextMenuInteractionDelegate.swift
//  Marindeck
//
//  Created by craptone on 2021/05/08.
//

import UIKit
import WebKit

import Optik

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

        let previewProvider: () -> UIViewController? = { [unowned self] in
            return ImageHapticPreviewViewController(image: url2UIImage(url: imgurl.1[imgurl.0]))
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: previewProvider) { suggestedActions in
            let importAction = UIAction(title: "画像をツイート", image: UIImage(named: "tweet")!.withRenderingMode(.alwaysTemplate)) { action in }
            let createAction = UIAction(title: "画像を保存", image: UIImage(systemName: "square.and.arrow.down")) { action in }
            return UIMenu(title: "全部まだできないよ", children: [importAction, createAction])
        }
    }
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.preferredCommitStyle = .pop
        animator.addCompletion {
            let imgs = self.imagePreviewImageStrings.map({
                url2UIImage(url: $0)
            })
            self.view.addSubview(self.imageView)
            let imageViewer = Optik.imageViewer(
                    withImages: imgs,
                    initialImageDisplayIndex: self.imagePreviewSelectedIndex,
                    delegate: self
            )
            self.present(imageViewer, animated: false, completion: nil)
        }
    }
        
}

