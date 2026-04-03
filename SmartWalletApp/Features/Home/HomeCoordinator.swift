import UIKit

class HomeCoordinator: Coordinator {
    var children: [Coordinator] = []

    let rootViewController = MainTabBarController()

    private let walletService: WalletService
    private weak var sendMoneyNavigationController: UINavigationController?

    init(walletService: WalletService) {
        self.walletService = walletService
    }

    func start() {
        let dashboardViewModel = DashboardViewModel(walletService: walletService)
        let dashboardViewController = DashboardViewController(viewModel: dashboardViewModel)
        let sendMoneyViewModel = SendMoneyViewModel(walletService: walletService)
        let sendMoneyViewController = SendMoneyViewController(viewModel: sendMoneyViewModel)

        let walletViewController = PlaceholderViewController(titleText: "Cüzdan")
        let assistantViewController = PlaceholderViewController(titleText: "AI Asistan")
        let profileViewController = PlaceholderViewController(titleText: "Profil")

        let dashboardNavigationController = makeNavigationController(root: dashboardViewController, title: "Ana Sayfa", imageName: "house")
        let walletNavigationController = makeNavigationController(root: walletViewController, title: "Cüzdan", imageName: "creditcard")
        let assistantNavigationController = makeNavigationController(root: assistantViewController, title: "AI Asistan", imageName: "cpu")
        let sendMoneyNavigationController = makeNavigationController(root: sendMoneyViewController, title: "Transfer", imageName: "arrow.left.arrow.right")
        let profileNavigationController = makeNavigationController(root: profileViewController, title: "Profil", imageName: "person")

        self.sendMoneyNavigationController = sendMoneyNavigationController

        dashboardViewController.onSeeAllTransactions = { [weak self] transactions in
            self?.showAllTransactions(transactions)
        }
        dashboardViewController.onSendMoneyTap = { [weak self] in
            self?.showSendMoneyTab()
        }

        let controllers = [
            dashboardNavigationController,
            walletNavigationController,
            assistantNavigationController,
            sendMoneyNavigationController,
            profileNavigationController
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

        let viewModel = TransactionsListViewModel(
            transactions: transactions,
            reloadTransactions: { [walletService] in
                let wallet = try await walletService.fetchMyWallet()
                let transactionResponses = try await walletService.fetchTransactions(walletId: wallet.id)
                return TransactionsListViewModel.mapTransactions(transactionResponses)
            }
        )
        let viewController = TransactionsListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showSendMoneyTab() {
        guard let sendMoneyNavigationController else { return }
        rootViewController.selectedViewController = sendMoneyNavigationController
    }
}
