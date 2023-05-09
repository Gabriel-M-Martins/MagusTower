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
    
    init(sprite: String, attributes: AttributesInfo) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.size = CGSize(width: 200, height: 100)
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: self.sprite.size, center: self.sprite.position)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
        self.attributes = attributes
        self.sprite.name = "Spider"
        self.currentState = .idle
        self.changeMask(bit: Constants.playerMask)
        self.changeMask(bit: Constants.enemiesMask)
        self.changeMask(bit: Constants.groundMask)
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
            if abs(player.position.x - sprite.position.x) >= self.attributes.attackRange{
                var tmpSelf = self
                tmpSelf.transition(to: .charging)
                self.physicsBody.velocity.dx = 0
            }
        case .charging:
            move(direction: [player.position.x > self.sprite.position.x ? .left : .right], power: 0.03)
        default:
            break
        }
    }
}

