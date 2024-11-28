//
//  MyInstagram_SwiftUI_App.swift
//  MyInstagram(SwiftUI)
//
//  Created by purnami indryaswari on 10/11/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      
      let db = Firestore.firestore()
      
      print(db)
      
      print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last)
      
      return true
  }
}

@main
struct MyInstagram_SwiftUI_App: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    init() {
//            FirebaseApp.configure()  // Initialize Firebase
//        }
    var body: some Scene {
        WindowGroup {
//            ContentView()
            LoginView()
//            TurtleRock()
        }
    }
}
