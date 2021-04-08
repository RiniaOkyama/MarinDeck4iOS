//
//  AnimatorProducible.swift
//  Optik
//
//  Created by Htin Linn on 7/18/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/**
 *  Indicates ability to produce animator objects.
 */
internal protocol AnimatorProducible {
    
    /**
     Returns animator object assoicated with the receiver.
     
     - returns: Animator object assoicted with the receiver.
     */
    func animator() -> Animator
    
}

extension UIView: AnimatorProducible {
    
    func animator() -> Animator {
        if let windowScreen = window?.screen {
            return Animator.animatorWithScreen(windowScreen)
        } else {
            return Animator.animatorWithScreen(UIScreen.main)
        }
    }
    
}
