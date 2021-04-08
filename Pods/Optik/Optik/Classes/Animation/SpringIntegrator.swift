//
//  SpringIntegrator.swift
//  Optik
//
//  Created by Htin Linn on 7/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

/// RK4 integrator. Source: http://gafferongames.com/game-physics/integration-basics/
internal struct SpringIntegrator<T: Interpolatable> {
    
    // MARK: - Properties
    
    /// Friction constant.
    var friction: CGFloat = 28
    
    /// Spring constant.
    var spring: CGFloat = 250
    
    // MARK: - Instance functions
    
    /**
     Returns accleration based on given position and velocity.
     
     - parameter position: Position.
     - parameter velocity: Velocity.
     
     - returns: Acceleration.
     */
    func acceleration(_ position: T, velocity: T) -> T {
        return -spring * position - friction * velocity
    }
    
    /**
     Integrates given position and velocity based on the time elapsed and 
     returns changes in position and velocity over the given period.
     
     - parameter position: Position.
     - parameter velocity: Velocity.
     - parameter dt:       Time elapsed.
     
     - returns: Changes in position and velocity over the given period.
     */
    func integrate(_ position: T, velocity: T, dt: CFTimeInterval) -> (dpdt: T, dvdt: T) {
        let halfDt = CGFloat(dt) * 0.5
        
        let dp1 = velocity
        let dv1 = acceleration(position, velocity: velocity)
        
        let dp2 = velocity + halfDt * dv1
        let dv2 = acceleration(position + halfDt * dp1, velocity: dp2)
        
        let dp3 = velocity + halfDt * dv2
        let dv3 = acceleration(position + halfDt * dp2, velocity: dp3)
        
        let dp4 = velocity + CGFloat(dt) * dv3
        let dv4 = acceleration(position + CGFloat(dt) * dp3, velocity: dp4)

//        let dpdt = 0.16667 * (dp1 + 2 * (dp2 + dp3) + dp4) // 0.16667 = 1/6
//        let dvdt = 0.16667 * (dv1 + 2 * (dv2 + dv3) + dv4)
        
        let mpdt = 2 * (dp2 + dp3)
        let mvdt = 2 * (dv2 + dv3)

        let dpdt = 0.16667 * (dp1 + mpdt + dp4) // 0.16667 = 1/6
        let dvdt = 0.16667 * (dv1 + mvdt + dv4)
        
        return (dpdt, dvdt)
    }
    
}
