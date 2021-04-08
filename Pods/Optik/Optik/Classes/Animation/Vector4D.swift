//
//  Vector4D.swift
//  Optik
//
//  Created by Htin Linn on 7/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

/// 4D vector type. Internally holds a `Vector`.
internal struct Vector4D {
    
    // MARK: - Static properties
    
    /// Returns a zero-initialized `Vector4D` object.
    static var zero: Vector4D {
        return Vector4D(x: 0, y: 0, z: 0, w: 0)
    }
    
    // MARK: - Properties

    /// `x` component of the vector.
    var x: CGFloat
    
    /// `y` component of the vector.
    var y: CGFloat
    
    /// `z` component of the vector.
    var z: CGFloat
    
    /// `w` component of the vector.
    var w: CGFloat
    
    // MARK: - Init/deinit
    
    init(x: CGFloat, y: CGFloat, z: CGFloat, w: CGFloat) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    init(other: Vector4D) {
        self.init(x: other.x, y: other.y, z: other.z, w: other.w)
    }
    
}

// MARK: - Protocol conformance

// MARK: Interpolatable

extension Vector4D: Interpolatable {
    
    var values: [CGFloat] {
        return [x, y, z, w]
    }
    
}

internal prefix func -(obj: Vector4D) -> Vector4D {
    return Vector4D(
        x: -obj.x,
        y: -obj.y,
        z: -obj.z,
        w: -obj.w
    )
}

internal func +(lhs: Vector4D, rhs: Vector4D) -> Vector4D {
    return Vector4D(
        x: lhs.x + rhs.x,
        y: lhs.y + rhs.y,
        z: lhs.z + rhs.z,
        w: lhs.w + rhs.w
    )
}

internal func -(lhs: Vector4D, rhs: Vector4D) -> Vector4D {
    return Vector4D(
        x: lhs.x - rhs.x,
        y: lhs.y - rhs.y,
        z: lhs.z - rhs.z,
        w: lhs.w - rhs.w
    )
}

internal func *(lhs: Vector4D, rhs: Vector4D) -> Vector4D {
    return Vector4D(
        x: lhs.x * rhs.x,
        y: lhs.y * rhs.y,
        z: lhs.z * rhs.z,
        w: lhs.w * rhs.w
    )
}

internal func *(multiplier: CGFloat, rhs: Vector4D) -> Vector4D {
    return Vector4D(
        x: multiplier * rhs.x,
        y: multiplier * rhs.y,
        z: multiplier * rhs.z,
        w: multiplier * rhs.w
    )
}

internal func *(lhs: Vector4D, multiplier: CGFloat) -> Vector4D {
    return Vector4D(
        x: lhs.x * multiplier,
        y: lhs.y * multiplier,
        z: lhs.z * multiplier,
        w: lhs.w * multiplier
    )
}
