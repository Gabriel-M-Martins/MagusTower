//
//  Fireball.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 11/05/23.
//

import Foundation
import SpriteKit

class Fireball: MagicProjetile {
    init(angle: Double, player: Player) {
        let node = SKEmitterNode(fileNamed: "FireParticle")!
        node.position = CGPoint(x: player.sprite.position.x + (cos(angle) * Constants.playerSize.width) * 0.4, y: player.sprite.position.y + (sin(angle) * Constants.playerSize.height) * 0.3)
        node.particlePositionRange = Constants.fireballSize
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.fireballSize.dx, height: Constants.fireballSize.dy))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = 0
        node.physicsBody?.collisionBitMask = 0
        super.init(node: node, angle: angle, velocity: Constants.fireballVelocity, damage: Constants.fireballDamage)
        self.launch()
    }
}
