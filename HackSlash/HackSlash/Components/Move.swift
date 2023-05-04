//
//  MoveHorizontal.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 03/05/23.
//

import Foundation
import SpriteKit

protocol Move {
//    var xSpeed: Double {get}
//    var ySpeed: Double {get}
//    var maxXSpeed: Double {get}
//    var maxYSpeed: Double {get}
    var velocity: VelocityInfo { get }
    var sprite: SKSpriteNode {get set}
}

extension Move{
    func move(direction: [Directions]){
        let direction: Set<Directions> = Set<Directions>(direction)
        for direct in direction{
            sprite.physicsBody?.applyImpulse(CGVector(dx: velocity.xSpeed * direct.coordenadas.x, dy: velocity.ySpeed * direct.coordenadas.y))
        }
        if sprite.physicsBody!.velocity.dx < -velocity.maxXSpeed{
            sprite.physicsBody!.velocity.dx = -velocity.maxXSpeed
        } else if sprite.physicsBody!.velocity.dx > velocity.maxXSpeed{
            sprite.physicsBody!.velocity.dx = velocity.maxXSpeed
        }
        if sprite.physicsBody!.velocity.dy < -velocity.maxYSpeed{
            sprite.physicsBody!.velocity.dy = -velocity.maxYSpeed
        } else if sprite.physicsBody!.velocity.dy > velocity.maxYSpeed{
            sprite.physicsBody!.velocity.dy = velocity.maxYSpeed
        }
        
    }
}
