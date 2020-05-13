import UIKit

final class ComicDetailCoordinator: Coordinator {
    
  private var comic: Comic!
    
  init(navigationController: UINavigationController?, comic: Comic) {
      super.init(navigationController: navigationController)
      self.comic = comic
  }
    
    func start() {
      let api = MarvelService()
        let viewModel = ComicDetailViewModel(api: api)
        let viewController = ComicDetailViewController(viewModel: viewModel, comic: comic)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
