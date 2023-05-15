//
//  Magics.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 11/05/23.
//

import Foundation

enum Magics {
    case A(Elements), B(Elements), C(Elements), D(Elements)
    
    static func magic(primary: Directions, secondary: Directions) -> Self {
        var element: Elements
        switch primary {
        
        case .right:
            element = .fire
        case .up:
            element = .thunder
        case .left:
            element = .ice
        case .down:
            element = .earth
        }
        
        switch secondary {
        case .up:
            return .A(element)
        case .right:
            return .B(element)
        case .down:
            return .C(element)
        case .left:
            return .D(element)
        }
    }
}


