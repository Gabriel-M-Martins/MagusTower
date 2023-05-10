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
    case walkingLeft
    case walkingRight
    
    //Charging é preparando, goingUp é subindo até altura máxima, attack é descendo rumo ao player p atacar
    case charging
    case goingUp
    case attack
    
    func StateInfo() -> AnimationInfo {
        switch self {
        case .idle:
            return AnimationInfo(textures: [Constants.spiderIdleTexture], duration: 1, repeating: true)
        case .walkingLeft:
            return AnimationInfo(textures: [Constants.spiderIdleTexture], duration: 1, repeating: true)
        case .walkingRight:
            return AnimationInfo(textures: [Constants.spiderIdleTexture], duration: 1, repeating: true)
        case .charging:
            return AnimationInfo(textures: [SKTexture(imageNamed: "DeadVillain")], duration: 1)
        case .goingUp:
            return AnimationInfo(textures: [SKTexture(imageNamed: "DeadVillain")], duration: 1)
        case .attack:
            return AnimationInfo(textures: [SKTexture(imageNamed: "DeadVillain")], duration: 0)
        }
    }
    
    func ValidateTransition(to target: StatesSpider) -> Bool {
        switch self {
        case .idle:
            return [.walkingLeft, .walkingRight, .charging, .attack].contains(target)
        case .walkingLeft:
            return [.idle, .walkingRight, .charging, .attack].contains(target)
        case .walkingRight:
            return [.idle, .walkingLeft, .charging, .attack].contains(target)
        case .charging:
            return [.idle, .goingUp, .attack].contains(target)
        case .goingUp:
            return [.attack].contains(target)
        case .attack:
            return [.idle, .walkingLeft, .walkingRight].contains(target)
        }
    }
}
