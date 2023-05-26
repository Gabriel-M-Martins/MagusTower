//
//  AI.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 25/05/23.
//

import Foundation
import SpriteKit

protocol AI{
    func moveAI()
    
    var enemyType: EnemyType {get set}
}

enum EnemyType{
    case Spider, Bat
}
