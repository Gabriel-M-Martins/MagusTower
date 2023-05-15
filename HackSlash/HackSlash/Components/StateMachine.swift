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
    var currentState: STM { get set }
    mutating func transition(to target: STM)
}

extension StateMachine {
    mutating func transition(to target: STM) {
        guard currentState.ValidateTransition(to: target) else {
//            print("Estado inválido")
            return
        }
        
        let targetInfo = target.StateInfo()
        guard !targetInfo.textures.isEmpty else { return }
        
        let action = SKAction.animate(with: targetInfo.textures, timePerFrame: targetInfo.duration / Double(targetInfo.textures.count))
        action.duration = targetInfo.duration

        sprite.removeAllActions()

        if targetInfo.repeating {
            sprite.run(SKAction.repeatForever(action))
        } else {
            sprite.run(action)
        }
        
        currentState = target
    }
}
