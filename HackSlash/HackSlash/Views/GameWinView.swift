//
//  GameWinView.swift
//  HackSlash
//
//  Created by Felipe  Elsner Silva on 18/05/23.
//

import SwiftUI

struct GameWinView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack{
                    Color.black.opacity(0.4)
                    Group{
                        NavigationLink(destination: {
                            MainMenuView()
                        }, label: {
                            Image("Next")
                        })
                        .simultaneousGesture(TapGesture().onEnded{
                            AudioManager.shared.playSound(named: "buttonClick.mp3")
                        })
                        .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.70)
                        
                        Image("GameWin Sign")
                            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.3)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct GameWinView_Previews: PreviewProvider {
    static var previews: some View {
        GameWinView().previewInterfaceOrientation(.landscapeRight)
    }
}
