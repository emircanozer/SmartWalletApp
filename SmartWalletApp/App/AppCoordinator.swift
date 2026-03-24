import UIKit

class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private var loginCoordinator: LoginCoordinator?

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
        self.loginCoordinator = loginCoordinator
        loginCoordinator.start()
    }
}
