//
//  Vector1D.swift
//  Optik
//
//  Created by Htin Linn on 7/26/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

/// 1D vector type. Internally holds a `Vector`.
internal struct Vector1D {
    
    // MARK: - Static properties
    
    /// Returns a zero-initialized `Vector1D` object.
    static var zero: Vector1D {
        return Vector1D(x: 0)
    }
    
    // MARK: - Properties
    
    /// `x` component of the vector.
    var x: CGFloat
    
    // MARK: - Init/deinit
    
    init(x: CGFloat) {
        self.x = x
    }
    
    init(other: Vector1D) {
        self.init(x: other.x)
    }
    
}

// MARK: - Protocol conformance

// MARK: Interpolatable

extension Vector1D: Interpolatable {
    
    var values: [CGFloat] {
        return [x]
    }
    
}

internal prefix func -(obj: Vector1D) -> Vector1D {
    return Vector1D(x: -obj.x)
}

internal func +(lhs: Vector1D, rhs: Vector1D) -> Vector1D {
    return Vector1D(x: lhs.x + rhs.x)
}

internal func -(lhs: Vector1D, rhs: Vector1D) -> Vector1D {
    return Vector1D(x: lhs.x - rhs.x)
}

internal func *(lhs: Vector1D, rhs: Vector1D) -> Vector1D {
    return Vector1D(x: lhs.x * rhs.x)
}

internal func *(multiplier: CGFloat, rhs: Vector1D) -> Vector1D {
    return Vector1D(x: multiplier * rhs.x)
}

internal func *(lhs: Vector1D, multiplier: CGFloat) -> Vector1D {
    return Vector1D(x: lhs.x * multiplier)
}

