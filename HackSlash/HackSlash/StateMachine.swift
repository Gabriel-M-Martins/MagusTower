//
//  SpriteMachine.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 03/05/23.
//

import Foundation
import SpriteKit

protocol StateMachine {
    associatedtype STM: StateMachineable
    
    var sprite: SKSpriteNode { get }
    func transition(from current: STM, to target: STM)
}

extension StateMachine {
    func transition(from current: STM, to target: STM) {
        guard current.ValidateTransition(to: target) else { return }
        
        let targetInfo = target.StateInfo()

        let action = SKAction.animate(with: targetInfo.textures, timePerFrame: targetInfo.duration)

        sprite.removeAllActions()

        if targetInfo.repeating {
            sprite.run(SKAction.repeatForever(action))
        } else {
            sprite.run(action)
        }
    }
}
