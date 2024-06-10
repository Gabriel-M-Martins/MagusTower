//
//  FloorSignView.swift
//  HackSlash
//
//  Created by Mateus Moura Godinho on 19/05/23.
//

import SwiftUI

struct FloorSignView: View {
    var signText: String {
        if Constants.singleton.currentLevel == 0 {
            return "Tutorial"
        } else {
            return "Floor \(Constants.singleton.currentLevel)"
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Image("FloorSign")
                
                Text(signText)
                    .foregroundColor(Color("Chumbo")).bold().font(.title2)
                    .padding(.bottom, 10)
            }
            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.08)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct FloorSignView_Previews: PreviewProvider {
    static var previews: some View {
        FloorSignView().previewInterfaceOrientation(.landscapeRight)
    }
}
