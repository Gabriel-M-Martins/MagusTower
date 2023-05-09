//
//  MapInterpreter.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 08/05/23.
//

import Foundation

struct MapInterpreter {
    var rects: [(size: CGSize, position: CGPoint)]
    
    init?(map: CGRect, platformHeight: CGFloat) {
        let path = Bundle.main.url(forResource: "map1", withExtension: "txt")
        
        guard let path = path else { return nil }
        guard let text = try? String(contentsOf: path) else { return nil }
        
        let coords = MapInterpreter.findCoords(text)
        let platformWidth = map.width / CGFloat(coords.count /* *10 */)

        rects = []
        
        var currentHeight = map.minY
        for line in coords.reversed() {
            for coord in line {
                let width = platformWidth * CGFloat(coord.size)
                let posX = map.minX + (platformWidth * CGFloat(coord.start))
                
                rects.append((CGSize(width: width, height: platformHeight), CGPoint(x: posX, y: currentHeight)))
            }
            currentHeight += platformHeight
        }
    }
    
    static private func findCoords(_ text: String) -> [[(start: Int, size: Int)]] {
        let lines = text.split(whereSeparator: \.isNewline)
        var coords: [[(start: Int, size: Int)]] = []
        
        for i in 0..<lines.count {
            let line = lines[i].split(whereSeparator: \.isWhitespace)
            
            var lineCoords: [(start: Int, size: Int)] = []
            var j = 0
            while j < line.count {
                if line[j] == "1" {
                    var k = j + 1
                    while k < line.count && line[k] == "1" {
                        k += 1
                    }
                    
                    
                    lineCoords.append((start: j, size: k - j))
                    
                    j = k
                }
                
                j += 1
            }
            coords.append(lineCoords)
        }
        
        return coords
    }
}
