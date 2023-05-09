//
//  MoveHorizontal.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 03/05/23.
//

import Foundation
import SpriteKit

protocol Move {
    var velocity: VelocityInfo { get }
    var sprite: SKSpriteNode {get set}
}

extension Move{
    func move(direction: [Directions], power: Double = 1){
        let direction: Set<Directions> = Set<Directions>(direction)
      
        for direct in direction{
            sprite.physicsBody?.applyImpulse(CGVector(dx: velocity.xSpeed * direct.coordenadas.x * power, dy: velocity.ySpeed * direct.coordenadas.y * power))
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
