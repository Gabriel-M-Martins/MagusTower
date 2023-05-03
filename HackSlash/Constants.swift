//
//  Constants.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 02/05/23.
//
import Foundation

struct Constants {
    private let frame: CGRect

    init(frame: CGRect) {
        self.frame = frame
    }

    var platformsHeight: CGFloat {
        frame.height/18
    }
}
