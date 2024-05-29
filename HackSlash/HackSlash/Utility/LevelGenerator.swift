//
//  LevelGenerator.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 28/05/24.
//

import Foundation

struct LevelGenerator {
    static func Generate(width: Int, height: Int) -> String {
        let platformSpawnChance: Float = 0.1
        
        let floor: String = String(repeating: "3", count: width)
        
        let width = width - 2
        let height = height - 3
        
        var map: String = ""
        map += floor
        map += "\n"
        map += "2" + String(repeating: "0", count: width) + "2"
        for _ in 0..<height {
            map += "\n2"
            
            var spawn: String = "0"
            var count: Int = 0
            for column in 0..<width {
                if spawn == "0" {
                    if Float.random(in: 0...1) <= platformSpawnChance {
                        var platformSize = Int.random(in: 1...5)
                        
                        if width - column < platformSize {
                            platformSize = width - column
                        }
                        
                        spawn = "1"
                        count = platformSize
                    }
                }
                
                map += spawn
                
                if count > 0 {
                    count -= 1
                } else {
                    spawn = "0"
                }
            }
            
            map += "2"
        }
        map += "\n"
        map += floor
        
        let finalMap = map.map { char in
            if char == "\n" { return "\(char)" }
            return "\(char) "
        }
        
        return finalMap.joined()
    }
}
