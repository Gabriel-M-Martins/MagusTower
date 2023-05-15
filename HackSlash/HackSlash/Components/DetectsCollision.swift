//
//  DetectsCollision.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 04/05/23.
//

import Foundation
import SpriteKit

protocol DetectsCollision{
    var physicsBody: SKPhysicsBody {get}
}

extension DetectsCollision{
    func changeMask(bit: UInt32, collision: Bool = true){
        self.physicsBody.contactTestBitMask = physicsBody.contactTestBitMask | bit
        if collision{
            self.physicsBody.collisionBitMask = physicsBody.collisionBitMask | bit
        }
    }
}

/*
 SOBRE COMO FUNCIONA:
    AO SEGUIR O PROTOCOLO, O METODO CHANGEMASK PRECISA SER CHAMADO NO INIT PARA CADA TIPO DE NODO QUE DESEJA VERIFICAR CONTATO.
    PEGUE O BIT CORRESPONDENTE AO TIPO DE NODO NA PASTA CONSTANTS
 */
