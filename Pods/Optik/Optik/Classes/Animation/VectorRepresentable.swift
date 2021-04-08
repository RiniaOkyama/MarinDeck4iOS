//
//  VectorRepresentable.swift
//  Optik
//
//  Created by Htin Linn on 7/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

/**
 *  A type that can be converted to and from an array of `CGFloat` and used as a `Vector` type.
 */
internal protocol VectorRepresentable {
    
    associatedtype InterpolatableType: Interpolatable

    /**
     Initializes from a vector.

     - parameter vector: Vector.
     
     - returns: Initialized object.
     */
    init(vector: InterpolatableType)
    
    /// Convert to a vector.
    var vector: InterpolatableType { get }
    
}

// MARK: - Extensions

// MARK: CGRect

extension CGRect: VectorRepresentable {
    
    typealias InterpolatableType = Vector4D
    
    init(vector: InterpolatableType) {
        self.init(x: vector.x, y: vector.y, width: vector.z, height: vector.w)
    }
    
    var vector: InterpolatableType {
        return Vector4D(x: origin.x, y: origin.y, z: size.width, w: size.height)
    }
    
}

// MARK: CGFloat

extension CGFloat: VectorRepresentable {
    
    typealias InterpolatableType = Vector1D
    
    init(vector: InterpolatableType) {
        self = vector.x
    }
    
    var vector: InterpolatableType {
        return Vector1D(x: self)
    }
    
}

