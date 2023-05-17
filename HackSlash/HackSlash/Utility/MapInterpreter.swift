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
    
    init?(map: CGRect, platformHeightDistance: CGFloat, platformHeight: CGFloat, scale: CGFloat) {
        let path = Bundle.main.url(forResource: "map1", withExtension: "txt")
        
        guard let path = path else { return nil }
        guard let text = try? String(contentsOf: path) else { return nil }
        
        let coords = MapInterpreter.parseCoordinates(text, idx: "1")
        let platformWidth = (map.width * scale) / CGFloat(coords.1 /* *10 */)

        rects = []
        
        var currentHeight = map.minY
        for line in coords.0.reversed() {
            for coord in line {
                let width = platformWidth * CGFloat(coord.size)
                let posX = (map.minX * scale) + (platformWidth * CGFloat(coord.start)) + width/2
                
                rects.append((CGSize(width: width, height: platformHeight), CGPoint(x: posX, y: currentHeight)))
            }
            currentHeight += platformHeightDistance
        }
        
        print(rects[0])
        print(map.origin)
        print(map.width)
        print(map.width / CGFloat(coords.1))
        
        let coordsWall = MapInterpreter.parseCoordinates(text, idx: "2")
        let platformWidthWall = (map.width * scale) / CGFloat(coordsWall.1 /* *10 */)

        wall = []
        
        currentHeight = map.minY
        for line in coordsWall.0.reversed() {
            for coordWall in line {
                let width = platformWidth * CGFloat(coordWall.size)
                let posX = (map.minX * scale) + (platformWidthWall * CGFloat(coordWall.start)) + width/2
                
                wall.append((CGSize(width: width, height: platformHeight), CGPoint(x: posX, y: currentHeight)))
            }
            currentHeight += platformHeightDistance
        }
        
        print(wall[0])
        print(map.origin)
        print(map.width)
        print(map.width / CGFloat(coordsWall.1))
        
        let coordsFloor = MapInterpreter.parseCoordinates(text, idx: "3")
        let platformWidthFloor = (map.width * scale) / CGFloat(coordsFloor.1 /* *10 */)

        floor = []
        
        currentHeight = map.minY
        for line in coordsFloor.0.reversed() {
            for coordFloor in line {
                let width = platformWidth * CGFloat(coordFloor.size)
                let posX = (map.minX * scale) + (platformWidthFloor * CGFloat(coordFloor.start)) + width/2
                
                floor.append((CGSize(width: width, height: platformHeight), CGPoint(x: posX, y: currentHeight)))
            }
            currentHeight += platformHeightDistance
        }
        
        print(floor[0])
        print(map.origin)
        print(map.width)
        print(map.width / CGFloat(coordsFloor.1))
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
