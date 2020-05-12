//
//  ComicDetailCoordinator.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 11/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import UIKit

final class ComicDetailCoordinator: Coordinator {
    
  private var comic: Comic!
    
  init(navigationController: UINavigationController?, comic: Comic) {
      super.init(navigationController: navigationController)
      self.comic = comic
  }
    
    func start() {
        let viewModel = ComicDetailViewModel()
        let viewController = ComicDetailViewController(viewModel: viewModel, comic: comic)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
