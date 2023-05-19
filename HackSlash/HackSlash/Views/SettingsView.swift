//
//  SettingsView.swift
//  menu
//
//  Created by Mateus Moura Godinho on 10/05/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var masterVolume = 100.0
    @State private var musicVolume = 100.0
    @State private var sfxVolume = 100.0
    let multiplier = pow(10.0, 0.0)
    @State private var debug: Bool = false
   
    @Binding var showSettings: Bool
    
    func loadUserData(){
        if let masterVolume = UserDefaults.standard.string(forKey: "masterVolume"), !masterVolume.isEmpty{
            self.masterVolume = Double(masterVolume) ?? 100.0
        }
        
        if let musicVolume = UserDefaults.standard.string(forKey: "musicVolume"), !musicVolume.isEmpty{
            self.musicVolume = Double(musicVolume) ?? 100.0
        }
        
        if let sfxVolume = UserDefaults.standard.string(forKey: "sfxVolume"), !sfxVolume.isEmpty{
            self.sfxVolume = Double(sfxVolume) ?? 100.0
        }
        
        if UserDefaults.standard.object(forKey: "debug") != nil{
            self.debug = UserDefaults.standard.bool(forKey: "debug")
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Color.black.opacity(0.4)
                
                Image("Board")
                    .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY)
                
                Button(action: {
                    showSettings = false
                    AudioManager.shared.playSound(named: "buttonClick.mp3")
                }, label: {
                    Image("Back")
                })
                .position(x: geo.frame(in: .global).midX*0.52, y: geo.frame(in: .global).midY*0.34)
                
                ZStack{
                    VStack{ //SLIDERS
                        VStack(spacing: 0){ //MASTER VOLUME
                            HStack{
                                Image("Master")
                                Spacer()
                            }
                            HStack{
                                CustomSlider(value: $masterVolume,
                                             sliderRange: 0...100, sliderType: Sliders.master)
                                .frame(width:200, height:15)
                                Spacer()
                                Text(String(Int(round(masterVolume*multiplier) / multiplier)) + "%").foregroundColor(Color("Chumbo")).font(.custom("NovaCut-Regular", size: 20))
                            }
                        }
                        .frame(width: geo.frame(in: .global).width*0.31)
                        .position(x: geo.frame(in: .global).midX*0.78, y: geo.frame(in: .global).midY)
                        
                        VStack(spacing: 0){ //MUSIC VOLUME
                            HStack{
                                Image("Music")
                                Spacer()
                            }
                            HStack{
                                CustomSlider(value: $musicVolume,
                                             sliderRange: 0...100, sliderType: Sliders.music)
                                .frame(width:200, height:15)
                                Spacer()
                                Text(String(Int(round(musicVolume*multiplier) / multiplier)) + "%").foregroundColor(Color("Chumbo")).font(.custom("NovaCut-Regular", size: 20))
                            }
                        }
                        .frame(width: geo.frame(in: .global).width*0.31)
                        .position(x: geo.frame(in: .global).midX*0.78, y: geo.frame(in: .global).midY*0.6)
                        
                        VStack(spacing: 0){ //SFX VOLUME
                            HStack{
                                Image("SFX")
                                Spacer()
                            }
                            HStack{
                                CustomSlider(value: $sfxVolume,
                                             sliderRange: 0...100, sliderType: Sliders.sfx)
                                .frame(width:200, height:15)
                                Spacer()
                                Text(String(Int(round(sfxVolume*multiplier) / multiplier)) + "%").foregroundColor(Color("Chumbo")).font(.custom("NovaCut-Regular", size: 20))
                            }
                        }
                        .frame(width: geo.frame(in: .global).width*0.31)
                        .position(x: geo.frame(in: .global).midX*0.78, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.1)
                    }
                    .padding(.bottom, 10)
                    
                    VStack{ //OTHERS
                        HStack(spacing: 10){
                            ZStack{
                                Button(action: {
                                    debug = !debug
                                    UserDefaults.standard.set(debug, forKey: "debug")
                                    AudioManager.shared.playSound(named: "buttonClick.mp3")
                                }, label: {
                                    Image(debug ? "Checkmark":"Checkbox")
                                })
                            }
                            Image("Hitboxes")
                        }
                        .frame(width: geo.frame(in: .global).width*0.31)
                        .position(x: geo.frame(in: .global).maxX*0.67, y: geo.frame(in: .global).midY)
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        .onAppear{
            loadUserData()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettings: MainMenuView().$showSettings)
//        SettingsView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
