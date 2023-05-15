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
   
    @Binding var showSettings: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Color.black.opacity(0.4)
                
                Image("Board")
                    .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY)
                
                Button(action: {
                    showSettings = false
                }, label: {
                    Image("Back")
                })
                .position(x: geo.frame(in: .global).midX*0.52, y: geo.frame(in: .global).midY*0.34)
                
                VStack{ //SLIDERS
                    VStack(spacing: 0){ //MASTER VOLUME
                        HStack{
                            Image("Master")
                            Spacer()
                        }
                        HStack{
                            CustomSlider(value: $masterVolume,
                                         sliderRange: 0...100)
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
                                         sliderRange: 0...100)
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
                                         sliderRange: 0...100)
                            .frame(width:200, height:15)
                            Spacer()
                            Text(String(Int(round(sfxVolume*multiplier) / multiplier)) + "%").foregroundColor(Color("Chumbo")).font(.custom("NovaCut-Regular", size: 20))
                        }
                    }
                    .frame(width: geo.frame(in: .global).width*0.31)
                    .position(x: geo.frame(in: .global).midX*0.78, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.1)
                }
                .padding(.bottom, 10)
            }
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
