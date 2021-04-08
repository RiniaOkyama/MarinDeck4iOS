//
//  Animation.swift
//  Optik
//
//  Created by Htin Linn on 7/18/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/// Instances of conforming types are used by `Animator` class for custom animations.
internal protocol Animation: class {
    
    /**
     Called by an animator on every animation frame update.
     
     - parameter timeElapsed: Time elapsed since last frame update.
     - parameter finished:    true when `Animatable` types consider animation complete. false otherwise.
     */
    func animationTick(_ timeElapsed: CFTimeInterval, finished: inout Bool)
    
}
