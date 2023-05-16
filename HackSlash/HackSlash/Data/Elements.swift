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
    
    func getBuff() -> (any Attributes & Status) -> Void {
        switch self {
        case .fire:
            return placeholder1
        case .ice:
            return placeholder1
        case .thunder:
            return placeholder1
        case .earth:
            return placeholder1
        case .neutral:
            return placeholder1
        }
    }
    
    func getDebuff() -> (any Attributes) -> Void {
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
    
    func placeholder1(_ attr: any Attributes & Status) {
//        attr.attributes.
        
        print("buff")
    }
    
    func thunderBuff(_ attr: any Attributes & Status, for time: Double){
        let emitter = SKEmitterNode(fileNamed: "thunderStatus")!
        emitter.zPosition = -3
        attr.sprite.addChild(emitter)
        var attr_ref = attr
        attr_ref.attributes.velocity.maxXSpeed += Constants.singleton.thunderBuffVelocityBonus
        attr_ref.attributes.velocity.maxYSpeed += Constants.singleton.thunderBuffVelocityBonus
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            attr_ref.attributes.velocity.maxXSpeed -= Constants.singleton.thunderBuffVelocityBonus
            attr_ref.attributes.velocity.maxYSpeed -= Constants.singleton.thunderBuffVelocityBonus
            emitter.removeFromParent()
        }
    }
    
    func placeholder2(_ attr: any Attributes) {
        print("debuff")
    }
}
