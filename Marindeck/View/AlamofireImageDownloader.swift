//
//  AlamofireImageDownloader.swift
//  Marindecker
//
//  Created by Rinia on 2021/01/14.
//

import Optik
import AlamofireImage

struct AlamofireImageDownloader: Optik.ImageDownloader {
    
    private let internalImageDownloader = AlamofireImage.ImageDownloader()
    
    func downloadImage(from url: URL, completion: @escaping ImageDownloaderCompletion) {
        let URLRequest = Foundation.URLRequest(url: url)
        
        internalImageDownloader.download(URLRequest, completion:  {
            response in
            
            switch response.result {
            case .success(let image):
                completion(image)
            case .failure(_):
                // Hanlde error
                return
            }
        })
    }
    
}
