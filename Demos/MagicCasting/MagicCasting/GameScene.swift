//
//  GameScene.swift
//  MagicCasting
//
//  Created by Gabriel Medeiros Martins on 28/04/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var fireballs: [SKEmitterNode] = []
    
    var rect = SKShapeNode()
    var circle = SKShapeNode()
    var scn = SKScene()
    var arrow = SKSpriteNode()
    
    var start: CGPoint?
    var directions: [Direction] = []
    var centro = CGPoint(x: 280, y: -100)
    
    private func createFireball(_ vector: CGVector) {
        let fireball = SKEmitterNode(fileNamed: "FireTrace")!
        let angle = calcAngle(vector)
        fireball.setScale(0.5)
        fireball.zRotation = angle
        
        let a = vector * 300
        
        fireball.physicsBody = SKPhysicsBody()
        fireball.physicsBody?.isDynamic = true
        fireball.physicsBody?.affectedByGravity = false
        fireball.physicsBody?.velocity = a
        fireball.physicsBody!.applyImpulse(a)
        
        fireballs.append(fireball)
        addChild(fireball)
        print(fireballs.count)
    }
    
    private func calcAngle(_ v: CGVector) -> CGFloat {
        var at = CGFloat()
        
        if v.dx < 0 {
            at = CGFloat.pi + atan(v.dy / v.dx)
        } else {
            if v.dy > 0 {
                at = atan(v.dy / v.dx)
            } else {
                at = (2 * CGFloat.pi) + atan(v.dy / v.dx)
            }
        }
        
        return at
    }
    
    private func isOnFrame(_ location: CGPoint, _ rect: SKShapeNode) -> Bool {
        location.x >= (rect.position.x - rect.frame.width/2) && location.x <= (rect.position.x + rect.frame.width/2) &&
        location.y >= (rect.position.y - rect.frame.height/2) && location.y <= (rect.position.y + rect.frame.height/2)
    }
    
    private func isOnFrame(_ location: CGPoint, _ pos: CGPoint, _ rect: CGRect) -> Bool {
        location.x >= (pos.x - rect.width/2) && location.x <= (pos.x + rect.width/2) &&
        location.y >= (pos.y - rect.height/2) && location.y <= (pos.y + rect.height/2)
    }
    
    
    @objc private func handleGesture(_ recognizer: UIPanGestureRecognizer) {
        let location = scn.convertPoint(fromView: recognizer.location(in: view))
        
        switch recognizer.state {
        case .failed:
            print(scn.convertPoint(fromView: recognizer.location(in: view)))
        case .began:
            guard location.x >= (rect.position.x - rect.frame.width/2) && location.x <= (rect.position.x + rect.frame.width/2) &&
                    location.y >= (rect.position.y - rect.frame.height/2) && location.y <= (rect.position.y + rect.frame.height/2) else {
                return
            }
            
            start = location
            
        case .ended:
            guard let start = self.start else { return }
            guard location - start != CGPoint() else { return }
            
            let v = CGVector(location - start).normalized()
            
            let at = calcAngle(v)
            
            let arrowActionSequence = SKAction.sequence([
                SKAction.group([
                    SKAction.fadeAlpha(to: 1, duration: 0.25),
                    SKAction.rotate(toAngle: at, duration: 0.01)]),
                SKAction.fadeAlpha(to: 0.4, duration: 0.25)
            ])
            
            arrow.run(arrowActionSequence)
            self.start = nil
            
            let dir =  Direction.map4(Float(at))
            directions.append(dir)
            
            if directions.count == 3 {
                let label = SKLabelNode(text: MagiaCombada.combo(primaria: .map(directions[0]), modificador: .map(directions[1])).rawValue )
                label.name = "label"
                label.color = .white
                label.position = CGPoint(x: 0, y: 100)
                label.fontSize = 60
                scene?.addChild(label)
                
                createFireball(v)
                
                directions = []
            } else {
                scene?.childNode(withName: "label")?.removeFromParent()
            }
            
            circle.run(SKAction.move(to: centro, duration: 0.1))
        case .changed:
            guard let start = self.start else { return }
            guard location - start != CGPoint() else { return }
            
            var v = CGVector(location - start).normalized()
            v = v * 60
            v = CGVector(dx: v.dx + centro.x, dy: v.dy + centro.y)
            circle.run(SKAction.move(to: (v).toPoint(), duration: 0.1))
        default:
            return
        }
    }
    
    override func didMove(to view: SKView) {
        rect = SKShapeNode(rectOf: CGSize(width: 120, height: 120))
        rect.position = centro
        rect.name = "rect"
        scene?.addChild(rect)
        
        let crosspath = CGMutablePath()
        crosspath.move(to: CGPoint(x: rect.position.x - rect.frame.width/2, y: rect.position.y - rect.frame.height/2))
        crosspath.addLine(to: CGPoint(x: rect.position.x + rect.frame.width/2, y: rect.position.y + rect.frame.height/2))
        
        crosspath.move(to: CGPoint(x: rect.position.x - rect.frame.width/2, y: rect.position.y + rect.frame.height/2))
        crosspath.addLine(to: CGPoint(x: rect.position.x + rect.frame.width/2, y: rect.position.y - rect.frame.height/2))
        
        let cross = SKShapeNode(path: crosspath)
        cross.strokeColor = .white
        scene?.addChild(cross)
        
        circle = SKShapeNode(circleOfRadius: 15)
        circle.name = "circle"
        circle.fillColor = .white
        circle.position = centro
        scene?.addChild(circle)
        
        arrow = SKSpriteNode(imageNamed: "arrow")
        arrow.name = "arrow"
        arrow.setScale(0.1)
        arrow.alpha = 0.0
        arrow.position = CGPoint(x: 0, y: -100)
        scene?.addChild(arrow)
        
        if let s = scene {
            self.scn = s
        }
        
        let gr = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        gr.maximumNumberOfTouches = 1
        self.view?.addGestureRecognizer(gr)
    }
    
    override func update(_ currentTime: TimeInterval) {
        fireballs = fireballs.filter{ fireball in
            isOnFrame(fireball.position, CGPoint(), scn.frame)
        }
    }
    
}

