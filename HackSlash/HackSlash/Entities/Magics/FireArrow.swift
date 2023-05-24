//
//  Fireball.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 11/05/23.
//

import Foundation
import SpriteKit

class FireArrow: MagicProjetile {
    init(angle: Double, player: Player) {
        let node = SKEmitterNode(fileNamed: "FireArrow")!
        node.position = CGPoint(x: player.sprite.position.x + (cos(angle) * Constants.singleton.playerSize.width) * 0.4, y: player.sprite.position.y + (sin(angle) * Constants.singleton.playerSize.height) * 0.3)
        node.particlePositionRange = Constants.singleton.fireArrowSize
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.singleton.fireArrowSize.dx, height: Constants.singleton.fireArrowSize.dy))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = 0
        node.physicsBody?.collisionBitMask = 0
        super.init(node: node, angle: angle, element: .fire, velocity: Constants.singleton.fireballVelocity, damage: Constants.singleton.fireballDamage)
        //precisa ser dps do super.init
        self.node.name = "FireArrow"
        self.launch()
    }
}

class FireArrowSmoke{
    var node: SKEmitterNode
    init(father: SKEmitterNode) {
        self.node = SKEmitterNode(fileNamed: "FireArrowSmoke")!
        self.node.particlePositionRange = father.particlePositionRange
        self.node.position = father.position
        father.parent!.addChild(self.node)
        father.physicsBody = nil
        father.run(SKAction.sequence([
            .run{
                father.particleBirthRate = 0
            },
            .wait(forDuration: 3),
            .removeFromParent()
        ]))
        self.node.run(SKAction.sequence([
            .wait(forDuration: 2),
            .run{
                self.node.particleBirthRate = 0
                FireExplosion(father: self.node)
            },
            .wait(forDuration: 0.5),
            .removeFromParent()
        ]))
    }
}

class FireExplosion{
    var node: SKEmitterNode
    init(father: SKEmitterNode){
        self.node = SKEmitterNode(fileNamed: "FireExplosion")!
        self.node.name = "FireExplosion"
        self.node.particlePositionRange = father.particlePositionRange
        self.node.position = father.position
        father.parent!.addChild(self.node)
        self.node.physicsBody = SKPhysicsBody(circleOfRadius: max(father.particlePositionRange.dx, father.particlePositionRange.dy) * 0.6)
        self.node.physicsBody?.categoryBitMask = 0
        self.node.physicsBody?.contactTestBitMask |= Constants.singleton.enemiesMask
        self.node.physicsBody?.isDynamic = false
        self.node.run(SKAction.sequence([
            .scale(to: 3, duration: 0.2),
            .wait(forDuration: 1),
            .scale(to: 0, duration: 0.2),
            .removeFromParent()
        ]))
    }
}


