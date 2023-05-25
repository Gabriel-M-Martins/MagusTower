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
    init(player: Player, angle: CGFloat, floorHeight: CGFloat, floor: SKNode?, move:Bool) {
        self.finalHeight = player.sprite.frame.height * 2 // weird behaviour
        
        // ------------------------------------------------------------ sprite
        sprite = SKSpriteNode(imageNamed: Constants.singleton.magicWall)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        sprite.zPosition = -20
        sprite.size = CGSize(width: Constants.singleton.stoneWallWidth, height: finalHeight)
        
        var x = player.sprite.position.x + Constants.singleton.playerSize.width * (cos(angle) >= 0 ? 1 : -1)
        
        if let floor = floor {
            if floor.frame.minX > x - sprite.frame.width/2 {
                x = floor.frame.minX + sprite.frame.width/2
                
            } else if floor.frame.maxX < x + sprite.frame.width/2 {
                x = floor.frame.maxX - sprite.frame.width/2
            }
        }
        else if player.sprite.position.y > finalHeight{
            finalHeight = player.sprite.position.y
            sprite.size.height = finalHeight
        }
        
        sprite.position = CGPoint(x: x, y: floorHeight - 5)
        
        // ------------------------------------------------------------ physics
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: self.sprite.size, center: CGPoint(x: 0, y: sprite.frame.height/2))
        self.sprite.physicsBody?.isDynamic = false
        
        sprite.scale(to: CGSize(width: sprite.size.width, height: 0))
        
        // ------------------------------------------------------------ emitter
        let emitter = SKEmitterNode(fileNamed: "DirtParticle")!
        emitter.zPosition = -22
        
        // ------------------------------------------------------------ animation
        
        let sequence1 = SKAction.sequence([
            .group([
                SKAction.scaleY(to: 1, duration: 1.5),
                SKAction.run(
                    {
                        emitter.particleBirthRate = 150
                        emitter.position = CGPoint(x: self.sprite.position.x, y: floorHeight)
                        self.sprite.parent?.addChild(emitter)
                    })
            ]),
            .run({
                emitter.particleBirthRate = 0
            })
        ])
        
        let sequence3 = SKAction.sequence([
            .wait(forDuration: 2),
            
                .wait(forDuration: 5),
            .run({
                emitter.particleBirthRate = 150
            }),
            .scaleY(to: 0.1, duration: 1.5),
            SKAction.run({
                emitter.removeFromParent()
            }),
            .removeFromParent()
        ])
        
        let finalSequence: [SKAction]
        if (move) {
            print("Cheguei aqui 2")
            let sequence2 = SKAction.sequence([
                .move(by:CGVector(dx: 500 * cos(angle),dy:0.0), duration: 2)
            ])
            finalSequence = [sequence1, sequence2, sequence3] }
        else { finalSequence = [sequence1, sequence3] }
        
        sprite.run(.sequence(finalSequence))
    }
}
//        sprite.run(SKAction.sequence([
//            //            .scaleY(to: 0, duration: 0.0001),
//            //
//            .group([
//                SKAction.scaleY(to: 1, duration: 1.5),
//                SKAction.run(
//                    {
//                        emitter.particleBirthRate = 150
//                        emitter.position = CGPoint(x: self.sprite.position.x, y: floorHeight)
//                        self.sprite.parent?.addChild(emitter)
//                    })
//            ]),
//                .run({
//                    emitter.particleBirthRate = 0
//                }),
//
//
//
//                .wait(forDuration: 2),
//
//                .wait(forDuration: 5),
//            .run({
//                emitter.particleBirthRate = 150
//            }),
//            .scaleY(to: 0.1, duration: 1.5),
//            SKAction.run({
//                emitter.removeFromParent()
//            }),
//            .removeFromParent()
//
//
//        ]))
//    }
//}
