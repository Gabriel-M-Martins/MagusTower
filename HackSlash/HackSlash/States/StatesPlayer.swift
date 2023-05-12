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
            return AnimationInfo(textures: [Constants.playerIdleTexture], duration: 5)
        case .attack:
            return AnimationInfo(textures: [], duration: 0)
        case .walking:
            return AnimationInfo(textures: Constants.playerRunTexture, duration: 0.2, repeating: true)
        case .jump:
            return AnimationInfo(textures: Constants.playerJumpTexture, duration: 0.8)
        case .airborne:
            return AnimationInfo(textures: Constants.playerAirborneTexture, duration: 0.5)
        case .landing:
            return AnimationInfo(textures: Constants.playerLandingTexture, duration: 0.3)
        }
    }
    
    func ValidateTransition(to target: StatesPlayer) -> Bool {
        switch self {
        case .idle:
            return [.attack, .jump, .walking, .airborne].contains(target)
        case .attack:
            return [.idle, .walking, .airborne].contains(target)
        case .walking:
            return [.idle, .attack, .jump, .walking, .airborne].contains(target)
        case .jump:
            return [.airborne, .idle].contains(target)
        case .airborne:
            return [.landing, .jump, .attack].contains(target)
        case .landing:
            return [.idle].contains(target)
        }
    }
}
