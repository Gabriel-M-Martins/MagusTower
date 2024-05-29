//
//  LevelInfo.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 18/05/23.
//

import Foundation

struct LevelInfo {
    let background: String
    let enemiesQtd: Int
    let mapFile: String
    let spawnRate: Double
}

enum Levels: CaseIterable {
    case Tutorial, Random
    
    func getInfo() -> LevelInfo {
        switch self {
        case .Tutorial:
            return LevelInfo(background: "MainScene", enemiesQtd: 1, mapFile: "map2", spawnRate: 1)
        case .Random:
            let height = Int.random(in: 10...12)
            let width = Int(Double(height) * 1.15)
            
            let currentLevel = Double(Constants.singleton.currentLevel)
            let enemiesQtd = Int(pow(currentLevel + 1, 2) / pow(max(1, currentLevel), 2))
            let spawnRate = Double.maximum(3, 7.0 - (4.0 * (currentLevel/10.0)))
            
            return LevelInfo(background: "MainScene", enemiesQtd: enemiesQtd, mapFile: LevelGenerator.Generate(width: width, height: height), spawnRate: spawnRate)
        }
    }
    
    func name(_ currentLevel: Int) -> String {
        switch self {
        case .Tutorial:
            return "Tutorial"
        case .Random:
            return "Level \(currentLevel)"
        }
    }
}
