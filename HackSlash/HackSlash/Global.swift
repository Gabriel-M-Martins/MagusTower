//
//  Global.swift
//  HackSlash
//
//  Created by Pedro Mezacasa Muller on 09/05/23.
//

import Foundation
import SpriteKit
class myFrame{
    static let myVariables: myFrame = myFrame()
    var frame: CGSize
    var scene: SKScene
    private init(){
        self.frame = CGSize.zero
        self.scene = SKScene()
    }
}
