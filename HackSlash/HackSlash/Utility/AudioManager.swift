//
//  AudioManager.swift
//  HackSlash
//
//  Created by Mateus Moura Godinho on 15/05/23.
//

import AVFoundation

class AudioManager {
    static let shared = AudioManager()  // Singleton instance
    
    private var mainVolume: Float = 1.0
    private var musicVolume: Float = 1.0
    private var sfxVolume: Float = 1.0
    
    private var musicPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?
    
    func playMusic(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            print("Error: Music file not found.")
            return
        }

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
            musicPlayer?.volume = musicVolume * mainVolume
        } catch {
            print("Error: Failed to play music - \(error.localizedDescription)")
        }
    }
    
    func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            print("Error: Sound file not found.")
            return
        }

        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.prepareToPlay()
            sfxPlayer?.play()
            sfxPlayer?.volume = sfxVolume * mainVolume
        } catch {
            print("Error: Failed to play sound - \(error.localizedDescription)")
        }
    }
    
    func setMainVolume(_ volume: Float) {
        mainVolume = max(0.0, min(1.0, volume))
        updateVolumes()
    }
    
    func setMusicVolume(_ volume: Float) {
        musicVolume = max(0.0, min(1.0, volume))
        updateVolumes()
    }
    
    func setSFXVolume(_ volume: Float) {
        sfxVolume = max(0.0, min(1.0, volume))
        updateVolumes()
    }
    
    private func updateVolumes() {
        musicPlayer?.volume = musicVolume * mainVolume
        sfxPlayer?.volume = sfxVolume * mainVolume
    }
}
