//
//  AppCoordinator.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 11/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import Foundation

final class AppCoordinator: Coordinator {
    
    func start() {
        
        let coordinator = ComicListCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
