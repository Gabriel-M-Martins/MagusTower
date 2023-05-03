//
//  AnimationInfo.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 03/05/23.
//

import Foundation
import SpriteKit

struct AnimationInfo {
    var textures: [SKTexture]
    var duration: Double
    var repeating: Bool = false
    /// in case we want to execute something after/before the animation, implement this:
    /// before: () -> Void
    /// after: () -> Void
}
