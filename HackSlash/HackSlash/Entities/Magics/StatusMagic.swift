//
//  StatusMagic.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 15/05/23.
//

import Foundation
import SpriteKit

class StatusMagic{
    var emitter: SKEmitterNode
    var player: Player
    init(spriteName: String, player: Player, buffTime: Double){
        self.emitter = SKEmitterNode(fileNamed: spriteName)!
        self.player = player
        player.sprite.addChild(emitter)
    }
}
