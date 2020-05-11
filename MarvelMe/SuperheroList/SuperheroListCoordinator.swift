//
//  SuperheroesListCoordinator.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 11/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import UIKit
import RxSwift

final class SuperheroListCoordinator: Coordinator {
    
    let disposeBag = DisposeBag()
  
}

extension SuperheroListCoordinator: CoordinatorInterface {
  func start() {
      let api = MarvelService()
    let viewModel = SuperheroListViewModel(api: api)
      let viewController = SuperheroListViewController(viewModel: viewModel)

      viewController.title = "LAST TRIPS"
      navigationController?.pushViewController(viewController, animated: true)
      
    viewModel.output.selectSuperhero.asDriver(onErrorJustReturn: nil).drive(onNext: { [weak self] hero in
      // TODO: start detail coordinator
    }).disposed(by: disposeBag)
      
  }
}
