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
    
    init(sprite: String) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.size = CGSize(width: 30, height: 60)
        self.sprite.physicsBody = SKPhysicsBody()
    }
}
