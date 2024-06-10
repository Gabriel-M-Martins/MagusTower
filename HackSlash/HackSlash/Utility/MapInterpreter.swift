//
//  MapInterpreter.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 08/05/23.
//

import Foundation

struct MapInterpreter {
    var rects: [(size: CGSize, position: CGPoint)]
    var wall: [(size: CGSize, position: CGPoint)]
    var floor : [(size: CGSize, position: CGPoint)]
    
    private static func parseMapDataFromFile(path: String) -> String? {
        let path = Bundle.main.url(forResource: path, withExtension: "txt")
        
        guard let path = path else { return nil }
        return try? String(contentsOf: path)
    }
    
    init?(map: CGRect, platformHeightDistance: CGFloat, platformHeight: CGFloat, scale: CGFloat, mapText: String, isFile: Bool) {
        var text = mapText
        if isFile {
            if let parsedMap = MapInterpreter.parseMapDataFromFile(path: mapText) { text = parsedMap } else { return nil }
        }
        
        let coords = MapInterpreter.parseCoordinates(text, idx: "1")
        let platformWidth = (map.width * scale) / CGFloat(coords.1 /* *10 */)

        let minX = -map.width/2

        // -------------------------------------------------------------------------------- platforms
        rects = []
        
        var currentHeight = -map.height/2
        for line in coords.0.reversed() {
            for coord in line {
                let width = platformWidth * CGFloat(coord.size)
                let posX = (minX * scale) + (platformWidth * CGFloat(coord.start)) + width/2
                
                rects.append((CGSize(width: width, height: platformHeight), CGPoint(x: posX, y: currentHeight)))
            }
            currentHeight += platformHeightDistance
        }
        
        let coordsWall = MapInterpreter.parseCoordinates(text, idx: "2")
        let platformWidthWall = (map.width * scale) / CGFloat(coordsWall.1 /* *10 */)

        // -------------------------------------------------------------------------------- walls
        wall = []
        
        currentHeight = -map.height/2
        for line in coordsWall.0.reversed() {
            for coordWall in line {
                let width = platformWidth * CGFloat(coordWall.size)
                let posX = (minX * scale) + (platformWidthWall * CGFloat(coordWall.start)) + width/2
                
                wall.append((CGSize(width: width, height: platformHeight), CGPoint(x: posX, y: currentHeight)))
            }
            currentHeight += platformWidth
        }
        
        let coordsFloor = MapInterpreter.parseCoordinates(text, idx: "3")
        let platformWidthFloor = (map.width * scale) / CGFloat(coordsFloor.1)

        // -------------------------------------------------------------------------------- floor
        floor = []
        
        currentHeight = platformHeightDistance - map.height/2
        for line in coordsFloor.0.reversed() {
            for coordFloor in line {
                let width = platformWidth * CGFloat(coordFloor.size)
                let posX = (minX * scale) + (platformWidthFloor * CGFloat(coordFloor.start)) + width/2
                
                floor.append((CGSize(width: width, height: platformHeight), CGPoint(x: posX, y: currentHeight)))
            }
            
            currentHeight += platformHeightDistance
        }
    }
    
    static private func parseCoordinates(_ text: String, idx: String) -> ([ [(start: Int, size: Int)] ], Int) {
        let lines = text.split(whereSeparator: \.isNewline)
        var coords: [[(start: Int, size: Int)]] = []
        
        var maxWidth = 0
        
        for i in 0..<lines.count {
            let line = lines[i].split(whereSeparator: \.isWhitespace)
            
            if line.count > maxWidth {
                maxWidth = line.count
            }
            
            var lineCoords: [(start: Int, size: Int)] = []
            var j = 0
            while j < line.count {
                if line[j] == idx {
                    var k = j + 1
                    while k < line.count && line[k] == idx {
                        k += 1
                    }
                    
                    
                    lineCoords.append((start: j, size: k - j))
                    
                    j = k
                }
                
                j += 1
            }
            coords.append(lineCoords)
        }
        
        return (coords, maxWidth)
    }
}
