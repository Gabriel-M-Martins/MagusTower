//
//  Elements.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 04/05/23.
//

import Foundation

enum Elements {
    case fire
    case ice
    case thunder
    case earth
    case neutral
    
    func getBuff() -> (any Attributes) -> Void {
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
    
    func placeholder1(_ attr: any Attributes) {
//        attr.attributes.
        print("buff")
    }
    func placeholder2(_ attr: any Attributes) {
        print("debuff")
    }
}