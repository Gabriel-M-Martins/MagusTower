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
    
    @objc private func onPan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .ended {
            for i in char.children {
                print(i)
                print(i.children)
            }
        }
        
        guard recognizer.state == .changed else {return}
        
        let location = scene?.convertPoint(fromView: recognizer.location(in: view))
        char.position = location ?? CGPoint()
    }
    
    override func didMove(to view: SKView) {
//        let origin = SKShapeNode(circleOfRadius: 5)
//        origin.fillColor = .white
//        scene?.addChild(origin)
        
        // ---------------------------------------------------------------
        body = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 200))
        body.name = "body"
        char.addChild(body)
        
        // ---------------------------------------------------------------
//        let armAnchor = CGPoint(x: 75, y: 50)
//        let anchorDebug = SKShapeNode(circleOfRadius: 5)
//        anchorDebug.position = armAnchor
//        scene?.addChild(anchorDebug)
        
        // ---------------------------------------------------------------
//        arm = SKShapeNode(rectOf: CGSize(width: 35, height: 100))
//        arm.position = CGPoint(x: 75, y: 0)
//        scene?.addChild(arm)
        let armHolder = SKNode()
        armHolder.name = "armHolder"
        body.addChild(armHolder)
        armHolder.position = CGPoint()

        arm = SKSpriteNode(color: .red, size: CGSize(width: 35, height: 100))
        armHolder.addChild(arm)
        arm.anchorPoint = CGPoint(x: 0.5, y: 1)
        arm.position = CGPoint(x: 75, y: 50)
        arm.name = "arm"

        
        // ---------------------------------------------------------------
        let gr = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        view.addGestureRecognizer(gr)
        
        // ---------------------------------------------------------------
        
        scene?.addChild(char)
    }
    
    override func update(_ currentTime: TimeInterval) {
//        arm.zRotation += CGFloat.pi / 60
//        body.children[0].zRotation += CGFloat.pi / 60
    }
}
