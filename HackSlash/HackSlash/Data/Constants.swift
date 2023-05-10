//
//  Constants.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 02/05/23.
//
import Foundation
import SpriteKit

struct Constants {
    private let frame: CGRect

    static let enemiesMask: UInt32 = 1
    static let groundMask: UInt32 = 2
    static let playerMask: UInt32 = 4
    
    static let playerSize: CGSize = CGSize(width: 104, height: 111)
    static let spiderSize: CGSize = CGSize(width: 90, height: 60)
    
    static let playerIdleTexture: SKTexture = SKTexture(imageNamed: "MagoFrente")
    //Animacao jump dura até do magopulando0 até o 11, dps vem airborne ate o 22
    
    static var playerJumpTexture: [SKTexture] {
        var texture: [SKTexture] = []
        for n in 0...18{
            texture.append(SKTexture(imageNamed: "MagoPuloRight\(n)"))
        }
        return texture
    }
    
    static var playerAirborneTexture: [SKTexture] {
        var texture: [SKTexture] = []
        for n in 19...22{
            texture.append(SKTexture(imageNamed: "MagoPuloRight\(n)"))
        }
        return texture
    }
    
    static var playerRunTexture: [SKTexture] {
        var texture: [SKTexture] = []
        for n in 0...5{
            texture.append(SKTexture(imageNamed: "MagoCorrendoRight\(n)"))
        }
        return texture
    }
    
    static var playerLandingTexture: [SKTexture] {
        var texture: [SKTexture] = []
        for n in 0...4{
            texture.append(SKTexture(imageNamed: "MagoPousandoRight\(n)"))
        }
        return texture
    }
    
    static let spiderIdleTexture: SKTexture = SKTexture(imageNamed: "Spider")
    
    init(frame: CGRect) {
        self.frame = frame
    }

    var platformsHeight: CGFloat {
        frame.height/18
    }
}
