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
        node.position = CGPoint(x: player.sprite.position.x + (cos(angle) * Constants.singleton.playerSize.width) * 0.4, y: player.sprite.position.y + (sin(angle) * Constants.singleton.playerSize.height) * 0.3)
        node.particlePositionRange = Constants.singleton.lightningParticleSize
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.singleton.lightningParticleSize.dx, height: Constants.singleton.lightningParticleSize.dy))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = 0
        node.physicsBody?.collisionBitMask = 0
        super.init(node: node, angle: angle, element: .thunder, velocity: Constants.singleton.lightningParticleVelocity, damage: Constants.singleton.lightningParticleDamage)
        let subNode = SKEmitterNode(fileNamed: "ThunderArrow")!
        subNode.particlePositionRange = Constants.singleton.lightningParticleSize
        node.addChild(subNode)
        self.launch()
    }
}
