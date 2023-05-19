//
//  GameOverView.swift
//  HackSlash
//
//  Created by Mateus Moura Godinho on 17/05/23.
//

import SwiftUI

struct GameOverView: View {
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
                        .simultaneousGesture(TapGesture().onEnded{
                            AudioManager.shared.playSound(named: "buttonClick.mp3")
                        })
                        .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.70)
                        
                        Image("GameOver Sign")
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.3)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView().previewInterfaceOrientation(.landscapeRight)
    }
}
