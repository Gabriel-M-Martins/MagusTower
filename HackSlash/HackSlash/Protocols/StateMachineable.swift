//
//  StateMachineable.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 03/05/23.
//

import Foundation

protocol StateMachineable {
    func StateInfo() -> AnimationInfo
    func ValidateTransition(to target: Self) -> Bool
}
