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
    
    var element: Elements
    
    var velocity: VelocityInfo
    
    var damage: AttackInfo
    
    init(node: SKEmitterNode, angle: Double, element: Elements, velocity: VelocityInfo, damage: AttackInfo) {
        self.node = node
        self.node.name = "Magic"
        self.physicsBody = node.physicsBody!
        self.angle = angle
        self.velocity = velocity
        self.element = element
        self.damage = damage
        self.damage.damage = Int(Constants.singleton.damageMultiplier * Double(self.damage.damage))
        self.physicsBody.categoryBitMask = Constants.singleton.magicMask
        self.changeMask(bit: Constants.singleton.enemiesMask, collision: false)
        self.changeMask(bit: Constants.singleton.wallMask, collision: false)
    }
    
    func onTouch(touched: any Attributes & Status){
        var copySelf = touched
        copySelf.attributes.health -= self.damage.damage
        let x = element.getDebuff()
        x(touched, 8.0)
    }
}
