//
//  File.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 02/05/23.
//

import Foundation
import SpriteKit

class Player: StateMachine {
    typealias STM = StatesPlayer
    
    var sprite: SKSpriteNode
    
    var physicsBody: SKPhysicsBody {
        sprite.physicsBody!
    }
    
    var position: CGPoint {
        sprite.position
    }
    
    var xSpeed: Double = 5
    var ySpeed: Double = 10
    
    var maxXSpeed: Double = 20
    var maxYSpeed: Double = 5
    
    init(sprite: String) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.size = CGSize(width: 60, height: 120)
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 120), center: self.sprite.position)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
    }
}
