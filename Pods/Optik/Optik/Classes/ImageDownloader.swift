//
//  ImageDownloader.swift
//  Optik
//
//  Created by Htin Linn on 5/14/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// The completion handler closure used when an image download is completed successfully.
public typealias ImageDownloaderCompletion = (UIImage) -> ()

/**
 *  Types adopting `ImageDownloader` can be used to download images from `NSURL` objects.
 */
public protocol ImageDownloader {
    
    /**
     Downloads image from specified URL.
     
     - parameter url:        URL to download image from.
     - parameter completion: Callback handler that gets invoked after the download is complete.
     */
    func downloadImage(from url: URL, completion: @escaping ImageDownloaderCompletion)
    
}