extension CGVector {
    init(_ point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
    
    func normalized() -> CGVector {
        let sqrt = sqrt(pow(dx, 2) + pow(dy, 2))
        
        return CGVector(dx: dx/sqrt, dy: dy/sqrt)
    }
    
    func toPoint() -> CGPoint {
        return CGPoint(x: dx, y: dy)
    }
    
    static func * (lhs: CGVector, rhs: Float) -> CGVector {
        return CGVector(dx: lhs.dx * CGFloat(rhs), dy: lhs.dy * CGFloat(rhs))
    }
}

extension CGPoint {
    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y
        
        return CGPoint(x: x, y: y)
    }
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        let x = lhs.x + rhs.x
        let y = lhs.y + rhs.y
        
        return CGPoint(x: x, y: y)
    }
}

enum Direction {
    case north, south, east, west, northeast, northwest, southeast, southwest
    
    static func map8(_ radians: Float) -> Direction {
        let degrees = radians * 180 / Float.pi
        
        if degrees <= 25 {
            return .east
        }
        
        if degrees <= 70 {
            return .northeast
        }
        
        if degrees <= 110 {
            return .north
        }
        
        if degrees <= 155 {
            return .northwest
        }
        
        if degrees <= 205 {
            return .west
        }
        
        if degrees <= 250 {
            return .southwest
        }
        
        if degrees <= 295 {
            return .south
        }
        
        if degrees <= 335 {
            return .southeast
        }
        
        return .east
    }
    
    static func map4(_ radians: Float) -> Direction {
        let degrees = radians * 180 / Float.pi
        
        if degrees <= 45 {
            return .east
        }
        
        if degrees <= 135 {
            return .north
        }
        
        if degrees <= 225 {
            return .west
        }
        
        if degrees <= 315 {
            return .south
        }
        
        return .east
    }
}

enum MagiaPrimaria {
    case A, B, C, D, NoOp
}

enum MagiaModificador {
    case X, Y, W, Z, NoOp
}

enum MagiaCombada: String {
    case magia1 = "Magia 1"
    case magia2 = "Magia 2"
    case magia3 = "Magia 3"
    case magia4 = "Magia 4"
    case magia5 = "Magia 5"
    case magia6 = "Magia 6"
    case magia7 = "Magia 7"
    case magia8 = "Magia 8"
    case magia9 = "Magia 9"
    case magia10 = "Magia 10"
    case magia11 = "Magia 11"
    case magia12 = "Magia 12"
    case magia13 = "Magia 13"
    case magia14 = "Magia 14"
    case magia15 = "Magia 15"
    case magia16 = "Magia 16"
    case NoOp = "Combo Inexistente"
    
    static func combo(primaria: MagiaPrimaria, modificador: MagiaModificador) -> MagiaCombada {
        switch primaria {
        
        case .A:
            switch modificador {
            case .X:
                return .magia1
            case .Y:
                return .magia2
            case .Z:
                return .magia3
            case .W:
                return .magia4
            case .NoOp:
                return .NoOp
            }
            
        case .B:
            switch modificador {
            case .X:
                return .magia5
            case .Y:
                return .magia6
            case .Z:
                return .magia7
            case .W:
                return .magia8
            case .NoOp:
                return .NoOp
            }
        
        case .C:
            switch modificador {
            case .X:
                return .magia9
            case .Y:
                return .magia10
            case .Z:
                return .magia11
            case .W:
                return .magia12
            case .NoOp:
                return .NoOp
            }
            
        case .D:
            switch modificador {
            case .X:
                return .magia13
            case .Y:
                return .magia14
            case .Z:
                return .magia15
            case .W:
                return .magia16
            case .NoOp:
                return .NoOp
            }
        case .NoOp:
            return .NoOp
        }
    }
}

protocol MagicMapper {
    associatedtype T
    static func map(_ dir: Direction) -> T
}

extension MagiaPrimaria: MagicMapper {
    static func map(_ dir: Direction) -> MagiaPrimaria {
            switch dir {
            case .north:
                return .A
            case .west:
                return .B
            case .south:
                return .C
            case .east:
                return .D
            default:
                return .NoOp
            }
        }
}

extension MagiaModificador: MagicMapper {
    static func map(_ dir: Direction) -> MagiaModificador {
            switch dir {
            case .north:
                return .W
            case .west:
                return .X
            case .south:
                return .Y
            case .east:
                return .Z
            default:
                return .NoOp
            }
        }
}
