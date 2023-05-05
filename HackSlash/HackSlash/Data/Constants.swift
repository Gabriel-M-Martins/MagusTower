//
//  Constants.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 02/05/23.
//
import Foundation

struct Constants {
    private let frame: CGRect

    static let enemiesMask: UInt32 = 1
    static let groundMask: UInt32 = 2
    static let playerMask: UInt32 = 4
    
    init(frame: CGRect) {
        self.frame = frame
    }

    var platformsHeight: CGFloat {
        frame.height/18
    }
}
