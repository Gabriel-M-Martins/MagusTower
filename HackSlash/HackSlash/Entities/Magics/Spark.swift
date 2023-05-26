//
//  Spark.swift
//  HackSlash
//
//  Created by Lucas Cunha on 25/05/23.
//

import Foundation
import SpriteKit

class Spark: MagicProjetile {
    init(angle: Double, player: Player) {
        let node = SKEmitterNode(fileNamed: "SparkRain")!
        node.position = CGPoint(x: node.position.x, y: node.position.y)
        node.zRotation = 150
        node.particlePositionRange = Constants.singleton.sparkSize
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.singleton.sparkSize.dx, height: Constants.singleton.sparkSize.dy))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = 0
        node.physicsBody?.collisionBitMask = 0
        
        
        let nodeCloud = SKEmitterNode(fileNamed: "Cloud")!
        var auxX = 1
        if(cos(angle)<0){
            auxX = -1
        }
        nodeCloud.position = CGPoint(x: player.sprite.position.x + (Constants.singleton.playerSize.width * CGFloat(auxX)), y: player.sprite.position.y + (Constants.singleton.playerSize.height) * 2)
        print(nodeCloud.position)
        nodeCloud.particlePositionRange = Constants.singleton.cloudSize
        nodeCloud.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Constants.singleton.cloudSize.dx, height: Constants.singleton.cloudSize.dy))
        nodeCloud.physicsBody?.isDynamic = false
        nodeCloud.physicsBody?.affectedByGravity = false
        nodeCloud.physicsBody?.allowsRotation = false
        nodeCloud.physicsBody?.categoryBitMask = 0
        nodeCloud.physicsBody?.collisionBitMask = 0
        nodeCloud.addChild(node)
//        super.init(node: nodeCloud, angle: angle, element: .thunder, velocity: Constants.singleton.sparkVelocity, damage: Constants.singleton.sparkDamage)
//        self.launch()
//
        super.init(node: nodeCloud, angle: 0, element: .thunder, velocity: Constants.singleton.sparkVelocity, damage: Constants.singleton.sparkDamage)
        self.launch()
    }
}
