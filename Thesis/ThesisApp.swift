//
//  TheisApp.swift
//  Theis
//
//  Created by Kansinee Klinkhachon on 22/10/2568 BE.
//

import SwiftUI
import Firebase
//import FirebaseCore

@main
struct ThesisApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    print("Configure Firebase!")

    return true
  }
}
