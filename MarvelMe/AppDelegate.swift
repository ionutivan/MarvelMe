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
  var coordinator: AppCoordinator?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    let navigationController = UINavigationController()
    window?.rootViewController = navigationController
    coordinator = AppCoordinator(navigationController: navigationController)
    coordinator?.start()
    window?.makeKeyAndVisible()
    
    return true
  }
}

