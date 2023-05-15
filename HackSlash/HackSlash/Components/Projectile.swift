//
//  Projectile.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 11/05/23.
//

import Foundation
import SpriteKit

protocol Projectile{
    associatedtype Nd : SKNode
    var angle: Double {get set}
    var velocity: VelocityInfo {get set}
    var node: Nd {get set}
    var damage: AttackInfo {get set}
}

extension Projectile{
    func launch(){
        //Após jogar o nodo na cena, chamar essa funcao pra o projetil andar adequadamente.
        node.zRotation = angle
        node.physicsBody?.velocity = CGVector(dx: velocity.xSpeed * cos(angle), dy: velocity.ySpeed * sin(angle))
    }
}

