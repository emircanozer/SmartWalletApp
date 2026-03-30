import UIKit


class AppCoordinator: Coordinator {
    var children: [Coordinator] = []

    private let window: UIWindow
    private let authNavigationController = UINavigationController()
    // auth ekranları push/pop ile ilerliyor. Bunun için bir UINavigationController gerekiyor

    init(window: UIWindow) {
        self.window = window
    }

    //app açılınca 
    func start() {
        showAuthFlow()
    }

    private func showAuthFlow() {
        authNavigationController.setNavigationBarHidden(true, animated: false)
        authNavigationController.view.backgroundColor = .white
        window.backgroundColor = .white
        window.rootViewController = authNavigationController
        window.makeKeyAndVisible()

        let authCoordinator = AuthCoordinator(navigationController: authNavigationController)
        authCoordinator.onAuthCompleted = { [weak self] in
            self?.showHomeFlow()
        }
        children = [authCoordinator]
        authCoordinator.start()
    }

    // auth flowu bitince home ' a geçiriyor auth navigation stack’i bırakılıyor, yerine home geliyor
    private func showHomeFlow() {
        let homeCoordinator = HomeCoordinator()
        children = [homeCoordinator]
        homeCoordinator.start()
        window.rootViewController = homeCoordinator.rootViewController
    }
}


/* auth'dan home geçişi push ile değil
 window.rootViewController değişerek oluyor*/
