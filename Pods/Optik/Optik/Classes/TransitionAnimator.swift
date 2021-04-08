//
//  TransitionAnimator.swift
//  Optik
//
//  Created by Htin Linn on 6/17/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// Transition animator.
internal final class TransitionAnimator: NSObject {
    
    /**
     Modal transition type.
     
     - present: Present.
     - dismiss: Dimiss.
     */
    enum TransitionType {
        case present
        case dismiss
    }
    
    fileprivate struct Constants {
        static let animationViewShadowColor: CGColor = UIColor.black.cgColor
        static let animationViewShadowOffset: CGSize = CGSize(width: 0, height: 30)
        static let animationViewShadowRadius: CGFloat = 30
        static let animationViewShadowOpacity: Float = 0.6
        
        static let transitionDuration: TimeInterval = 0.15
    }
    
    // MARK: - Private properties
    
    private weak var fromImageView: UIImageView?
    private weak var toImageView: UIImageView?
    private weak var animationView: UIImageView?
    
    fileprivate weak var fromViewController: UIViewController?
    fileprivate weak var toViewController: UIViewController?
    
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    private let transitionType: TransitionType
    
    // MARK: - Init/deinit
    
    init(transitionType: TransitionType, fromImageView: UIImageView, toImageView: UIImageView) {
        self.transitionType = transitionType
        self.fromImageView = fromImageView
        self.toImageView = toImageView
        
        super.init()
    }
    
    // MARK: - Instance functions
    
    /**
     Updates ongoing interactive transition and moves `animationView` by specified translation.
     
     - parameter translation: Translation.
     */
    func updateInteractiveTransition(_ translation: CGPoint) {
        guard let animationView = animationView else {
            transitionContext?.completeTransition(false)
            return
        }
                
        animationView.frame = animationView.frame.offsetBy(dx: translation.x, dy: translation.y)
    }
    
    /**
     Finishes ongoing interactive transition and completes transition animation using specified velocity.
     
     - parameter velocity: Velocity.
     */
    func finishInteractiveTransition(withVelocity velocity: CGPoint) {
        performZoomAnimation(reverse: false, withVelocity: CGRect(origin: velocity, size: CGSize.zero))
    }
    
    /**
     Cancels ongoing interactive transition and reverses transition animation using specified velocity.
     
     - parameter velocity: Velocity.
     */
    func cancelInteractiveTransition(withVelocity velocity: CGPoint) {
        performFadeAnimation(reverse: true)
        performZoomAnimation(reverse: true, withVelocity: CGRect(origin: velocity, size: CGSize.zero))
    }
    
    // MARK: - Private functions
    
    fileprivate func performFadeAnimation(reverse shouldAnimateInReverse: Bool) {
        guard
            let fromViewController = fromViewController,
            let toViewController = toViewController else {
                transitionContext?.completeTransition(false)
                return
        }
        
        let viewControllerToAnimate: UIViewController
        let initialAlpha: CGFloat
        let finalAlpha: CGFloat
        
        switch transitionType {
        case .present:
            viewControllerToAnimate = toViewController
            initialAlpha = 0
            finalAlpha = 1
        case .dismiss:
            viewControllerToAnimate = fromViewController
            initialAlpha = 1
            finalAlpha = 0
        }
        
        viewControllerToAnimate.view.alpha = shouldAnimateInReverse ? finalAlpha : initialAlpha
  
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            viewControllerToAnimate.view.alpha = shouldAnimateInReverse ? initialAlpha : finalAlpha
        })
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.toImageView?.alpha = shouldAnimateInReverse ? initialAlpha : finalAlpha
        }, completion: nil)
    }
    
    private func performZoomAnimation(reverse shouldAnimateInReverse: Bool, withVelocity velocity: CGRect) {
        guard
            let transitionContainerView = transitionContext?.containerView,
            let fromImageView = fromImageView,
            let toImageView = toImageView,
            let animationView = animationView,
            let fromSuperView = fromImageView.superview,
            let toSuperView = toImageView.superview else {
                transitionContext?.completeTransition(false)
                return
        }
        
        let initialRect = fromSuperView.convert(fromImageView.frame, to: transitionContainerView)
        let finalRect = toSuperView.convert(toImageView.frame, to: transitionContainerView)
        
        if !shouldAnimateInReverse {
            switch transitionType {
            case .present:
                animationView.clipsToBounds = fromImageView.clipsToBounds
                animationView.contentMode = fromImageView.contentMode
            case .dismiss:
                animationView.clipsToBounds = toImageView.clipsToBounds
                animationView.contentMode = toImageView.contentMode
            }
            
            animationView.layer.cornerRadius = toImageView.layer.cornerRadius
        }
        
        let zoomAnimation = SpringAnimation(
            view: animationView,
            target: shouldAnimateInReverse ? initialRect : finalRect,
            velocity: velocity,
            property: ViewFrame()
        )
        zoomAnimation.onTick = { finished in
            if finished {
                animationView.removeFromSuperview()
                self.animationView = nil
                
                fromImageView.isHidden = false
                toImageView.isHidden = false

                if shouldAnimateInReverse {
                    self.transitionContext?.cancelInteractiveTransition()
                    self.transitionContext?.completeTransition(false)
                } else {
                    self.transitionContext?.finishInteractiveTransition()
                    self.transitionContext?.completeTransition(true)
                }
            }
        }
        
        transitionContainerView.animator().add(zoomAnimation)
    }
    
    fileprivate func prepareContainerView() {
        guard
            transitionType == .present,
            let transitionContainerView = transitionContext?.containerView,
            let fromView = fromViewController?.view,
            let toView = toViewController?.view else {
                return
        }
        
        transitionContainerView.insertSubview(toView, aboveSubview: fromView)
    }
    
    fileprivate func prepareImageViews() {
        guard
            let transitionContainerView = transitionContext?.containerView,
            let fromImageView = fromImageView,
            let toImageView = toImageView,
            let fromSuperView = fromImageView.superview else {
                transitionContext?.completeTransition(false)
                return
        }
        
        let animationView = UIImageView(image: fromImageView.image)
        transitionContainerView.addSubview(animationView)
        self.animationView = animationView
        
        animationView.frame = fromSuperView.convert(fromImageView.frame, to: transitionContainerView)
        animationView.layer.shadowColor = Constants.animationViewShadowColor
        animationView.layer.shadowOffset = Constants.animationViewShadowOffset
        animationView.layer.shadowRadius = Constants.animationViewShadowRadius
        animationView.layer.shadowOpacity = Constants.animationViewShadowOpacity
        
        fromImageView.isHidden = true
        toImageView.isHidden = true
    }

}

// MARK: - Protocol conformance

// MARK: UIViewControllerAnimatedTransitioning

extension TransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        startInteractiveTransition(transitionContext)
        finishInteractiveTransition(withVelocity: CGPoint(x: 0, y: 0))
    }
    
}

// MARK: UIViewControllerInteractiveTransitioning

extension TransitionAnimator: UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        prepareContainerView()
        prepareImageViews()
        performFadeAnimation(reverse: false)
    }
    
}
