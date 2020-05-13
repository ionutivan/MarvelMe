import Foundation

final class AppCoordinator: Coordinator {
    
    func start() {
        
        let coordinator = ComicListCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
