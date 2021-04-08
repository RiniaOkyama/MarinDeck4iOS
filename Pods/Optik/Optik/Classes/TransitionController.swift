//
//  TransitionController.swift
//  Optik
//
//  Created by Htin Linn on 7/31/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// Transition coordinator.
internal final class TransitionController: NSObject {
    
    private struct Constants {
        static let DismissTranslationThreshold: CGFloat = 50
    }
    
    // MARK: - Properties
    
    /// Function for retrieving currently displayed image view in the image viewer.
    var currentImageView: (() -> (UIImageView?))?
    
    /// Function for retrieving transition image view from the presenter.
    var transitionImageView: (() -> (UIImageView?))?
    
    /// View controller to dismiss for interactive transitions.
    weak var viewControllerToDismiss: UIViewController?
    
    // MARK: - Private properties
    
    fileprivate var dismissTransitionAnimator: TransitionAnimator?
    fileprivate var shouldDismissInteractively: Bool = false
    
    private var lastPanTranslation: CGPoint?
    
    // MARK: - Instance functions
    
    /**
     Pan gesture recognizer handler function used for interactive transitions.
     
     - parameter gestureRecognizer: Gesture recognizer.
     - parameter sourceView:        Gesture recognizer's source view.
     */
    func didPan(withGestureRecognizer gestureRecognizer: UIPanGestureRecognizer, sourceView: UIView) {
        switch gestureRecognizer.state {
        case .began:
            guard let imageView = currentImageView?() else {
                return
            }
            
            let touchLocation = gestureRecognizer.location(in: sourceView)
            let imageViewFrame = imageView.superview?.convert(imageView.frame, to: sourceView)
            
            if imageViewFrame?.contains(touchLocation) == true {
                lastPanTranslation = gestureRecognizer.translation(in: sourceView)
                shouldDismissInteractively = true
                
                // Kick off interactive transition.
                viewControllerToDismiss?.dismiss(animated: true, completion: nil)
            }
        case .changed:
            guard 
                shouldDismissInteractively,
                let dismissTransitionAnimator = dismissTransitionAnimator,
                let lastPanTranslation = lastPanTranslation else {
                    return
            }
            
            let translation = gestureRecognizer.translation(in: sourceView)
            
            // Calculate how much user's finger has moved since last time and update the transition.
            let translationDelta = CGPoint(x: translation.x - lastPanTranslation.x,
                                           y: translation.y - lastPanTranslation.y)
            dismissTransitionAnimator.updateInteractiveTransition(translationDelta)
            
            self.lastPanTranslation = translation
        case .ended:
            guard
                shouldDismissInteractively,
                let dismissTransitionAnimator = dismissTransitionAnimator else {
                    return
            }
            
            let translation = gestureRecognizer.translation(in: sourceView)
            let velocity = gestureRecognizer.velocity(in: sourceView)
            
            // Finish or cancel the transition based on how much user's finger has moved since the transition started.
            if
                abs(translation.x) > Constants.DismissTranslationThreshold ||
                abs(translation.y) > Constants.DismissTranslationThreshold {
                    dismissTransitionAnimator.finishInteractiveTransition(withVelocity: velocity)
            } else {
                dismissTransitionAnimator.cancelInteractiveTransition(withVelocity: velocity)
            }
            
            lastPanTranslation = nil
            self.dismissTransitionAnimator = nil
            shouldDismissInteractively = false
        default:
            return
        }
    }
    
}

// MARK: - Protocol conformance

// MARK: UIViewControllerTransitioningDelegate

extension TransitionController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                                                   presenting: UIViewController,
                                                                        source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            guard
                let fromImageView = transitionImageView?(),
                let toImageView = currentImageView?() else {
                    return nil
            }
            
            return TransitionAnimator(transitionType: .present, fromImageView: fromImageView, toImageView: toImageView)
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            guard
                let fromImageView = currentImageView?(),
                let toImageView = transitionImageView?() else {
                    return nil
            }
            
            dismissTransitionAnimator = TransitionAnimator(transitionType: .dismiss,
                                                           fromImageView: fromImageView,
                                                           toImageView: toImageView)
            return dismissTransitionAnimator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            guard shouldDismissInteractively && animator === dismissTransitionAnimator else {
                return nil
            }
            
            return dismissTransitionAnimator
    }
    
}
