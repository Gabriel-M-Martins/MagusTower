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
        if !attr.isBuffed{
            let emitter = SKEmitterNode(fileNamed: "EletricAura")!
            emitter.zPosition = -3
            attr.sprite.addChild(emitter)
            emitter.position = CGPoint(x: 0, y: -attr.sprite.size.height*0.5)
            var attrCopy = attr
            attrCopy.isBuffed = true
            attrCopy.attributes.velocity.maxXSpeed += Constants.singleton.thunderBuffVelocityBonus
            attrCopy.attributes.velocity.maxYSpeed += Constants.singleton.thunderBuffVelocityBonus
            attrCopy.attributes.velocity.xSpeed += Constants.singleton.thunderBuffVelocityBonus/2
            attrCopy.attributes.velocity.ySpeed += Constants.singleton.thunderBuffVelocityBonus/2
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                attrCopy.attributes.velocity.maxXSpeed -= Constants.singleton.thunderBuffVelocityBonus
                attrCopy.attributes.velocity.maxYSpeed -= Constants.singleton.thunderBuffVelocityBonus
                attrCopy.attributes.velocity.xSpeed -= Constants.singleton.thunderBuffVelocityBonus/2
                attrCopy.attributes.velocity.ySpeed -= Constants.singleton.thunderBuffVelocityBonus/2
                emitter.removeFromParent()
                attrCopy.isBuffed = false
            }
        }
    }
    
    func fireBuff(_ attr: any Attributes & Status, for time: Double){
        if !attr.isBuffed{
            var attrCopy = attr
            attrCopy.isBuffed = true
            let emitter = SKEmitterNode(fileNamed: "FireAura")!
            emitter.zPosition = -3
            attr.sprite.addChild(emitter)
            Constants.singleton.damageMultiplier = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                Constants.singleton.damageMultiplier = 1
                emitter.removeFromParent()
                attrCopy.isBuffed = false
            }
        }
    }
    
    func earthBuff(_ attr: any Attributes & Status, for time: Double){
        if !attr.isBuffed{
            let emitter = SKEmitterNode(fileNamed: "EarthAura")!
            emitter.zPosition = -3
            attr.sprite.addChild(emitter)
            var attrCopy = attr
            attrCopy.isBuffed = true
            attrCopy.attributes.defense += 5
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                attrCopy.attributes.defense -= 5
                emitter.removeFromParent()
                attrCopy.isBuffed = false
            }
        }
    }
    
    func iceBuff(_ attr: any Attributes & Status, for time: Double){
        if !attr.isBuffed{
            var attrCopy = attr
            attrCopy.isBuffed = true
            let emitter = SKEmitterNode(fileNamed: "IceAura")!
            emitter.zPosition = -3
            attr.sprite.addChild(emitter)
            for i in 1...10{
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                    Constants.singleton.notificationCenter.post(name: Notification.Name("healPlayer"), object: nil)
                    if i == 10{
                        emitter.removeFromParent()
                        attrCopy.isBuffed = false
                    }
                }
            }
        }
    }
    
    func placeholder2(_ attr: any Attributes & Status, _ a: Double) {
        print("debuff")
    }
}
