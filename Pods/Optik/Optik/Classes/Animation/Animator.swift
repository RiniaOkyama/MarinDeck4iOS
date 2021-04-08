//
//  Animator.swift
//  Optik
//
//  Created by Htin Linn on 7/18/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// Animator that drives `Animatable` animations. Source: http://www.objc.io/issue-12/interactive-animations.html
internal final class Animator {
    
    private struct AssociatedKeys {
        static var ScreenDriverKey = "AssociatedKeys.ScreenDriverKey"
    }
    
    // MARK: - Properties
    
    // MARK: Private properties
    
    private var displayLink: CADisplayLink? = nil
    private var animations: [Animation] = []
    
    // MARK: - Static functions
    
    static func animatorWithScreen(_ screen: UIScreen) -> Animator {
        if let driver = objc_getAssociatedObject(screen, &AssociatedKeys.ScreenDriverKey) as? Animator {
            return driver
        } else {
            let driver = Animator(screen: screen)
            objc_setAssociatedObject(screen, &AssociatedKeys.ScreenDriverKey, driver, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return driver
        }
    }
    
    // MARK: - Init/Deinit
    
    private init(screen: UIScreen) {
        displayLink = screen.displayLink(withTarget: self, selector: #selector(Animator.animationTick(_:)))
        displayLink?.isPaused = true
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    // MARK: - Instance functions
    
    /**
     Adds an animation to the receiver.
     
     - parameter animation: Animation to be added to animator.
     */
    func add(_ animation: Animation) {
        guard !animations.contains( where: { $0 === animation } ) else {
            return
        }
        
        animations.append(animation)
        
        if animations.count == 1 {
            displayLink?.isPaused = false
        }
    }
    
    /**
     Removes an animation from receiver.
     
     - parameter animation: Animation to be removed from animator.
     */
    func remove(_ animation: Animation) {
        animations = animations.filter { (storedAnimation) in
            return storedAnimation !== animation
        }
        
        if animations.count == 0 {
            displayLink?.isPaused = true
        }
    }
    
    // MARK: - Private functions
    
    @objc private func animationTick(_ displayLink: CADisplayLink) {
        let timeElapsed = displayLink.duration
        var finishedAnimationIndices: [Int] = []
        
        animations.enumerated().forEach { (index, animation) in
            var finished = false
            animation.animationTick(timeElapsed, finished: &finished)
            
            if finished {
                finishedAnimationIndices.append(index)
            }
        }
        
        animations = animations
            .enumerated()
            .filter { !finishedAnimationIndices.contains($0.offset) }
            .map { $0.element }
        
        if animations.count == 0 {
            displayLink.isPaused = true
        }
    }
    
}
