//
//  AttributesInfo.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 04/05/23.
//

import Foundation
import SpriteKit

struct AttributesInfo {
    var health: Int
    var defense: Int
    var weakness: Set<Elements>
    var resistence: Set<Elements>
    var velocity: VelocityInfo
    var attackRange: CGFloat
    var maxHealth: Int
}
