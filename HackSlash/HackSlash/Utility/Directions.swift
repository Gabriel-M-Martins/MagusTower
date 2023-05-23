//
//  DirectionsEnum.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 03/05/23.
//

import Foundation
import SpriteKit

enum Directions8: Int {
    case up, right, down, left, upRight, upLeft, downRight, downLeft
    
    var coordenadas: (x: Double, y:Double) {
        switch self{
        case .up:
            return (0,1)
        case .right:
            return (1,0)
        case .down:
            return (0,-1)
        case .left:
            return (-1,0)
        case .upLeft:
            return (-1, 1)
        case .upRight:
            return (1, 1)
        case .downLeft:
            return (-1, -1)
        case .downRight:
            return (1, -1)
        }
    }
    
    static private func calcAngle(_ v: CGPoint) -> CGFloat {
        var at = CGFloat()
        
        if v.x < 0 {
            at = CGFloat.pi + atan(v.y / v.x)
        } else {
            if v.y > 0 {
                at = atan(v.y / v.x)
            } else {
                at = (2 * CGFloat.pi) + atan(v.y / v.x)
            }
        }
        
        return at
    }
    
    static func calculateDirections(_ vector: CGPoint) -> Self {
        let degrees = atan2(vector.y, vector.x) * 180 / CGFloat.pi
        
        if degrees <= -145 {
            return .left
        }
        
        if degrees <= -105 {
            return .downLeft
        }
        
        if degrees <= -75 {
            return .down
        }
        
        if degrees <= -35 {
            return .downRight
        }
        
        if degrees <= 35 {
            return .right
        }
        
        if degrees <= 75 {
            return .upRight
        }
        
        if degrees <= 105 {
            return .up
        }
        
        if degrees <= 145 {
            return .upLeft
        }
            
        return .left
    }
}

enum Directions4: Int {
    case up, right, down, left
    
    var coordenadas: (x: Double, y:Double) {
        switch self{
        case .up:
            return (0,1)
        case .right:
            return (1,0)
        case .down:
            return (0,-1)
        case .left:
            return (-1,0)
        }
    }
    
    static func calculateDirections(_ vector: CGPoint) -> Self {
        let degrees = atan2(vector.y, vector.x) * 180 / CGFloat.pi
        
        if degrees <= -135 {
            return .left
        }
        
        if degrees <= -45 {
            return .down
        }
        
        if degrees <= 45 {
            return .right
        }
        
        if degrees <= 135 {
            return .up
        }
            
        return .left
    }
}
