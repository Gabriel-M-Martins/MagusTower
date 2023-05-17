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
    
    case death
    
    func StateInfo() -> AnimationInfo {
        switch self {
        case .idle:
            return AnimationInfo(textures: [Constants.singleton.spiderIdleTexture], duration: 1, repeating: true)
        case .walking:
            return AnimationInfo(textures: Constants.spiderWalkingTexture, duration: 0.3, repeating: true)
        case .charging:
            return AnimationInfo(textures: [Constants.singleton.spiderChargingTexture], duration: 1)
        case .goingUp:
            return AnimationInfo(textures: [Constants.singleton.spiderAttackTexture], duration: 1)
        case .attack:
            return AnimationInfo(textures: [Constants.singleton.spiderAttackTexture], duration: 1)
        case .death:
            return AnimationInfo(textures: [Constants.singleton.spiderDeadTexture], duration: 1)
        }
    }
    
    func ValidateTransition(to target: StatesSpider) -> Bool {
        switch self {
        case .idle:
            return [.walking, .charging, .attack, .death].contains(target)
        case .walking:
            return [.idle, .charging, .attack, .death].contains(target)
        case .charging:
            return [.idle, .goingUp, .attack, .death].contains(target)
        case .goingUp:
            return [.attack, .death].contains(target)
        case .attack:
            return [.idle, .walking, .death].contains(target)
        case .death:
            return false
        }
    }
}
