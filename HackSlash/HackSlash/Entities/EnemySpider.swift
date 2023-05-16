//
//  Inimigo.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 04/05/23.
//

import Foundation
import SpriteKit

class EnemySpider: Status, StateMachine, Move, Attributes, DetectsCollision{
    typealias T = SKSpriteNode
    
    var currentState: StatesSpider
    
    var sprite: SKSpriteNode
    
    var physicsBody: SKPhysicsBody {
        sprite.physicsBody!
    }
    
    var position: CGPoint {
        sprite.position
    }
    
    var velocity: VelocityInfo{
        attributes.velocity
    }
    
    var attributes: AttributesInfo
    
    var player: Player
    
    var changeSide = true
    
    var despawnTime = Constants.deathDespawn
    
    var idSpider: Int
    
    var damage: Bool = false
    
    init(sprite: String, attributes: AttributesInfo, player: Player, idSpider: Int) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.size = Constants.spiderSize
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.spiderSize.width, height: Constants.spiderSize.height), center: self.sprite.position)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
        self.attributes = attributes
        self.attributes.attackRange *= Double.random(in: 0.5...1.5)
        self.sprite.name = "Spider"
        self.currentState = .idle
        self.player = player
        self.idSpider = idSpider
        self.physicsBody.allowsRotation = false
        self.changeMask(bit: Constants.playerMask)
        self.changeMask(bit: Constants.groundMask)
        self.physicsBody.collisionBitMask -= Constants.magicMask
        self.physicsBody.categoryBitMask = Constants.enemiesMask
        self.physicsBody.collisionBitMask -= Constants.enemiesMask
        self.physicsBody.mass = 0.888888955116272
        
    }
    
    func moveAI(player: SKSpriteNode){
        //Antes que ache isso nojento, é a melhor solucao para o erro de self is immutable. Caso queiram ler sobre o erro: https://github.com/apple/swift/issues/46812
        
        //Checa se a aranha está no ar ou no meio de um ataque
        switch self.currentState{
        case .idle, .walking:
            if damage{
                damage = false
            }
            
            if player.position.x > self.sprite.position.x || sprite.position.x - player.position.x > self.attributes.attackRange * 1.2{
                
                move(direction: [.left])
                var tmpSelf = self
                tmpSelf.transition(to: .walking)
                sprite.xScale = -1
                changeSide = true
                
            } else {
                
                move(direction: [.right])
                var tmpSelf = self
                tmpSelf.transition(to: .walking)
                sprite.xScale = 1
                changeSide = true
                
            }
            if abs(player.position.x - sprite.position.x) >= self.attributes.attackRange && abs(player.position.x - sprite.position.x) <= self.attributes.attackRange * 1.2{
                var tmpSelf = self
                tmpSelf.transition(to: .charging)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    tmpSelf = self
                    tmpSelf.transition(to: .goingUp)
                    //desiredHeight in x times the spider height
                    let desiredHeight: CGFloat = 1.5
                    //so pra caso a gravidade mude, muda isso aqui ou faz ser igual o valor nas constantes
                    let gravity: CGFloat = -9.8
                    
                    self.attributes.velocity.maxXSpeed *= 100
                    self.attributes.velocity.maxYSpeed *= 100
                    let direction: CGFloat = self.sprite.position.x > self.player.sprite.position.x ? -1 : 1
                    if self.currentState != .death{
                        self.physicsBody.applyImpulse(CGVector(dx:(direction * (Constants.playerSize.width/2 + Constants.spiderSize.width/2)) + (self.player.sprite.position.x - self.sprite.position.x), dy: abs(Constants.playerSize.height - Constants.spiderSize.height) + (self.player.sprite.position.y - self.sprite.position.y) + (desiredHeight * self.sprite.size.height) - (45.0 * gravity)))
                    }
                }
                self.physicsBody.velocity.dx = 0
            }
            
        case .charging:
            move(direction: [player.position.x > self.sprite.position.x ? .left : .right], power: 0.03)
            
            if changeSide {
                changeSide = false
                if sprite.xScale == -1{
                    sprite.xScale = 1
                }
                else{
                    sprite.xScale = -1
                }
            }
            
        case .goingUp:
            if self.physicsBody.velocity.dy < 0{
                self.currentState = .attack
            }
            self.physicsBody.collisionBitMask = self.physicsBody.collisionBitMask & (UInt32.max - Constants.groundMask)
            
        case .attack:
            if self.sprite.intersects(self.player.sprite){
                self.player.move(direction: [self.physicsBody.velocity.dx > 0 ? .right : .left], power: 1)
                if !damage{
                    damage = true
                    self.player.attributes.health = self.player.attributes.health - Constants.spiderDamage
                    if self.player.attributes.defense > Constants.playerDefense{
                        Constants.notificationCenter.post(name: Notification.Name("playerLessDamage"), object: nil)
                    } else {
                    Constants.notificationCenter.post(name: Notification.Name("playerDamage"), object: nil)
                    }
                }
            }
        case .death:
            return
        }
    }
}

