//
//  MenuView.swift
//  menu
//
//  Created by Mateus Moura Godinho on 10/05/23.
//

import SwiftUI
import SpriteKit

struct MainMenuView: View {
    @State var showSettings: Bool = false
    @State var showCredits: Bool = false
    @State var hasHighScore: Bool = false
    @State var highest: String = "0"
    @State var tutorial: Bool = false
    
    func loadUserData(){
        if let masterVolume = UserDefaults.standard.string(forKey: "masterVolume"), !masterVolume.isEmpty{
            AudioManager.shared.setMainVolume(Float(masterVolume)!/100.0)
        }
        
        if let musicVolume = UserDefaults.standard.string(forKey: "musicVolume"), !musicVolume.isEmpty{
            AudioManager.shared.setMusicVolume(Float(musicVolume)!/100.0)
        }
        
        if let sfxVolume = UserDefaults.standard.string(forKey: "sfxVolume"), !sfxVolume.isEmpty{
            AudioManager.shared.setSFXVolume(Float(sfxVolume)!/100.0)
        }
        
        if UserDefaults.standard.object(forKey: "highscore") != nil{
            hasHighScore = true
        }
        
        if let high = UserDefaults.standard.string(forKey: "highscore"), !high.isEmpty{
            hasHighScore = true
        }
        
//        UserDefaults.standard.removeObject(forKey: "tutorial")
        
        if UserDefaults.standard.object(forKey: "tutorial") == nil{
            print(UserDefaults.standard.bool(forKey: "tutorial"))
            tutorial = false
        }
        else{
            tutorial = true
        }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack{
                    Image("MenuBackground").resizable().scaledToFill()
                        .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY)
                    
                    ZStack{
                        Image("Correntes").edgesIgnoringSafeArea(.all)
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY*0.83)
                        
                        Group{
                            if(tutorial){
                                NavigationLink {
                                    GameView(level: Levels.Random)
                                } label: {
                                    Image("Enter")
                                }
                                .simultaneousGesture(TapGesture().onEnded{
                                    AudioManager.shared.playSound(named: "buttonClick.mp3")
                                })
                                .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.31)
                            }
                            else{
                                NavigationLink {
                                    GameView(level: Levels.Tutorial)
                                } label: {
                                    Image("Enter")
                                }
                                .simultaneousGesture(TapGesture().onEnded{
                                    AudioManager.shared.playSound(named: "buttonClick.mp3")
                                    tutorial = true
                                    UserDefaults.standard.set(true, forKey: "tutorial")
                                })
                                .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.31)
                            }
                            
                            Button(action:{
                                showSettings = !showSettings
                                AudioManager.shared.playSound(named: "buttonClick.mp3")
                            }, label:{
                                Image("Settings")
                            })
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.72)
                            
                            NavigationLink {
                                GameView(level: Levels.Tutorial)
                            } label: {
                                Image("How")
                            }
                            .simultaneousGesture(TapGesture().onEnded{
                                tutorial = true
                                UserDefaults.standard.set(true, forKey: "tutorial")
                            })
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.55)
                        }
                        
                        Button(action:{
                            showCredits = !showCredits
                            AudioManager.shared.playSound(named: "buttonClick.mp3")
                        }, label:{
                            Image("Credits")
                        })
                        .position(x: geo.frame(in: .global).minX+geo.frame(in: .global).width*0.2, y: geo.frame(in: .global).maxY-20)
                        
                        Image("FrameBotoes").edgesIgnoringSafeArea(.all)
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.12)
                        
                        if(hasHighScore){
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text("Highscore: \(UserDefaults.standard.string(forKey: "highscore")!)").foregroundColor(.white).font(.title2).opacity(0.3)
                                        .padding(.bottom, 0)
                                }
                                .padding(.trailing, 10)
                            }
                            .padding()
                        }
                        
                        if(showSettings){
                            SettingsView(showSettings: $showSettings)
                        }
                        
                        if(showCredits){
                            CreditsView(showCredits: $showCredits)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden()
        }
        .onAppear{
            loadUserData()
            AudioManager.shared.playMusic(named: "MagusTowerOST.mp3")
            
            let currentHighscore = UserDefaults.standard.string(forKey: "currentHighscore")
            let realHighscore = UserDefaults.standard.string(forKey: "highscore")
            
            var currentHighscoreValue = 0
            var realHighscoreValue = 0
            
            if let currentHighscore = currentHighscore {
                if let currentValue = Int(currentHighscore) {
                    currentHighscoreValue = currentValue
                }
            }
            
            if let realHighscore = realHighscore {
                if let realValue = Int(realHighscore) {
                    realHighscoreValue = realValue
                }
            }
            
            if currentHighscoreValue > realHighscoreValue {
                realHighscoreValue = currentHighscoreValue
            }
            
            UserDefaults.standard.set( String( realHighscoreValue ), forKey: "highscore")
            UserDefaults.standard.set( String( 0 ), forKey: "currentHighscore")
            UserDefaults.standard.set( 0, forKey: "tutorial")
            
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
