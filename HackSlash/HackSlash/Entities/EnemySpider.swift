//
//  Inimigo.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 04/05/23.
//

import Foundation
import SpriteKit

class EnemySpider: StateMachine, Move {
    typealias STM = StatesSpider
    
    var currentState: StatesSpider
    
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
        self.sprite.size = CGSize(width: 120, height: 60)
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size(), center: self.sprite.position)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
        self.currentState = .idle
    }
}

