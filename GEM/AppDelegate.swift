//
//  AppDelegate.swift
//  GEM
//
//  Created by Emre Özdil on 02/10/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initial View
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = LoginRegisterViewController()
        
        // Firebase configuration and sign out 
        FirebaseApp.configure()
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        return true
    }
}
