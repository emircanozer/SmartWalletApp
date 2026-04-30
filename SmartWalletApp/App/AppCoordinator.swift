import UIKit


class AppCoordinator: Coordinator {
    var children: [Coordinator] = []

    private let window: UIWindow
    private let authNavigationController = UINavigationController()
    private let reachabilityService = NetworkReachabilityService()
    private var hasShownInitialOfflineAlert = false
    // token varsa home yoksa auth , login başarılıysa appkordinator > homekrodinator
    private let tokenStore = TokenStore() //keychain wrapper
    private lazy var apiClient = APIClient(tokenProvider: { [weak self] in // performans lazy ilk kullanıldığında oluşturulur
        self?.tokenStore.accessToken // APIClient her request attığında “token var mı?” diye sorar
       
    })
    private lazy var authService = AuthService(apiClient: apiClient)
    private lazy var walletService = WalletService(apiClient: apiClient)
    private lazy var assistantService = AssistantService(apiClient: apiClient)

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        showSplashFlow()
    }

    private func showSplashFlow() {
        let splashCoordinator = SplashCoordinator()
        splashCoordinator.onFinished = { [weak self] in
            self?.continueAfterSplash()
        }
        children = [splashCoordinator]
        window.backgroundColor = AppColor.appBackground
        window.rootViewController = splashCoordinator.rootViewController
        window.makeKeyAndVisible()
        splashCoordinator.start()
    }

    private func continueAfterSplash() {
        try? tokenStore.clearTokens() // tokenleri siliyor
        if tokenStore.accessToken?.isEmpty == false {
            showHomeFlow()
        } else {
            showAuthFlow()
        }
        checkInitialConnectivity()
    }

    private func showAuthFlow() {
        authNavigationController.setNavigationBarHidden(true, animated: false)
        authNavigationController.view.backgroundColor = AppColor.appBackground
        window.backgroundColor = AppColor.appBackground
        window.rootViewController = authNavigationController
        window.makeKeyAndVisible()

        let authCoordinator = AuthCoordinator(
            navigationController: authNavigationController,
            authService: authService,
            tokenStore: tokenStore
        )
        authCoordinator.onAuthCompleted = { [weak self] in
            self?.showHomeFlow()
        }
        children = [authCoordinator]
        authCoordinator.start()
    }

    private func showHomeFlow() {
        let homeCoordinator = HomeCoordinator(
            walletService: walletService,
            assistantService: assistantService,
            authService: authService,
            tokenStore: tokenStore
        )
        homeCoordinator.onLogoutRequested = { [weak self] in
            self?.showAuthFlow()
        }
        children = [homeCoordinator]
        homeCoordinator.start()
        window.backgroundColor = AppColor.appBackground
        window.rootViewController = homeCoordinator.rootViewController
        window.makeKeyAndVisible()
        print("DEBUG App: home flow baslatildi, dashboard gosteriliyor.")
    }

    private func checkInitialConnectivity() {
        reachabilityService.checkInitialConnection { [weak self] isConnected in
            guard let self, !isConnected, !self.hasShownInitialOfflineAlert else { return }
            self.hasShownInitialOfflineAlert = true
            self.presentInitialOfflineAlert()
        }
    }

    private func presentInitialOfflineAlert() {
        let alert = UIAlertController(
            title: "İnternet Bağlantısı Yok",
            message: "Lütfen internet bağlantınızı kontrol edin.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self, let presenter = self.topViewController(from: self.window.rootViewController) else { return }
            presenter.present(alert, animated: true)
        }
    }

    private func topViewController(from viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        }

        if let tabBarController = viewController as? UITabBarController {
            return topViewController(from: tabBarController.selectedViewController)
        }

        if let presentedViewController = viewController?.presentedViewController {
            return topViewController(from: presentedViewController)
        }

        return viewController
    }
}
