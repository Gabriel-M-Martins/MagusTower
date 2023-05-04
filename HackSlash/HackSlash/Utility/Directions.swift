//
//  DirectionsEnum.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 03/05/23.
//

import Foundation
import SpriteKit

enum Directions{
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
}
