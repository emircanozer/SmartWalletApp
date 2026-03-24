import UIKit

class WelcomeCoordinator: Coordinator {
    var children: [Coordinator] = []

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = WelcomeViewModel()
        let viewController = WelcomeViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
        // push yerine set kullanmamızın sebebi stack yığınını sıfırlamak istiyoruz yani kullanıcıya geri dönüş butonu çıkmasın geri dönemesin set kullanılan ekranlar genelde ilk açılan ekranlar olur
    }
}
