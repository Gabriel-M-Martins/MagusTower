//
//  TutorialView.swift
//  HackSlash
//
//  Created by Felipe  Elsner Silva on 18/05/23.
//

import SwiftUI
import SpriteKit
import UserNotifications

struct TutorialView: View {
    @Environment(\.presentationMode) var presentation
    
    @State var scene: SKScene = SKScene(fileNamed: "TutorialScene")!
    @State var paused = false
    @ObservedObject var viewManager: TutorialViewManager = TutorialViewManager()
    
    init() {
        scene.scaleMode = .aspectFill
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                SpriteView(scene: scene)
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarBackButtonHidden()
                
                Button(action: {
                    paused = !paused
                    AudioManager.shared.playSound(named: "buttonClick.mp3")
                    paused = true
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
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

class TutorialViewManager: ObservableObject{
    @Published var didDie = false
    let notificationCenter = NotificationCenter.default
    
    init(){
        self.notificationCenter.addObserver(self, selector: #selector(PlayerDied), name: Notification.Name("playerDeath"), object: nil)
    }
    
    @objc func PlayerDied(){
        didDie = true
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView().previewInterfaceOrientation(.landscapeLeft)
    }
}

/*
 “To move, use the joystick in the bottom left corner of the screen. You can junp up to 3 times before needing to land”

 “Use the joystick in the bottom right corner of the screen to first select an element then, select the type of magic and finally, select the direction.”

 “To cast a Fireball, do the following swipes (from the center): Left(fire),  Up(projectile), Right(direction of the attack)”

 “Beyond this wall is an enemy, try defeating it with the spell of your choosing.”
 */
