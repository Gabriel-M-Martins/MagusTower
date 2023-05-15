//
//  PauseView.swift
//  menu
//
//  Created by Mateus Moura Godinho on 11/05/23.
//

import SwiftUI

struct PauseView: View {
    @State var showSettings: Bool = false
    @Binding var paused: Bool
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack{
                    Color.black.opacity(0.4)
                    Group{
                        NavigationLink(destination: {
                            MainMenuView()
                        }, label: {
                            Image("Back Paused")
                        })
                        .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.70)
                        
                        Button(action:{
                            showSettings = !showSettings
                        }, label:{
                            Image("Settings Paused")
                        })
                        .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.53)
                        
                        Button(action:{
                            paused = false
                        }, label:{
                            Image("Resume")
                        })
                        .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.36)
                    }
                    
                    Image("Paused Sign").edgesIgnoringSafeArea(.all)
                        .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.12)
                    
                    if(showSettings){
                        SettingsView(showSettings: $showSettings)
                    }
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct PauseView_Previews: PreviewProvider {
    static var previews: some View {
        PauseView(paused: GameView().$paused)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
