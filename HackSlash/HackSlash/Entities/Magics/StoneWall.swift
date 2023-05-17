//
//  StoneWall.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 15/05/23.
//

import Foundation
import SpriteKit

class StoneWall {
    var sprite: SKSpriteNode
    var finalHeight: CGFloat
    init(player: Player, angle: CGFloat){
        self.finalHeight = myFrame.myVariables.frame.height + player.position.y
        sprite = SKSpriteNode(imageNamed: Constants.magicWall)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 1)
        sprite.zPosition = -20
        sprite.size = CGSize(width: Constants.stoneWallWidth, height: finalHeight)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size, center: CGPoint(x: sprite.position.x, y: (myFrame.myVariables.frame.height + player.position.y) / -2))
        sprite.physicsBody?.isDynamic = false
        sprite.position = CGPoint(x: player.sprite.position.x + Constants.playerSize.width * (cos(angle) >= 0 ? 1 : -1), y: player.sprite.position.y)
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.sprite.removeFromParent()
        }
    }
}
