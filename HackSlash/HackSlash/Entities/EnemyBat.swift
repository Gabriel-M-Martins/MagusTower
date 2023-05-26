//
//  EnemyBat.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 25/05/23.
//

import Foundation
import SpriteKit

class EnemyBat: StateMachine, Move, Attributes, DetectsCollision, Status, AI{
    
    var enemyType: EnemyType = .Bat
    
    var currentState = StatesBat.idle
    
    typealias T = SKSpriteNode
    
    var isBuffed: Bool = false
    
    var sprite: SKSpriteNode
    
    var velocity: VelocityInfo
    
    var attributes: AttributesInfo
    
    var physicsBody: SKPhysicsBody
    
    var player: Player
    
    //direction where heading. True = Right, False = Left
    var directionGoing: Bool? = nil
    
    init(sprite: String, attributes: AttributesInfo, player: Player) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.size = Constants.singleton.batSize
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: Constants.singleton.batSize)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = false
        self.physicsBody = self.sprite.physicsBody!
        self.attributes = attributes
        self.attributes.attackRange *= Double.random(in: 0.5...1)
        self.sprite.name = "Bat"
        self.currentState = .idle
        self.player = player
        self.velocity = VelocityInfo(xSpeed: attributes.velocity.xSpeed * Double.random(in: 0.5...1.5), ySpeed: attributes.velocity.ySpeed * Double.random(in: 0.5...1.5), maxXSpeed: attributes.velocity.maxXSpeed * Double.random(in: 0.5...1.5), maxYSpeed: attributes.velocity.maxYSpeed * Double.random(in: 0.5...1.5))
        self.physicsBody.allowsRotation = false
        self.changeMask(bit: Constants.singleton.playerMask)
        self.changeMask(bit: Constants.singleton.groundMask)
        self.changeMask(bit: Constants.singleton.wallMask)
        self.physicsBody.collisionBitMask -= Constants.singleton.magicMask
        self.physicsBody.categoryBitMask = Constants.singleton.enemiesMask
        self.physicsBody.collisionBitMask -= Constants.singleton.enemiesMask
        self.physicsBody.collisionBitMask -= Constants.singleton.groundMask
        self.physicsBody.collisionBitMask -= Constants.singleton.playerMask
        self.physicsBody.mass = 1
    }
    
    private func decideDirection() -> Directions4{
        var  vertical: Directions4 = .up
        if (self.sprite.position.y > self.player.sprite.position.y + self.attributes.attackRange/4) || (self.sprite.position.y > (self.player.sprite.scene!.size.height) * Double.random(in: 1.8...2.2)){
            vertical = .down
        }
        else{
            vertical = .up
        }
        return vertical
    }
    
    func moveAI(){
        switch self.currentState{
        case .idle:
            var willMove = false
            var horizontal: Directions4 = .left
            var vertical: Directions4 = .up
            
            if self.sprite.position.x > 0 && player.sprite.position.x > self.sprite.position.x/2{
                willMove = true
                horizontal = .left
                self.directionGoing = false
                var copySelf = self
                copySelf.transition(to: .flying)
            }
            else if self.sprite.position.x < 0 && player.sprite.position.x < self.sprite.position.x/2{
                willMove = true
                horizontal = .right
                self.directionGoing = true
                var copySelf = self
                copySelf.transition(to: .flying)
            }
            
            if willMove{
                vertical = decideDirection()
                
                self.move(direction: vertical)
                self.move(direction: horizontal)
            }
            
            //ataque caso esteja no range
//            else if abs(
            
        case .flying:
            let moveStrength = Double.random(in: -0.5...1)
            if let directionGoing = self.directionGoing{
                if directionGoing{
                    move(direction: .right, power: moveStrength)
                }
                else{
                    move(direction: .left)
                }
                move(direction: decideDirection(), power: moveStrength)
                
            }
        default:
            break
        }
    }
}
