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
        sprite.size = CGSize(width: Constants.stoneWallWidth, height: finalHeight/10)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: finalHeight), center: CGPoint(x: sprite.position.x, y: self.sprite.size.height * 4))
        sprite.physicsBody?.isDynamic = false
        sprite.position = CGPoint(x: player.sprite.position.x + Constants.playerSize.width * (cos(angle) >= 0 ? 1 : -1), y: player.sprite.position.y - finalHeight)
        
        sprite.run(SKAction.sequence([
            SKAction.group([
                SKAction.scaleY(to: -11, duration: 1.5),
                
            ]),
            .wait(forDuration: 7),
            SKAction.scaleY(to: 0.1, duration: 1.5),
            SKAction.removeFromParent()
        ]))
    }
}
