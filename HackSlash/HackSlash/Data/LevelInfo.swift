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
}

enum Levels: CaseIterable {
    case Tutorial, Level1, Level2, Level3, Level4
    
    func getInfo() -> LevelInfo {
        switch self {
        case .Tutorial:
            return LevelInfo(background: "Tutorial", enemiesQtd: 1, mapFile: "map2")
        case .Level1:
            return LevelInfo(background: "MainScene", enemiesQtd: 1, mapFile: "map1")
        case .Level2:
            return LevelInfo(background: "MainScene", enemiesQtd: 2, mapFile: "map1")
        case .Level3:
            return LevelInfo(background: "MainScene", enemiesQtd: 3, mapFile: "map1")
        case .Level4:
            return LevelInfo(background: "MainScene", enemiesQtd: 4, mapFile: "map1")
        }
    }
    
    func name() -> String {
        switch self {
        case .Tutorial:
            return "Tutorial"
        case .Level1:
            return "Level 1"
        case .Level2:
            return "Level 2"
        case .Level3:
            return "Level 3"
        case .Level4:
            return "Level 4"
        }
    }
}
