//
//  Attacks.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 04/05/23.
//

import Foundation

protocol Attacks {
    var attacks: [AttackInfo] { get set }
}

extension Attacks {
    func executeAttack(target: any Attributes & Status, attack idx: Int) {
        guard idx >= 0 && idx < attacks.count else { return }
        let attack = attacks[idx]
        
        let buffAction = attack.activateEffects.buff ? attack.element.getBuff() : nil
        let debuffAction = attack.activateEffects.debuff ? attack.element.getDebuff() : nil
        
        if let buffAction = buffAction {
            buffAction(target)
        }
        
        if let debuffAction = debuffAction {
            debuffAction(target)
        }
    }
}
