//
//  ThunderCone.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 17/05/23.
//

import Foundation
import SpriteKit

class ThunderShot: MagicProjetile{

    init(angle: Double, player: Player) {
        let node = SKEmitterNode(fileNamed: "LightiningParticle")!
        node.position = CGPoint(x: player.sprite.position.x + (cos(angle) * Constants.playerSize.width) * 0.4, y: player.sprite.position.y + (sin(angle) * Constants.playerSize.height) * 0.3)
        node.particlePositionRange = Constants.lightningParticleSize
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.lightningParticleSize.dx, height: Constants.lightningParticleSize.dy))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = 0
        node.physicsBody?.collisionBitMask = 0
        super.init(node: node, angle: angle, velocity: Constants.lightningParticleVelocity, damage: Constants.lightningParticleDamage)
        let subNode = SKEmitterNode(fileNamed: "ThunderArrow")!
        subNode.particlePositionRange = Constants.lightningParticleSize
        node.addChild(subNode)
        self.launch()
    }
}
