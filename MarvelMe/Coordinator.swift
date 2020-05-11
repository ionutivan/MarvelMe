//
//  Coordinator.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 11/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import UIKit

class Coordinator {

    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

protocol CoordinatorInterface {

  func start()
  
}
