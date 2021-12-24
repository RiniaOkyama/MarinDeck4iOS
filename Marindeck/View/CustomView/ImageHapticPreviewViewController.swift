//
//  ImageHapticPreviewViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/08.
//

import UIKit
import AVFoundation

class ImageHapticPreviewViewController: UIViewController {
    private let imageView = UIImageView()
    
    public var image: UIImage? = nil {
        didSet {
            preferredContentSize = image?.size ?? CGSize(width: 100, height: 100)
            imageView.image = image
        }
    }
    
    init(image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = image?.size ?? CGSize(width: 100, height: 100) // FXIME
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        view = imageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
