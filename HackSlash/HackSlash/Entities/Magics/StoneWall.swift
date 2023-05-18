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
    init(player: Player, angle: CGFloat, floorHeight: CGFloat){
        self.finalHeight = player.sprite.frame.height * 2 // weird behaviour
        
        // ------------------------------------------------------------ sprite
        sprite = SKSpriteNode(imageNamed: Constants.singleton.magicWall)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        sprite.zPosition = -20
        sprite.size = CGSize(width: Constants.singleton.stoneWallWidth, height: finalHeight) // tamanho inicial
        sprite.position = CGPoint(x: player.sprite.position.x + Constants.singleton.playerSize.width * (cos(angle) >= 0 ? 1 : -1), y: floorHeight) // + sprite.frame.height/2
        
        // ------------------------------------------------------------ physics
//        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: self.sprite.size, center: sprite.frame.origin)
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: self.sprite.size, center: CGPoint(x: -sprite.position.x, y: sprite.position.y))
        self.sprite.physicsBody?.isDynamic = false
        
        sprite.run(.sequence([
            .scaleY(to: 0, duration: 5),
            .scaleY(to: 1, duration: 5)
        ]))
        
        
        // ------------------------------------------------------------ emitter
        let emitter = SKEmitterNode(fileNamed: "DirtParticle")!
        emitter.zPosition = -22
        
        // ------------------------------------------------------------ animation
        
//        sprite.run(SKAction.sequence([
//            SKAction.group([
//                SKAction.scaleY(to: 1, duration: 1.5),
//                SKAction.run(
//                {
//                    emitter.particleBirthRate = 150
//                    emitter.position = CGPoint(x: self.sprite.position.x, y: floorHeight)
//                    self.sprite.parent?.addChild(emitter)
//                })
//            ]),
//
//            SKAction.run({
//                emitter.particleBirthRate = 0
//            }),
//
//            .wait(forDuration: 2),
//            SKAction.run({
//                emitter.removeFromParent()
//            }),
//
//            .wait(forDuration: 5),
//
//            .scaleY(to: 0.1, duration: 1.5),
//            .removeFromParent()
//        ]))
    }
}
