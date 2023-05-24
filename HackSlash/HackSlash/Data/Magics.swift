//
//  Magics.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 11/05/23.
//

import Foundation

enum Magics {
    case A(Elements), B(Elements), C(Elements), D(Elements)
    
    static func magic(primary: Directions4, secondary: Directions4) -> Self {
        var element: Elements
        switch primary {
        
        case .right:
            element = .earth
        case .up:
            element = .ice
        case .left:
            element = .fire
        case .down:
            element = .thunder
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
    
    func getElement() -> Elements{
        switch self{
        case .A(let element):
            return element
        case .B(let element):
            return element
        case .C(let element):
            return element
        case .D(let element):
            return element
        }
    }
}


