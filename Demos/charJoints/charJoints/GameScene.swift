//
//  GameScene.swift
//  charJoints
//
//  Created by Gabriel Medeiros Martins on 28/04/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var char = SKNode()
    var body = SKSpriteNode()
    var arm = SKSpriteNode()
    var ground = SKSpriteNode()
    
    var pin = SKPhysicsJointPin()
    
    @objc private func onPan(_ recognizer: UIPanGestureRecognizer) {
        guard recognizer.state == .changed else {return}
        
        let location = scene?.convertPoint(fromView: recognizer.location(in: view))
        char.position = location ?? CGPoint()
    }
    
    override func didMove(to view: SKView) {
        
        
        body = SKSpriteNode(color: .red, size: CGSize(width: 80, height: 160))
        body.physicsBody = SKPhysicsBody()
        body.physicsBody?.allowsRotation = false
        body.physicsBody?.affectedByGravity = false
        body.physicsBody?.isDynamic = true
        char.addChild(body)
        addChild(char)
        
        arm = SKSpriteNode(color: .white, size: CGSize(width: 20, height: 80))
        arm.position = CGPoint(x: 60, y: 0)
        arm.physicsBody = SKPhysicsBody()
        arm.physicsBody?.allowsRotation = true
        arm.physicsBody?.affectedByGravity = false
        arm.physicsBody?.isDynamic = true
        char.addChild(arm)
        
        
        
        arm.anchorPoint = CGPoint(x: 0.5, y: 0)
        pin = SKPhysicsJointPin.joint(withBodyA: arm.physicsBody!, bodyB: body.physicsBody!, anchor: body.position)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        self.view?.addGestureRecognizer(panRecognizer)
    }
    
    override func update(_ currentTime: TimeInterval) {
        arm.zRotation += CGFloat.pi / 60
        char.position.x += frame.width * 0.001
    }
}
