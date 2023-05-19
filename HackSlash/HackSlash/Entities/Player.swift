//
//  File.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 02/05/23.
//

import Foundation
import SpriteKit

class Player: Status, StateMachine, Move, Attributes, DetectsCollision{
    typealias T = SKSpriteNode
    
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
    
    var isBuffed: Bool = false
    
    init(sprite: String) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.size = Constants.singleton.playerSize
        self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.singleton.playerSize.width * 0.4, height: Constants.singleton.playerSize.height), center: self.sprite.position)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
        self.sprite.physicsBody?.allowsRotation = false
        
        self.sprite.name = "Player"
        
        self.currentState = .idle
        self.attributes = AttributesInfo(health: 100, defense: Constants.singleton.playerDefense, weakness: [.neutral], velocity: VelocityInfo(xSpeed: 150, ySpeed: 300, maxXSpeed: 400, maxYSpeed: 600), attackRange: 100, maxHealth: 100)
        
        self.physicsBody.categoryBitMask = Constants.singleton.playerMask
        self.changeMask(bit: Constants.singleton.playerMask)
        self.changeMask(bit: Constants.singleton.enemiesMask)
        self.changeMask(bit: Constants.singleton.groundMask)
        self.changeMask(bit: Constants.singleton.wallMask)
        self.physicsBody.mass = 0.320000022649765
    }
}
