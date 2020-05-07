//
//  AppDelegate.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 07/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let initialController = ViewController()
    
    self.window = UIWindow(frame: UIScreen.main.bounds)

    self.window?.rootViewController = initialController
    self.window?.makeKeyAndVisible()
    
    return true
  }
}

