//
//  Constants.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 02/05/23.
//
import Foundation
import SpriteKit
import UserNotifications

/*
 class Singleton {
     static let shared: Singleton = {
         let instance = Singleton()
         // setup code
         return instance
     }()
 }
 */

class Constants {
    static let singleton: Constants = Constants()
    
    private init() {}
    
    var frame: CGRect = CGRect.zero
    
    let enemiesMask: UInt32 = 1
    let groundMask: UInt32 = 2
    let playerMask: UInt32 = 4
    let magicMask: UInt32 = 8
    
    let playerDamage: Int = 10
    
    let playerSize: CGSize = CGSize(width: 104, height: 111)
    let spiderSize: CGSize = CGSize(width: 90, height: 60)
    
    let fireballSize: CGVector = CGVector(dx: 38, dy: 15)
    let fireballVelocity: VelocityInfo = VelocityInfo(xSpeed: 500, ySpeed: 500, maxXSpeed: 150, maxYSpeed: 150)
    lazy var fireballDamage: AttackInfo = AttackInfo(damage: Constants.singleton.playerDamage, element: .fire, activateEffects: (false, false))
    
    let iceballSize: CGVector = CGVector(dx: 38, dy: 15)
    let iceballVelocity: VelocityInfo = VelocityInfo(xSpeed: 1000, ySpeed: 500, maxXSpeed: 1000, maxYSpeed: 200)
    lazy var iceballDamage: AttackInfo = AttackInfo(damage: Constants.singleton.playerDamage, element: .fire, activateEffects: (false, false))
    
    let earthPowerTexture: SKTexture = SKTexture(imageNamed: "EarthPowers")
    let eletricPowerTexture: SKTexture = SKTexture(imageNamed: "EletricPowers")
    let icePowerTexture: SKTexture = SKTexture(imageNamed: "IcePowers")
    let firePowerTexture: SKTexture = SKTexture(imageNamed: "FirePowers")
    
    let combosSpritesScale: CGFloat = 0.85
    let combosSpritesAlpha: CGFloat = 0.4
    let combosSpritesAnimationDuration: CGFloat = 0.1
    
    let stoneWallWidth: CGFloat = 50
    
    let thunderBuffVelocityBonus: CGFloat = 50
    
    let playerIdleTexture: SKTexture = SKTexture(imageNamed: "MagoFrente")
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

    var platformsHeight: CGFloat {
        frame.height/18
    }
    
    static var spiderDamage: Int = 5
    
//    static let lifeBarTexture: SKTexture = SKTexture(imageNamed: "life_bar")
//    
//    static let lifeFillTexture: SKTexture = SKTexture(imageNamed: "life_fill")
    
    static let notificationCenter = NotificationCenter.default

}
