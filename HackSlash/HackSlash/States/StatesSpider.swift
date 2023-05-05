//
//  StatesPlayer.swift
//  HackSlash
//
//  Created by Pedro and Lucas on 03/05/23.
//

import Foundation
import SpriteKit

enum StatesSpider: StateMachineable {
    case idle
    case walking
    
    //Charging é preparando, goingUp é subindo até altura máxima, attack é descendo rumo ao player p atacar
    case charging
    case goingUp
    case attack
    
    func StateInfo() -> AnimationInfo {
        switch self {
        case .idle:
            return AnimationInfo(textures: [Constants.spiderIdleTexture], duration: 1, repeating: true)
        case .walking:
            return AnimationInfo(textures: [], duration: 0)
        case .charging:
            return AnimationInfo(textures: [SKTexture(imageNamed: "DeadVillain")], duration: 1, repeating: true)
        case .goingUp:
            return AnimationInfo(textures: [], duration: 0)
        case .attack:
            return AnimationInfo(textures: [], duration: 0, repeating: true)
        }
    }
    
    func ValidateTransition(to target: StatesSpider) -> Bool {
        switch self {
        case .idle:
            return [.walking, .charging, .attack].contains(target)
        case .walking:
            return [.idle, .charging, .attack].contains(target)
        case .charging:
            return [.goingUp].contains(target)
        case .goingUp:
            return [.attack].contains(target)
        case .attack:
            return [.idle, .walking].contains(target)
        }
    }
}
