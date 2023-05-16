//
//  Elements.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 04/05/23.
//

import Foundation
import SpriteKit
enum Elements {
    case fire
    case ice
    case thunder
    case earth
    case neutral
    
    func getBuff() -> (any Attributes & Status, Double) -> Void {
        switch self {
        case .fire:
            return fireBuff
        case .ice:
            return iceBuff
        case .thunder:
            return thunderBuff
        case .earth:
            return earthBuff
        case .neutral:
            return placeholder1
        }
    }
    
    func getDebuff() -> (any Attributes & Status, Double) -> Void {
        switch self {
        case .fire:
            return placeholder2
        case .ice:
            return placeholder2
        case .thunder:
            return placeholder2
        case .earth:
            return placeholder2
        case .neutral:
            return placeholder2
        }
    }
    
    func placeholder1(_ attr: any Attributes & Status, _ a: Double) {
//        attr.attributes.
        
        print("buff")
    }
    
    func thunderBuff(_ attr: any Attributes & Status, for time: Double){
        let emitter = SKEmitterNode(fileNamed: "EletricAura")!
        emitter.zPosition = -3
        attr.sprite.addChild(emitter)
        emitter.position = CGPoint(x: 0, y: -attr.sprite.size.height*0.5)
        var attr_ref = attr
        attr_ref.attributes.velocity.maxXSpeed += Constants.thunderBuffVelocityBonus
        attr_ref.attributes.velocity.maxYSpeed += Constants.thunderBuffVelocityBonus
        attr_ref.attributes.velocity.xSpeed += Constants.thunderBuffVelocityBonus/2
        attr_ref.attributes.velocity.ySpeed += Constants.thunderBuffVelocityBonus/2
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            attr_ref.attributes.velocity.maxXSpeed -= Constants.thunderBuffVelocityBonus
            attr_ref.attributes.velocity.maxYSpeed -= Constants.thunderBuffVelocityBonus
            attr_ref.attributes.velocity.xSpeed -= Constants.thunderBuffVelocityBonus/2
            attr_ref.attributes.velocity.ySpeed -= Constants.thunderBuffVelocityBonus/2
            emitter.removeFromParent()
        }
    }
    
    func fireBuff(_ attr: any Attributes & Status, for time: Double){
        let emitter = SKEmitterNode(fileNamed: "FireAura")!
        emitter.zPosition = -3
        attr.sprite.addChild(emitter)
        Constants.damageMultiplier = 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            Constants.damageMultiplier = 1
            emitter.removeFromParent()
        }
    }
    
    func earthBuff(_ attr: any Attributes & Status, for time: Double){
        let emitter = SKEmitterNode(fileNamed: "EarthAura")!
        emitter.zPosition = -3
        attr.sprite.addChild(emitter)
        var attrCopy = attr
        attrCopy.attributes.defense += 5
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            attrCopy.attributes.defense -= 5
            emitter.removeFromParent()
        }
    }
    
    func iceBuff(_ attr: any Attributes & Status, for time: Double){
        let emitter = SKEmitterNode(fileNamed: "IceAura")!
        emitter.zPosition = -3
        attr.sprite.addChild(emitter)
        for i in 1...10{
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                Constants.notificationCenter.post(name: Notification.Name("healPlayer"), object: nil)
                if i == 10{
                    emitter.removeFromParent()
                }
            }
        }
    }
    
    func placeholder2(_ attr: any Attributes & Status, _ a: Double) {
        print("debuff")
    }
}
