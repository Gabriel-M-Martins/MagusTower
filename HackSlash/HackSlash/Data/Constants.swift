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

/*
 class Singleton {
     static let shared: Singleton = {
         let instance = Singleton()
         // setup code
         return instance
     }()
 }
 */


class Constants: ObservableObject {
    static let singleton: Constants = Constants()
    
    private init() {}
    
    lazy var frame: CGRect = CGRect.zero
    
    var currentLevel = 0
    var locker = false
    
    let enemiesMask: UInt32 = 1
    let groundMask: UInt32 = 2
    let playerMask: UInt32 = 4
    let magicMask: UInt32 = 8
    let wallMask: UInt32 = 16

    let playerDamage: Int = 10
    let playerDefense: Int = 5
    
    let fireballSize: CGVector = CGVector(dx: 35, dy: 13)
    let burnDamage: Int = 2
    let fireballVelocity: VelocityInfo = VelocityInfo(xSpeed: 600, ySpeed: 600, maxXSpeed: 150, maxYSpeed: 150)
    lazy var fireballDamage: AttackInfo = AttackInfo(damage: Constants.singleton.playerDamage, element: .fire, activateEffects: (false, false))
    
    static var batIdleTexture: [SKTexture] {
        var texture: [SKTexture] = []
        for n in 0...18{
            texture.append(SKTexture(imageNamed: "MagoPuloRight\(n)"))
        }
        return texture
    }
    
    static var batFlyingTexture: [SKTexture] {
        var texture: [SKTexture] = []
        for n in 0...18{
        texture.append(SKTexture(imageNamed: "MagoPuloRight\(n)"))
        }
        return texture
    }
    
    static var batAttackingTexture: [SKTexture] {
        var texture: [SKTexture] = []
        for n in 0...18{
            texture.append(SKTexture(imageNamed: "MagoPuloRight\(n)"))
        }
        return texture
}
    
    static var batDeathTexture: [SKTexture] {
    var texture: [SKTexture] = []
    for n in 0...18{
        texture.append(SKTexture(imageNamed: "MagoPuloRight\(n)"))
    }
    return texture
}
    let blizzardSize: CGVector = CGVector(dx: 100, dy: 100)
    let blizzardVelocity: VelocityInfo = VelocityInfo(xSpeed: 200, ySpeed: 200, maxXSpeed: 150, maxYSpeed: 150)
    lazy var blizzardDamage: AttackInfo = AttackInfo(damage: Constants.singleton.playerDamage/2, element: .ice, activateEffects: (false, false))
    
    let iceballSize: CGVector = CGVector(dx: 38, dy: 15)
    let iceballVelocity: VelocityInfo = VelocityInfo(xSpeed: 700, ySpeed: 700, maxXSpeed: 700, maxYSpeed: 700)
    lazy var iceballDamage: AttackInfo = AttackInfo(damage: Constants.singleton.playerDamage, element: .ice, activateEffects: (false, false))
    
    let lightningParticleSize: CGVector = CGVector(dx: 38, dy: 10)
    let lightningParticleVelocity: VelocityInfo = VelocityInfo(xSpeed: 1000, ySpeed: 1000, maxXSpeed: 1000, maxYSpeed: 800)
    lazy var lightningParticleDamage: AttackInfo = AttackInfo(damage: Constants.singleton.playerDamage, element: .thunder, activateEffects: (false, false))
    
    let fireArrowSize: CGVector = CGVector(dx: 38, dy: 15)
    lazy var fireExplosionDamage: AttackInfo = AttackInfo(damage: Constants.singleton.playerDamage * 3, element: .fire, activateEffects: (false, false))
    
    let playerSize: CGSize = CGSize(width: 104, height: 111)
    let spiderSize: CGSize = CGSize(width: 90, height: 60)
    let batSize: CGSize = CGSize(width: 90, height: 60)

