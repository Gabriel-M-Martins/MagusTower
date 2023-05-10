//
//  Inimigo.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 04/05/23.
//

import Foundation
import SpriteKit

class EnemySpider: StateMachine, Move, Attributes, DetectsCollision{
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
    
    init(sprite: String, attributes: AttributesInfo, player: Player) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.size = CGSize(width: 200, height: 100)
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: self.sprite.size, center: self.sprite.position)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
        self.attributes = attributes
        self.sprite.name = "Spider"
        self.currentState = .idle
        self.player = player
        self.physicsBody.allowsRotation = false
        self.changeMask(bit: Constants.playerMask)
        self.changeMask(bit: Constants.enemiesMask)
        self.changeMask(bit: Constants.groundMask)
        self.physicsBody.categoryBitMask = Constants.enemiesMask
        
    }
    
    func moveAI(player: SKSpriteNode){
        //Antes que ache isso nojento, é a melhor solucao para o erro de self is immutable. Caso queiram ler sobre o erro: https://github.com/apple/swift/issues/46812
        
        //Checa se a aranha está no ar ou no meio de um ataque
        switch self.currentState{
        case .idle, .walkingRight, .walkingLeft:
            if player.position.x > self.sprite.position.x {
                move(direction: [.left])
                if currentState != .walkingLeft{
                    var tmpSelf = self
                    tmpSelf.transition(to: .walkingLeft)
                }
            } else {
                move(direction: [.right])
                if currentState != .walkingRight{
                    var tmpSelf = self
                    tmpSelf.transition(to: .walkingRight)
                }
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
                    self.physicsBody.applyImpulse(CGVector(dx: (self.player.sprite.position.x - self.sprite.position.x), dy: (self.player.sprite.position.y - self.sprite.position.y) + (desiredHeight * self.sprite.size.height) - (40.0 * gravity)))
                }
                self.physicsBody.velocity.dx = 0
            }
        case .charging:
            move(direction: [player.position.x > self.sprite.position.x ? .left : .right], power: 0.03)
        case .goingUp:
            if self.physicsBody.velocity.dy < 0{
                self.currentState = .attack
            }
            self.physicsBody.collisionBitMask = self.physicsBody.collisionBitMask & (1111111111 - Constants.groundMask)
            self.physicsBody.contactTestBitMask = self.physicsBody.contactTestBitMask & (1111111111 - Constants.groundMask)
        case .attack:
            if self.sprite.intersects(self.player.sprite){
                self.player.move(direction: [self.physicsBody.velocity.dx > 0 ? .right : .left], power: 1)
                //Causa dano no player
                
            }
        default:
            break
        }
    }
}

