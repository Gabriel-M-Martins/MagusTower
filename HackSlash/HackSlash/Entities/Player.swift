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
    
    func setEffect(effect: String){
        
        if effect != "DirtParticle" && effect != "LightiningParticle" && effect != "IceParticle" && effect != "FireParticle"{
            attributes.effect = nil
            return
        }
        
        attributes.effect = SKEmitterNode(fileNamed: effect)
        guard let effectActive = attributes.effect else { return }
        effectActive.zPosition = -1
        self.sprite.addChild(effectActive)
    }
    
    init(sprite: String) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.size = Constants.playerSize
        self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.playerSize.width * 0.4, height: Constants.playerSize.height), center: self.sprite.position)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
        self.sprite.physicsBody?.allowsRotation = false
        self.sprite.name = "Player"
        self.currentState = .idle
        self.attributes = AttributesInfo(health: 100, defense: 10, weakness: [.neutral], velocity: VelocityInfo(xSpeed: 200, ySpeed: 300, maxXSpeed: 500, maxYSpeed: 600), attackRange: 100, maxHealth: 100)
        self.physicsBody.categoryBitMask = Constants.playerMask
        self.changeMask(bit: Constants.playerMask)
        self.changeMask(bit: Constants.enemiesMask)
        self.changeMask(bit: Constants.groundMask)
        self.physicsBody.mass = 0.320000022649765
        guard let effect = attributes.effect else { return }
        self.sprite.addChild(effect)
    }
}
