//
//  blizzard.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 11/05/23.
//

import Foundation
import SpriteKit

class Blizzard: MagicProjetile {
    init(angle: Double, player: Player) {
        let node = SKEmitterNode(fileNamed: "BlizzardParticle")!
        node.position = CGPoint(x: player.sprite.position.x + (cos(angle) * Constants.singleton.playerSize.width) * 0.4, y: player.sprite.position.y + (sin(angle) * Constants.singleton.playerSize.height) * 0.3)
        node.particlePositionRange = Constants.singleton.blizzardSize
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.singleton.blizzardSize.dx, height: Constants.singleton.blizzardSize.dy-40))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = 0
        node.physicsBody?.collisionBitMask = 0
        super.init(node: node, angle: angle, element: .ice, velocity: Constants.singleton.blizzardVelocity, damage: Constants.singleton.blizzardDamage)
        self.launch()
    }
}
