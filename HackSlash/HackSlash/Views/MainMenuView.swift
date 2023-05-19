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
                            NavigationLink {
                                GameView(level: Levels.Level1)
                            } label: {
                                Image("Enter")
                            }
                            .simultaneousGesture(TapGesture().onEnded{
                                AudioManager.shared.playSound(named: "buttonClick.mp3")
                            })
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.31)
                            
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
                                    Text("Highscore: 0").foregroundColor(.white).font(.title2).opacity(0.3)
                                        .padding()
                                }
                                .padding()
                            }.padding()
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
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
