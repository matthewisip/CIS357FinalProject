//
//  CIS357_FinalProjectApp.swift
//  CIS357-FinalProject
//
//  Created by Kyle J. Fink on 11/20/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct DiscGolfCardsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginScreenView()
            }
        }
    }
}
