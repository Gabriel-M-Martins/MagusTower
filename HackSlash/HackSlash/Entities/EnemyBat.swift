//
//  EnemyBat.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 25/05/23.
//

import Foundation
import SpriteKit

class EnemyBat: StateMachine, Move, Attributes, DetectsCollision, Status{
    
    var currentState = StatesBat.idle
    
    typealias T = SKSpriteNode
    
    var isBuffed: Bool = false
    
    var sprite: SKSpriteNode
    
    var velocity: VelocityInfo
    
    var attributes: AttributesInfo
    
    var physicsBody: SKPhysicsBody
    
    var player: Player
    
    init(sprite: String, attributes: AttributesInfo, player: Player) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.size = Constants.singleton.batSize
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: Constants.singleton.batSize)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = false
        self.physicsBody = self.sprite.physicsBody!
        self.attributes = attributes
        self.attributes.attackRange *= Double.random(in: 0.5...1.5)
        self.sprite.name = "Bat"
        self.currentState = .idle
        self.player = player
        self.velocity = attributes.velocity
        self.physicsBody.allowsRotation = false
        self.changeMask(bit: Constants.singleton.playerMask)
        self.changeMask(bit: Constants.singleton.groundMask)
        self.changeMask(bit: Constants.singleton.wallMask)
        self.physicsBody.collisionBitMask -= Constants.singleton.magicMask
        self.physicsBody.categoryBitMask = Constants.singleton.enemiesMask
        self.physicsBody.collisionBitMask -= Constants.singleton.enemiesMask
        self.physicsBody.mass = 1
    }
    
//    func moveAI(){
//        switch self.currentState{
//        case .idle:
//            var horizontal: Directions4 = .left
//            var vertical: Directions4 = .up
//            
//            if self.sprite.position > 0{
//                if 
//            }
//            
//            self.move(direction: )
//        }
//    }
}