    let fireATexture: SKTexture = SKTexture(imageNamed: "Fireball")
    let fireBTexture: SKTexture = SKTexture(imageNamed: "Fire Arrow")
    let fireCTexture: SKTexture = SKTexture(imageNamed: "NoPowerRight")
    let fireDTexture: SKTexture = SKTexture(imageNamed: "Firestatus")
    
    let thunderATexture: SKTexture = SKTexture(imageNamed: "Eletricbolt")
    let thunderBTexture: SKTexture = SKTexture(imageNamed: "NoPowerLeft")
    let thunderCTexture: SKTexture = SKTexture(imageNamed: "NoPowerRight")
    let thunderDTexture: SKTexture = SKTexture(imageNamed: "Eletricstatus")
    
    let iceATexture: SKTexture = SKTexture(imageNamed: "Iceshard")
    let iceBTexture: SKTexture = SKTexture(imageNamed: "Ice blizzard")
    let iceCTexture: SKTexture = SKTexture(imageNamed: "NoPowerRight")
    let iceDTexture: SKTexture = SKTexture(imageNamed: "Icestatus")
    
    let earthATexture: SKTexture = SKTexture(imageNamed: "Earthwall")
    let earthBTexture: SKTexture = SKTexture(imageNamed: "Earth moving wall")
    let earthCTexture: SKTexture = SKTexture(imageNamed: "NoPowerRight")
    let earthDTexture: SKTexture = SKTexture(imageNamed: "Earthstatus")
    
    let downMagicTexture: SKTexture = SKTexture(imageNamed: "Baixo")
    let upMagicTexture: SKTexture = SKTexture(imageNamed: "Cima")
    let rightMagicTexture: SKTexture = SKTexture(imageNamed: "Direita")
    let leftMagicTexture: SKTexture = SKTexture(imageNamed: "Esquerda")
    let upRMagicTexture: SKTexture = SKTexture(imageNamed: "Nordeste")
    let upLMagicTexture: SKTexture = SKTexture(imageNamed: "Noroeste")
    let downRMagicTexture: SKTexture = SKTexture(imageNamed: "Sudeste")
    let downLMagicTexture: SKTexture = SKTexture(imageNamed: "Sudoeste")
    
    let directionsTexture: SKTexture = SKTexture(imageNamed: "DirectionsJoystickBG")
    
    let magicWall: String = "Parede"
    
    let combosSpritesScale: CGFloat = 0.85
    let combosSpritesAlpha: CGFloat = 0.4
    let combosSpritesAnimationDuration: CGFloat = 0.1
    
    let earthPowerTexture: SKTexture = SKTexture(imageNamed: "EarthPowers")
    let eletricPowerTexture: SKTexture = SKTexture(imageNamed: "EletricPowers")
    let icePowerTexture: SKTexture = SKTexture(imageNamed: "IcePowers")
    let firePowerTexture: SKTexture = SKTexture(imageNamed: "FirePowers")
    
    let stoneWallWidth: CGFloat = 50
    
    let thunderBuffVelocityBonus: CGFloat = 50
    
    let playerIdleTexture: SKTexture = SKTexture(imageNamed: "MagoFrente")
    
    //precisa ser var pois muda de acordo com o buff
    var damageMultiplier: Double = 1
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
    
    let spiderIdleTexture: SKTexture = SKTexture(imageNamed: "Spider")
    let spiderDeadTexture: SKTexture = SKTexture(imageNamed: "DeadSpider")
    let spiderAttackTexture: SKTexture = SKTexture(imageNamed: "SpiderAttack")
    let spiderChargingTexture: SKTexture = SKTexture(imageNamed: "SpiderPreparingJump")
    let deathDespawn: Double = 1.7
    
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
    
    var spiderDamage: Int = 5
    
    let notificationCenter = NotificationCenter.default
    
    let buttonsColor: UIColor = .white
    
    let maxJumps: Int = 2
    
    @Published var paused: Bool = false

}
