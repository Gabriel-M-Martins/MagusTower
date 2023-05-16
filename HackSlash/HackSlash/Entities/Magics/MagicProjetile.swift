//
//  Fireball.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 11/05/23.
//

import Foundation
import SpriteKit

class MagicProjetile: Projectile, DetectsCollision{
    var physicsBody: SKPhysicsBody
    
    var node: SKEmitterNode
    
    var angle: Double
    
    var velocity: VelocityInfo
    
    var damage: AttackInfo
    
    init(node: SKEmitterNode, angle: Double, velocity: VelocityInfo, damage: AttackInfo) {
        self.node = node
        self.node.name = "Magic"
        self.physicsBody = node.physicsBody!
        self.angle = angle
        self.velocity = velocity
        self.damage = damage
        self.physicsBody.categoryBitMask = Constants.singleton.magicMask
        self.changeMask(bit: Constants.singleton.enemiesMask, collision: false)
    }
    
    func onTouch(touched: inout AttributesInfo){
        touched.health -= self.damage.damage
        self.node.removeFromParent()
    }
}
