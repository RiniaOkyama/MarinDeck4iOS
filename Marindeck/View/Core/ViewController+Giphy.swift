//
//  ViewController+Giphy.swift
//  Marindeck
//
//  Created by a on 2022/02/05.
//
import GiphyUISDK

extension ViewController: GiphyDelegate {
    func didSearch(for term: String) {
        print("your user made a search! ", term)
    }

    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        giphyViewController.dismiss(animated: true, completion: { [weak self] in
            //            print(media.url(rendition: .original, fileType: .gif))
            self?.loadingIndicator.startAnimating()
            self?.mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            DispatchQueue(label: "tweetgifload.async").async {
                let url: URL = URL(string: media.url(rendition: .original, fileType: .gif)!)!
                // Now use image to create into NSData format
                let imageData: NSData = NSData(contentsOf: url)!
                let data = imageData.base64EncodedString(options: [])
                DispatchQueue.main.sync {
                    self?.webView.evaluateJavaScript("addTweetImage(\"data:image/gif;base64,\(data)\", \"image/gif\", \"test.gif\")") { _, error in
                        print("gifLoad : ", error ?? "成功")
                        self?.loadingIndicator.stopAnimating()
                        self?.mainDeckBlurView.backgroundColor = .clear
                    }
                }
            }
        })
        GPHCache.shared.clear()
    }

    func didDismiss(controller: GiphyViewController?) {
        GPHCache.shared.clear()
    }
}
