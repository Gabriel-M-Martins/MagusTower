//
//  CreditsView.swift
//  menu
//
//  Created by Mateus Moura Godinho on 11/05/23.
//

import SwiftUI

struct CreditsView: View {
    @Binding var showCredits: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Color.black.opacity(0.4)
                Image("Credits panel")
                
                Button(action: {
                    showCredits = false
                }, label: {
                    Image("Back credits")
                })
                .position(x: geo.frame(in: .global).midX*0.65, y: geo.frame(in: .global).midY*0.38)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView(showCredits: MainMenuView().$showCredits)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
