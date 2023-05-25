//
//  AppDelegate.swift
//  HackSlash
//
//  Created by Gabriel Medeiros Martins on 24/04/23.
//

//import UIKit
import SwiftUI
import NotificationCenter
//@main
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//
//        return true
//    }
//}

@main
struct HackSlashApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .onAppear {
                    Constants.singleton.frame = UIScreen.main.bounds
                }
        }
    }
}


