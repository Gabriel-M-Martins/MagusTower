//
//  PauseView.swift
//  menu
//
//  Created by Mateus Moura Godinho on 11/05/23.
//

import SwiftUI

struct PauseView: View {
    @State var showSettings: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Color.black.opacity(0.4)
                Group{
                    Button(action:{
                        
                    }, label:{
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

struct PauseView_Previews: PreviewProvider {
    static var previews: some View {
        PauseView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
