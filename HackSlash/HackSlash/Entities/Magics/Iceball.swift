//
//  Fireball.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 11/05/23.
//

import Foundation
import SpriteKit

class Iceball: MagicProjetile {
    init(angle: Double, player: Player) {
        let node = SKEmitterNode(fileNamed: "IceParticle")!
        node.position = CGPoint(x: player.sprite.position.x + (cos(angle) * Constants.singleton.playerSize.width) * 0.4, y: player.sprite.position.y + (sin(angle) * Constants.singleton.playerSize.height) * 0.2)
        node.particlePositionRange = Constants.singleton.iceballSize
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.singleton.iceballSize.dx, height: Constants.singleton.iceballSize.dy))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = 0
        node.physicsBody?.collisionBitMask = 0
        super.init(node: node, angle: angle, velocity: Constants.singleton.iceballVelocity, damage: Constants.singleton.iceballDamage)
        self.launch()
    }
}

