//
//  GameScene.swift
//  DemoParticle
//
//  Created by Pedro Mezacasa Muller on 28/04/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var fireballs: [SKEmitterNode] = []
    
    override func didMove(to view: SKView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let fireball = SKEmitterNode(fileNamed: "FireTrace")!
        fireball.position.x = -frame.width * 0.5
        fireballs.append(fireball)
        addChild(fireball)
        print(fireballs.count)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var to_update: [SKEmitterNode] = []
        for fireball in fireballs{
            fireball.position.x += frame.width * 0.01
            if fireball.position.x > frame.width{
                fireball.removeFromParent()
                to_update.append(fireball)
            }
        }
        fireballs = fireballs.filter{!to_update.contains($0)}
    }
}
