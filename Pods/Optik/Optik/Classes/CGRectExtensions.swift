//
//  CGRectExtensions.swift
//  Optik
//
//  Created by Htin Linn on 5/6/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

internal extension CGRect {
    
    /**
     Creates and returns a CGRect resulting from shifting the reciever to ensure that it's inside the specified rectangle.
     
     - parameter surroundingRect: Rectangle that the receiver should be enclosed in.
     
     - returns: A CGRect that is the size of the receiver and is enclosed within the specified rentangle.
     */
    func enclose(_ surroundingRect: CGRect) -> CGRect {
        guard surroundingRect.width > width && surroundingRect.height > height else {
            return self
        }
        
        var enclosedRect = self
        
        // Make sure that the origin point is inside the surrounding rect
        if enclosedRect.origin.x < surroundingRect.origin.x {
            enclosedRect.origin.x = surroundingRect.origin.x
        }
        if enclosedRect.origin.y < surroundingRect.origin.y {
            enclosedRect.origin.y = surroundingRect.origin.y
        }
        
        // Make sure that the receiver doesn't extend past the surrounding rect
        if maxX > surroundingRect.maxX {
            enclosedRect.origin.x -= (maxX - surroundingRect.maxX)
        }
        if maxY > surroundingRect.maxY {
            enclosedRect.origin.y -= (maxY - surroundingRect.maxY)
        }
        
        return enclosedRect
    }
    
    /**
     Shifts the origin of the receiver to ensure that it's inside the specified rectangle.
     
     - parameter surroundingRect: Rectangle that the receiver should be enclosed in.
     */
    mutating func encloseInPlace(_ surroundingRect: CGRect) {
        self = enclose(surroundingRect)
    }
    
}
