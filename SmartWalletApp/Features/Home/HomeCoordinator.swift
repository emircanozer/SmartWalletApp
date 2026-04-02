import UIKit

class HomeCoordinator: Coordinator {
    var children: [Coordinator] = []

    let rootViewController = MainTabBarController()

    private let walletService: WalletService

    init(walletService: WalletService) {
        self.walletService = walletService
    }

    func start() {
        let dashboardViewModel = DashboardViewModel(walletService: walletService)
        let dashboardViewController = DashboardViewController(viewModel: dashboardViewModel)
        dashboardViewController.onSeeAllTransactions = { [weak self] transactions in
            self?.showAllTransactions(transactions)
        }

        let walletViewController = PlaceholderViewController(titleText: "Cüzdan")
        let assistantViewController = PlaceholderViewController(titleText: "AI Asistan")
        let transferViewController = PlaceholderViewController(titleText: "Transfer")
        let profileViewController = PlaceholderViewController(titleText: "Profil")

        let controllers = [
            makeNavigationController(root: dashboardViewController, title: "Ana Sayfa", imageName: "house"),
            makeNavigationController(root: walletViewController, title: "Cüzdan", imageName: "creditcard"),
            makeNavigationController(root: assistantViewController, title: "AI Asistan", imageName: "cpu"),
            makeNavigationController(root: transferViewController, title: "Transfer", imageName: "arrow.left.arrow.right"),
            makeNavigationController(root: profileViewController, title: "Profil", imageName: "person")
        ]

        rootViewController.setViewControllers(controllers, animated: false)
    }

    private func makeNavigationController(root: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        return navigationController
    }

    private func showAllTransactions(_ transactions: [DashboardTransaction]) {
        guard let controllers = rootViewController.viewControllers,
              let navigationController = controllers.first as? UINavigationController else { return }

        let viewModel = TransactionsListViewModel(transactions: transactions)
        let viewController = TransactionsListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
