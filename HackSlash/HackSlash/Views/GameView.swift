//
//  MainView.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 12/05/23.
//

import SwiftUI
import SpriteKit
import UserNotifications

struct GameView: View {
    @Environment(\.presentationMode) var presentation
    
    @State var scene: SKScene = SKScene(fileNamed: "GameScene")!
    @State var paused = false
    @ObservedObject var viewManager: GameViewManager = GameViewManager()
    
    init() {
        scene.scaleMode = .aspectFill
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
//                if UserDefaults.standard.object(forKey: "debug") != nil{
//                    if UserDefaults.standard.bool(forKey: "debug") == true{
//                        SpriteView(scene: scene, debugOptions: .showsPhysics)
//                            .edgesIgnoringSafeArea(.all)
//                            .navigationBarBackButtonHidden()
//                    }
//                    else{
//                        SpriteView(scene: scene)
//                            .edgesIgnoringSafeArea(.all)
//                            .navigationBarBackButtonHidden()
//                    }
//                }
//                else{
//                    SpriteView(scene: scene)
//                        .edgesIgnoringSafeArea(.all)
//                        .navigationBarBackButtonHidden()
//                }
                SpriteView(scene: scene)
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarBackButtonHidden()
                
                Button(action: {
                    paused = !paused
                    AudioManager.shared.playSound(named: "buttonClick.mp3")
                    scene.view?.isPaused = paused
                }, label: {
                    Image(paused ? "Play icon": "Pause icon").resizable()
                })
                .frame(width: 30, height: 40)
                .position(x: geo.frame(in: .global).minX + geo.frame(in: .global).width*0.05, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.12)
                
                HStack{
                    Image("Heart")
                    HPBar()
                    .frame(width:200, height:15)
                }
                .position(x: geo.frame(in: .global).maxX - geo.frame(in: .global).width*0.18, y: geo.frame(in: .global).minY + geo.frame(in: .global).height*0.12)
                
                if(paused){
                    PauseView(paused: $paused, scene: $scene)
                }
                
                if(viewManager.didDie){
                    GameOverView()
                        .onAppear{
                            scene.view?.isPaused = true
                        }
//                    ZStack {}
//                        .onAppear{
//                            self.presentation.wrappedValue.dismiss()
//                        }
                }
                if(viewManager.didWin){
                    GameWinView()
                        .onAppear{
                            scene.view?.isPaused = true
                        }
                }
                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

class GameViewManager: ObservableObject{
    @Published var didDie = false
    @Published var didWin = false
    let notificationCenter = NotificationCenter.default
    
    init(){
        self.notificationCenter.addObserver(self, selector: #selector(PlayerDied), name: Notification.Name("playerDeath"), object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(PlayerWin), name: Notification.Name("playerWin"), object: nil)
    }
    
    @objc func PlayerDied(){
        didDie = true
    }
    
    @objc func PlayerWin(){
        didWin = true
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView().previewInterfaceOrientation(.landscapeRight)
    }
}
