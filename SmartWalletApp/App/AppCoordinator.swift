import UIKit

class AppCoordinator: Coordinator {
    var children: [Coordinator] = []

    private let window: UIWindow
    private let navigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.view.backgroundColor = .white
        window.backgroundColor = .white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        children.append(loginCoordinator)
        loginCoordinator.start()
    }
}
