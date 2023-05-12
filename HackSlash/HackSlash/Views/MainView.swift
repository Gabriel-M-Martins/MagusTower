//
//  MainView.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 12/05/23.
//

import SwiftUI
import SpriteKit

struct MainView: View {
    @State var scene: SKScene
    
    init() {
        scene = SKScene(fileNamed: "GameScene")!
        scene.scaleMode = .aspectFill
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
