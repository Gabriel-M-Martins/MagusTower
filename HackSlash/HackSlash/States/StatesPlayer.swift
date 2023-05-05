//
//  StatesPlayer.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 03/05/23.
//

import Foundation

enum StatesPlayer: StateMachineable {
    case attack
    case idle
    case walking
    case jump
    case airborne
    case landing
    
    func StateInfo() -> AnimationInfo {
        switch self {
        case .idle:
            return AnimationInfo(textures: [Constants.playerIdleTexture], duration: 0, repeating: true)
        case .attack:
            return AnimationInfo(textures: [], duration: 0)
        case .walking:
            return AnimationInfo(textures: [], duration: 0, repeating: true)
        case .jump:
            return AnimationInfo(textures: [Constants.playerJumpTexture], duration: 0)
        case .airborne:
            return AnimationInfo(textures: [Constants.playerIdleTexture], duration: 0, repeating: true)
        case .landing:
            return AnimationInfo(textures: [], duration: 0)
        }
    }
    
    func ValidateTransition(to target: StatesPlayer) -> Bool {
        switch self {
        case .idle:
            return [.attack, .jump, .walking].contains(target)
        case .attack:
            return [.idle, .walking, .airborne].contains(target)
        case .walking:
            return [.idle, .attack, .jump].contains(target)
        case .jump:
            return [.airborne, .idle].contains(target)
        case .airborne:
            return [.landing, .jump, .attack].contains(target)
        case .landing:
            return [.idle].contains(target)
        }
    }
}
