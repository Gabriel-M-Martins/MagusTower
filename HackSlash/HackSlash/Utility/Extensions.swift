//
//  Extensions.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 08/05/23.
//

import Foundation

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
    
    static func * (lhs: CGPoint, rhs: Float) -> CGPoint {
        return CGPoint(x: lhs.x * CGFloat(rhs), y: lhs.y * CGFloat(rhs))
    }
    
    mutating func normalize() {
        let divisor = self.size()
        self.x /= divisor
        self.y /= divisor
    }
    
    func toCGVector() -> CGVector {
        return CGVector(dx: self.x, dy: self.y)
    }
    
    func size() -> CGFloat {
        return sqrt( pow(self.x, 2) + pow(self.y, 2) )
    }
}
