//
//  AudioManager.swift
//  HackSlash
//
//  Created by Mateus Moura Godinho on 15/05/23.
//

import Foundation
import AVKit
import SwiftUI

struct AudioManager{
    @State var mainAudioPlayer: AVAudioPlayer!
    @State var musicAudioPlayer: AVAudioPlayer!
    @State var sfxAudioPlayer: AVAudioPlayer!
    
    //MAIN AUDIO MANAGER
    func setMainAudioFile(_fileName: String){
        self.mainAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: _fileName))
    }
    func setMainAudioVolume(_volume: Float){
        self.mainAudioPlayer.setVolume(_volume, fadeDuration: 1)
    }
    
    //MUSIC AUDIO MANAGER
    func setMusicAudioFile(_fileName: String){
        self.musicAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: _fileName))
    }
    func setMusicAudioVolume(_volume: Float){
        self.musicAudioPlayer.setVolume(_volume, fadeDuration: 1)
    }
    
    //SFX AUDIO MANAGER
    func setSFXAudioFile(_fileName: String){
        self.sfxAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: _fileName))
    }
    func setSFXAudioVolume(_volume: Float){
        self.sfxAudioPlayer.setVolume(_volume, fadeDuration: 1)
    }
}
