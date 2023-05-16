//
//  Buffer.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 15/05/23.
//

import Foundation
import SpriteKit

protocol Status {
    associatedType T: SKNode
    var sprite: T {get set}
    
}
