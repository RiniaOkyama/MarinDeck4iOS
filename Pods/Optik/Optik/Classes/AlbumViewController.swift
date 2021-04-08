//
//  AlbumViewController.swift
//  Optik
//
//  Created by Htin Linn on 5/9/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// View controller for displaying a collection of photos.
internal final class AlbumViewController: UIViewController {
    
    private struct Constants {
        static let spacingBetweenImages: CGFloat = 40
        static let dismissButtonDimension: CGFloat = 60
        
        static let transitionAnimationDuration: TimeInterval = 0.3
        static let artificialDelayDuration: TimeInterval = 0.001
    }
    
    // MARK: - Properties
    
    weak var imageViewerDelegate: ImageViewerDelegate? {
        didSet {
            guard let _ = imageViewerDelegate else {
                transitioningDelegate = nil
                
                transitionController.currentImageView = nil
                transitionController.transitionImageView = nil
                
                return
            }
            
            transitioningDelegate = transitionController
            
            transitionController.viewControllerToDismiss = self
            transitionController.currentImageView = { [weak self] in
                return self?.currentImageViewController?.imageView
            }
            transitionController.transitionImageView = { [weak self] in
                guard let currentImageIndex = self?.currentImageViewController?.index else {
                    return nil
                }
                
                return self?.imageViewerDelegate?.transitionImageView(for: currentImageIndex)
            }
        }
    }
    
    // MARK: Override properties
    
    override var prefersStatusBarHidden : Bool {
        return viewDidAppear
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: Private properties
    
    private var pageViewController: UIPageViewController
    fileprivate var currentImageViewController: ImageViewController? {
        guard let viewControllers = pageViewController.viewControllers, viewControllers.count == 1 else {
            return nil
        }
        
        return viewControllers[0] as? ImageViewController
    }
    
    private var imageData: ImageData
    private var initialImageDisplayIndex: Int
    private var activityIndicatorColor: UIColor?

    private var dismissButton: UIButton?
    private var dismissButtonImage: UIImage?
    private var dismissButtonPosition: DismissButtonPosition
    
    private var cachedRemoteImages: [URL: UIImage] = [:]
    private var viewDidAppear: Bool = false
    
    private var transitionController: TransitionController = TransitionController()
    
    // MARK: - Init/Deinit
    
    init(imageData: ImageData,
         initialImageDisplayIndex: Int,
         activityIndicatorColor: UIColor?,
         dismissButtonImage: UIImage?,
         dismissButtonPosition: DismissButtonPosition) {
        
        self.imageData = imageData
        self.initialImageDisplayIndex = initialImageDisplayIndex
        self.activityIndicatorColor = activityIndicatorColor
        self.dismissButtonImage = dismissButtonImage
        self.dismissButtonPosition = dismissButtonPosition
        
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: [UIPageViewController.OptionsKey.interPageSpacing : Constants.spacingBetweenImages])

        super.init(nibName: nil, bundle: nil)
        
        setupPageViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Invalid initializer.")
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !viewDidAppear {
            viewDidAppear = true

            // UIKit doesn't animate status bar transition on iOS 9. So, manually animate it.
            UIView.animate(withDuration: Constants.transitionAnimationDuration, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })

            // Wait for the safe area insets to be in effect and set up the constraints.
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Constants.artificialDelayDuration, execute: {
                self.setupDismissButtonConstraints()
            })
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (_) in
            self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        cachedRemoteImages = [:]
    }
    
    // MARK: - Private functions
    
    private func setupDesign() {
        view.backgroundColor = UIColor.black
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        didMove(toParent: pageViewController)
        
        setupDismissButton()
        setupPanGestureRecognizer()
    }
    
    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Set up initial image view controller.
        if let imageViewController = imageViewController(forIndex: initialImageDisplayIndex) {
            pageViewController.setViewControllers([imageViewController],
                                                  direction: .forward,
                                                  animated: false,
                                                  completion: nil)
        }
    }
    
    private func setupDismissButton() {
        let dismissButton = UIButton(type: .custom)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(dismissButtonImage, for: UIControl.State())
        dismissButton.addTarget(self, action: #selector(AlbumViewController.didTapDismissButton(_:)), for: .touchUpInside)
        view.addSubview(dismissButton)

        self.dismissButton = dismissButton
    }

    private func setupDismissButtonConstraints() {
        if #available(iOS 11.0, *), view.safeAreaInsets.top > 0 {
            // Using `safeAreaLayoutGuide` on devices other than iPhone X causes a visual glitch
            // where the button shifts down before dimissing.
            // So, restrict this to devices with top inset that is greater than 0.
            dismissButton?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        } else {
            dismissButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        }

        switch dismissButtonPosition {
        case .topLeading:
            dismissButton?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        case .topTrailing:
            dismissButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        }

        dismissButton?.widthAnchor.constraint(equalToConstant: Constants.dismissButtonDimension).isActive = true
        dismissButton?.heightAnchor.constraint(equalToConstant: Constants.dismissButtonDimension).isActive = true
    }
    
    private func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(AlbumViewController.didPan(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    fileprivate func imageViewController(forIndex index: Int) -> ImageViewController? {
        switch imageData {
        case .local(let images):
            guard index >= 0 && index < images.count else {
                return nil
            }
            
            return ImageViewController(image: images[index], index: index)
        case .remote(let urls, let imageDownloader):
            guard index >= 0 && index < urls.count else {
                return nil
            }
            
            let imageViewController = ImageViewController(activityIndicatorColor: activityIndicatorColor, index: index)
            let url = urls[index]
            
            if let image = cachedRemoteImages[url] {
                imageViewController.image = image
            } else {
                imageDownloader.downloadImage(from: url, completion: {
                    [weak self] (image) in
                    
                    self?.cachedRemoteImages[url] = image
                    imageViewController.image = image
                    })
            }
            
            return imageViewController
        }
    }
    
    @objc private func didTapDismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        transitionController.didPan(withGestureRecognizer: sender, sourceView: view)
    }
    
}

// MARK: - Protocol conformance

// MARK: UIPageViewControllerDataSource

extension AlbumViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let imageViewController = viewController as? ImageViewController else {
            return nil
        }
        
        return self.imageViewController(forIndex: imageViewController.index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let imageViewController = viewController as? ImageViewController else {
            return nil
        }
        
        return self.imageViewController(forIndex: imageViewController.index + 1)
    }
    
}

// MARK: UIPageViewControllerDelegate

extension AlbumViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool) {
        guard completed == true else {
            return
        }
        
        if previousViewControllers.count > 0 {
            previousViewControllers
                .map { $0 as? ImageViewController }
                .forEach { $0?.resetImageView() }
        }
        
        if let currentImageIndex = currentImageViewController?.index {
            imageViewerDelegate?.imageViewerDidDisplayImage(at: currentImageIndex)
        }
    }
    
}
