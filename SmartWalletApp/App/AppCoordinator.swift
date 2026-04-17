import UIKit


class AppCoordinator: Coordinator {
    var children: [Coordinator] = []

    private let window: UIWindow
    private let authNavigationController = UINavigationController()
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

    //   //token kontrolü flowu belirler
    func start() {
        try? tokenStore.clearTokens() // tokenleri siliyor
        if tokenStore.accessToken?.isEmpty == false {
            showHomeFlow()
        } else {
            showAuthFlow()
        }
    }

    private func showAuthFlow() {
        authNavigationController.setNavigationBarHidden(true, animated: false)
        authNavigationController.view.backgroundColor = .white
        window.backgroundColor = .white
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
        let homeCoordinator = HomeCoordinator(walletService: walletService, assistantService: assistantService)
        children = [homeCoordinator]
        homeCoordinator.start()
        window.backgroundColor = .white
        window.rootViewController = homeCoordinator.rootViewController
        window.makeKeyAndVisible()
        print("DEBUG App: home flow baslatildi, dashboard gosteriliyor.")
    }
}
