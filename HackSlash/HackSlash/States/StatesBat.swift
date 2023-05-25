//
//  StatesPlayer.swift
//  HackSlash
//
//  Created by Pedro and Lucas on 03/05/23.
//

import Foundation
import SpriteKit

enum StatesBat: StateMachineable {
    case idle
    case flying
    case attacking
    case death
    
    func StateInfo() -> AnimationInfo {
        switch self {
        case .idle:
            return AnimationInfo(textures: Constants.batIdleTexture, duration: 1, repeating: true)
        case .flying:
            return AnimationInfo(textures: Constants.batFlyingTexture, duration: 0.3, repeating: true)
        case .attacking:
            return AnimationInfo(textures: Constants.batAttackingTexture, duration: 1, repeating: false)
        case .death:
            return AnimationInfo(textures: Constants.batDeathTexture, duration: 1)
        }
    }
    
    func ValidateTransition(to target: StatesBat) -> Bool {
        switch self {
        case .idle:
            return [.flying, .attacking, .death].contains(target)
        case .flying:
            return [.idle, .attacking, .death].contains(target)
        case .attacking:
            return [.idle, .flying, .death].contains(target)
        case .death:
            return false
        }
    }
}
