//
//  Constants.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 02/05/23.
//
import Foundation
import SpriteKit
import UserNotifications
import SwiftUI

struct Constants {
    private let frame: CGRect

    static let enemiesMask: UInt32 = 1
    static let groundMask: UInt32 = 2
    static let playerMask: UInt32 = 4
    static let magicMask: UInt32 = 8
    static let wallMask: UInt32 = 16
    
    static let playerDamage: Int = 10
    static let playerDefense: Int = 5
    
    static let playerSize: CGSize = CGSize(width: 104, height: 111)
    static let spiderSize: CGSize = CGSize(width: 90, height: 60)
    
    static let fireballSize: CGVector = CGVector(dx: 38, dy: 15)
    static let fireballVelocity: VelocityInfo = VelocityInfo(xSpeed: 500, ySpeed: 500, maxXSpeed: 150, maxYSpeed: 150)
    static let fireballDamage: AttackInfo = AttackInfo(damage: Constants.playerDamage, element: .fire, activateEffects: (false, false))
    
    static let iceballSize: CGVector = CGVector(dx: 38, dy: 15)
    static let iceballVelocity: VelocityInfo = VelocityInfo(xSpeed: 1000, ySpeed: 500, maxXSpeed: 1000, maxYSpeed: 200)
    static let iceballDamage: AttackInfo = AttackInfo(damage: Constants.playerDamage, element: .fire, activateEffects: (false, false))
    
    static let earthPowerTexture: SKTexture = SKTexture(imageNamed: "EarthPowers")
    static let eletricPowerTexture: SKTexture = SKTexture(imageNamed: "EletricPowers")
    static let icePowerTexture: SKTexture = SKTexture(imageNamed: "IcePowers")
    static let firePowerTexture: SKTexture = SKTexture(imageNamed: "FirePowers")
    
    static let fireATexture: SKTexture = SKTexture(imageNamed: "Fireball")
    static let fireBTexture: SKTexture = SKTexture(imageNamed: "NoPowerLeft")
    static let fireCTexture: SKTexture = SKTexture(imageNamed: "NoPowerRight")
    static let fireDTexture: SKTexture = SKTexture(imageNamed: "Firestatus")
    
    static let thunderATexture: SKTexture = SKTexture(imageNamed: "Eletricbolt")
    static let thunderBTexture: SKTexture = SKTexture(imageNamed: "NoPowerLeft")
    static let thunderCTexture: SKTexture = SKTexture(imageNamed: "NoPowerRight")
    static let thunderDTexture: SKTexture = SKTexture(imageNamed: "Eletricstatus")
    
    static let iceATexture: SKTexture = SKTexture(imageNamed: "Iceshard")
    static let iceBTexture: SKTexture = SKTexture(imageNamed: "NoPowerLeft")
    static let iceCTexture: SKTexture = SKTexture(imageNamed: "NoPowerRight")
    static let iceDTexture: SKTexture = SKTexture(imageNamed: "Icestatus")
    
    static let earthATexture: SKTexture = SKTexture(imageNamed: "Earthwall")
    static let earthBTexture: SKTexture = SKTexture(imageNamed: "NoPowerLeft")
    static let earthCTexture: SKTexture = SKTexture(imageNamed: "NoPowerRight")
    static let earthDTexture: SKTexture = SKTexture(imageNamed: "Earthstatus")
    
    static let downMagicTexture: SKTexture = SKTexture(imageNamed: "Baixo")
    static let upMagicTexture: SKTexture = SKTexture(imageNamed: "Cima")
    static let rightMagicTexture: SKTexture = SKTexture(imageNamed: "Direita")
    static let leftMagicTexture: SKTexture = SKTexture(imageNamed: "Esquerda")
    static let upRMagicTexture: SKTexture = SKTexture(imageNamed: "Nordeste")
    static let upLMagicTexture: SKTexture = SKTexture(imageNamed: "Noroeste")
    static let downRMagicTexture: SKTexture = SKTexture(imageNamed: "Sudeste")
    static let downLMagicTexture: SKTexture = SKTexture(imageNamed: "Sudoeste")
    
    static let directionsTexture: SKTexture = SKTexture(imageNamed: "DirectionsJoystickBG")
    
    static let magicWall: String = "Parede"
    
    static let combosSpritesScale: CGFloat = 1.4
    static let combosSpritesAlpha: CGFloat = 0.4
    static let combosSpritesAnimationDuration: CGFloat = 0.1
    
    static let stoneWallWidth: CGFloat = 50
    
    static let thunderBuffVelocityBonus: CGFloat = 50
    
    //precisa ser var pois muda de acordo com o buff
    static var damageMultiplier: Double = 1
    
    static let playerIdleTexture: SKTexture = SKTexture(imageNamed: "MagoFrente")
    //Animacao jump dura até do magopulando0 até o 11, dps vem airborne ate o 22
    
    static func randomPlatformSprite() -> String {
        let sprites = ["Plataform1", "Plataform2", "Plataform3"]
        return sprites.randomElement()!
    }
    
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
            texture.append(SKTexture(imageNamed: "MagoCorrendoLado\(n)"))
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
    
    static let spiderDeadTexture: SKTexture = SKTexture(imageNamed: "DeadSpider")
    
    static let spiderAttackTexture: SKTexture = SKTexture(imageNamed: "SpiderAttack")
    
    static let spiderChargingTexture: SKTexture = SKTexture(imageNamed: "SpiderPreparingJump")
    
    static let deathDespawn: Double = 5.0
    
    static var spiderWalkingTexture: [SKTexture] {
        var texture: [SKTexture] = []
        for n in 0...4{
            texture.append(SKTexture(imageNamed: "AranhaCorrendo\(n)"))
        }
        return texture
    }
    
    init(frame: CGRect) {
        self.frame = frame
    }

    var platformsHeight: CGFloat {
        frame.height/18
    }
    
    static var spiderDamage: Int = 5
    
    static let notificationCenter = NotificationCenter.default
    
    static let buttonsColor: UIColor = .white

}
