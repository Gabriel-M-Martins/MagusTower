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
        node.position = CGPoint(x: player.sprite.position.x + (cos(angle) * Constants.singleton.playerSize.width) * 0.4, y: player.sprite.position.y + (sin(angle) * Constants.singleton.playerSize.height) * 0.3)
        node.particlePositionRange = Constants.singleton.fireballSize
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.singleton.fireballSize.dx, height: Constants.singleton.fireballSize.dy))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = 0
        node.physicsBody?.collisionBitMask = 0
        super.init(node: node, angle: angle, velocity: Constants.singleton.fireballVelocity, damage: Constants.singleton.fireballDamage)
        self.launch()
    }
}
