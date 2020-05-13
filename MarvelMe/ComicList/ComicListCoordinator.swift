import UIKit
import RxSwift

final class ComicListCoordinator: Coordinator {
    
    let disposeBag = DisposeBag()
  
}

extension ComicListCoordinator: CoordinatorInterface {
  func start() {
      let api = MarvelService()
    let viewModel = ComicListViewModel(api: api)
      let viewController = ComicListViewController(viewModel: viewModel)

      viewController.title = "LAST COMICS"
      navigationController?.pushViewController(viewController, animated: true)
      
    viewModel.output.selectComic
      .filter{ $0 != nil }
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: { [weak self] comic in
        let coordinator = ComicDetailCoordinator(navigationController: self?.navigationController, comic: comic!)
        coordinator.start()
        self?.childCoordinators.append(coordinator)
    })
      .disposed(by: disposeBag)
      
  }
}
