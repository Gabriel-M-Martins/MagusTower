//
//  DetectsCollision.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 04/05/23.
//

import Foundation
import SpriteKit

protocol DetectsCollision{
    var physicsBody: SKPhysicsBody {get}
}
extension DetectsCollision{
    func changeMask(bit: UInt32){
        self.physicsBody.contactTestBitMask = physicsBody.contactTestBitMask | bit
    }
}
