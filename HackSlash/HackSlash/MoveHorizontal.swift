//
//  MoveHorizontal.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 03/05/23.
//

import Foundation
import SpriteKit

protocol Move {
    var xSpeed: Double {get}
    var ySpeed: Double {get}
    var maxXSpeed: Double {get}
    var maxYSpeed: Double {get}
    var sprite: SKSpriteNode {get set}
}

extension Move{
    func move(direction: [Directions]){
        let direction: Set<Directions> = Set<Directions>(direction)
        for direct in direction{
            sprite.physicsBody?.applyImpulse(CGVector(dx: xSpeed * direct.coordenadas.x, dy: ySpeed * direct.coordenadas.y))
        }
        if sprite.physicsBody!.velocity.dx < -maxXSpeed{
            sprite.physicsBody!.velocity.dx = -maxXSpeed
        } else if sprite.physicsBody!.velocity.dx > maxXSpeed{
            sprite.physicsBody!.velocity.dx = maxXSpeed
        }
        if sprite.physicsBody!.velocity.dy < -maxYSpeed{
            sprite.physicsBody!.velocity.dy = -maxYSpeed
        } else if sprite.physicsBody!.velocity.dy > maxYSpeed{
            sprite.physicsBody!.velocity.dy = maxYSpeed
        }
        
    }
}
