//
//  Optik.swift
//  Optik
//
//  Created by Htin Linn on 5/14/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

// MARK: - Public functions

/**
 Creates and returns a view controller in which the specified images are displayed.
 
 - parameter images:                        Images to be displayed.
 - parameter initialImageDisplayIndex:      Index of first image to display.
 - parameter delegate:                      Image viewer delegate.
 - parameter dismissButtonImage:            Image for the dismiss button.
 - parameter dismissButtonPosition:         Dismiss button position.
 
 - returns: The created view controller.
 */
public func imageViewer(withImages images: [UIImage],
                                   initialImageDisplayIndex: Int = 0,
                                   delegate: ImageViewerDelegate? = nil,
                                   dismissButtonImage: UIImage? = nil,
                                   dismissButtonPosition: DismissButtonPosition = .topLeading) -> UIViewController {
    let albumViewController = imageViewer(withData: .local(images: images),
                                          initialImageDisplayIndex: initialImageDisplayIndex,
                                          dismissButtonImage: dismissButtonImage,
                                          dismissButtonPosition: dismissButtonPosition)
    albumViewController.modalPresentationStyle = .custom
    albumViewController.imageViewerDelegate = delegate
    
    return albumViewController
}

/**
 Creates and returns a view controller in which images from the specified URLs are downloaded and displayed.
 
 - parameter urls:                          Image URLs.
 - parameter initialImageDisplayIndex:      Index of first image to display.
 - parameter imageDownloader:               Image downloader.
 - parameter activityIndicatorColor:        Tint color of the activity indicator that is displayed while images are being downloaded.
 - parameter dismissButtonImage:            Image for the dismiss button.
 - parameter dismissButtonPosition:         Dismiss button position.
 
 - returns: The created view controller.
 */
public func imageViewer(withURLs urls: [URL],
                                 initialImageDisplayIndex: Int = 0,
                                 imageDownloader: ImageDownloader,
                                 activityIndicatorColor: UIColor = .white,
                                 dismissButtonImage: UIImage? = nil,
                                 dismissButtonPosition: DismissButtonPosition = .topLeading) -> UIViewController {
    return imageViewer(withData: .remote(urls: urls, imageDownloader: imageDownloader),
                       initialImageDisplayIndex: initialImageDisplayIndex,
                       activityIndicatorColor: activityIndicatorColor,
                       dismissButtonImage: dismissButtonImage,
                       dismissButtonPosition: dismissButtonPosition)
}

// MARK: - Private functions

private func imageViewer(withData imageData: ImageData,
                                  initialImageDisplayIndex: Int,
                                  activityIndicatorColor: UIColor? = nil,
                                  dismissButtonImage: UIImage?,
                                  dismissButtonPosition: DismissButtonPosition) -> AlbumViewController {
    let bundle = Bundle(for: AlbumViewController.self)
    let defaultDismissButtonImage = UIImage(named: "DismissIcon", in: bundle, compatibleWith: nil)

    let albumViewController = AlbumViewController(imageData: imageData,
                                                  initialImageDisplayIndex: initialImageDisplayIndex,
                                                  activityIndicatorColor: activityIndicatorColor,
                                                  dismissButtonImage: dismissButtonImage ?? defaultDismissButtonImage,
                                                  dismissButtonPosition: dismissButtonPosition)
    albumViewController.modalPresentationCapturesStatusBarAppearance = true
    
    return albumViewController
}
