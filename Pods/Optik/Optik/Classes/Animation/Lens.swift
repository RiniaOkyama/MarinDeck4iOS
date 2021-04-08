//
//  Lens.swift
//  Optik
//
//  Created by Htin Linn on 8/2/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

/**
 *  Getter and setter pair.
 */
internal struct Lens<T, U> {
    
    /// Function for getting value from object.
    let get: (T) -> U
    
    /// Function for setting value on object.
    let set: (U, T) -> (T)
    
}
