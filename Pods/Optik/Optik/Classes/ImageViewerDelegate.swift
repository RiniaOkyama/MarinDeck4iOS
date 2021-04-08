//
//  ImageViewerDelegate.swift
//  Optik
//
//  Created by Htin Linn on 7/17/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/**
 *  Functions declared by `ImageViewerDelegate` protocol allow the adopting delegate to respond to the image viewer
 *  events and provide resources required custom transition animation.
 */
public protocol ImageViewerDelegate: class {

    /**
     Asks delegate for the image view to be used for custom transition animation.
     
     - parameter index: Index for the image view.
     
     - returns: An image view.
     */
    func transitionImageView(for index: Int) -> UIImageView
    
    /**
     Tells the delegate that the image viewer has displayed a different image.
     
     - parameter index: Index of the new image.
     */
    func imageViewerDidDisplayImage(at index: Int)
    
}
