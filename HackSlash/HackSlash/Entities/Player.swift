//
//  File.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 02/05/23.
//

import Foundation
import SpriteKit

class Player: StateMachine, Move, Attributes, DetectsCollision {
    // ------------------------------------------------- state machine implementation
    var currentState: StatesPlayer
    
    // ------------------------------------------------- move implementation
    var velocity: VelocityInfo {
        attributes.velocity
    }
    
    // ------------------------------------------------- attributes implementation
    var attributes: AttributesInfo
    
    var sprite: SKSpriteNode
    
    var physicsBody: SKPhysicsBody {
        sprite.physicsBody!
    }
    
    var position: CGPoint {
        sprite.position
    }
    
    init(sprite: String) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.size = CGSize(width: 60, height: 120)
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 120), center: self.sprite.position)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
        self.sprite.name = "Player"
        self.currentState = .idle
        self.attributes = AttributesInfo(health: 10, defense: 10, weakness: [.neutral], velocity: VelocityInfo(xSpeed: 5, ySpeed: 10, maxXSpeed: 20, maxYSpeed: 5))
        self.changeMask(bit: Constants.playerMask)
        self.changeMask(bit: Constants.enemiesMask)
        self.changeMask(bit: Constants.groundMask)
    }
}
