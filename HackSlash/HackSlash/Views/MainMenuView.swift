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
//    @State var audio: AudioManager = AudioManager()

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
                                GameView()
                            } label: {
                                Image("Enter")
                            }
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.31)
                            
                            Button(action:{
                                showSettings = !showSettings
                            }, label:{
                                Image("Settings")
                            })
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.72)
                            
                            Button(action:{
                                
                            }, label:{
                                Image("How")
                            })
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.55)
                        }
                        
                        Button(action:{
                            showCredits = !showCredits
                        }, label:{
                            Image("Credits")
                        })
                        .position(x: geo.frame(in: .global).minX+geo.frame(in: .global).width*0.2, y: geo.frame(in: .global).maxY-20)
                        
                        Image("FrameBotoes").edgesIgnoringSafeArea(.all)
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.12)
                        
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
//            audio.setMainAudioFile(_fileName: "magicCast")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
