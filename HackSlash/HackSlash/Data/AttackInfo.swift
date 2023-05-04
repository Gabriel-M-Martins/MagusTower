//
//  AttackInfo.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 04/05/23.
//

import Foundation

struct AttackInfo {
    var damage: Int
    var element: Elements
    var activateEffects: (buff: Bool, debuff: Bool)
}
