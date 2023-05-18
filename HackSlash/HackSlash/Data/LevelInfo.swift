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

enum Levels {
    case Tutorial, Level1
    
    func getInfo() -> LevelInfo {
        switch self {
        case .Tutorial:
            return LevelInfo(background: "MainScene", enemiesQtd: 1, mapFile: "map2")
        case .Level1:
            return LevelInfo(background: "MainScene", enemiesQtd: 0, mapFile: "map1")
        }
    }
}
