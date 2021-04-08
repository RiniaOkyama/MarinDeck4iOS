//
//  Interpolatable.swift
//  Optik
//
//  Created by Htin Linn on 7/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

/**
 *  Defines a collection of functions required for interpolating values.
 */
internal protocol Interpolatable {
    
    /// Returns underlying values as an array. 
    var values: [CGFloat] { get }
    
    /**
     Negates specfied object and returns the result.
     
     - parameter obj: Object to negate.
     
     - returns: Result of negation.
     */
    prefix static func -(obj: Self) -> Self
    
    /**
     Adds given objects and returns the result.
     
     - parameter lhs: First operand.
     - parameter rhs: Second operand.
     
     - returns: Sum of given objects.
     */
    static func +(lhs: Self, rhs: Self) -> Self
    
    /**
     Subtracts given objects and returns the result.
     
     - parameter lhs: First operand.
     - parameter rhs: Second operand.
     
     - returns: Difference between given objects.
     */
    static func -(lhs: Self, rhs: Self) -> Self
    
    /**
     Multiplies given objects and returns the result.
     
     - parameter lhs: First operand.
     - parameter rhs: Second operand.
     
     - returns: Product of given objects.
     */
    static func *(lhs: Self, rhs: Self) -> Self
    
    /**
     Multiplies a `CGFloat` to given object and returns the result.
     
     - parameter multiplier: Multiplier.
     - parameter rhs:        Object to multiply.
     
     - returns: Result of the product.
     */
    static func *(multiplier: CGFloat, rhs: Self) -> Self
    
    /**
     Multiplies a `CGFloat` to given object and returns the result.
     
     - parameter lhs:        Object to multiply.
     - parameter multiplier: Multiplier.
     
     - returns: Result of the product.
     */
    static func *(lhs: Self, multiplier: CGFloat) -> Self
    
}
