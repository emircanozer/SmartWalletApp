import UIKit

class HomeCoordinator: Coordinator {
    var children: [Coordinator] = []

    let rootViewController = MainTabBarController()

    private let walletService: WalletService
    private let assistantService: AssistantService
    private weak var sendMoneyNavigationController: UINavigationController?

    init(walletService: WalletService, assistantService: AssistantService) {
        self.walletService = walletService
        self.assistantService = assistantService
    }

    func start() {
        let dashboardViewModel = DashboardViewModel(walletService: walletService)
        let dashboardViewController = DashboardViewController(viewModel: dashboardViewModel)
        let sendMoneyViewModel = SendMoneyViewModel(walletService: walletService)
        let sendMoneyViewController = SendMoneyViewController(viewModel: sendMoneyViewModel)
        let marketPricesViewModel = MarketPricesViewModel(walletService: walletService)
        let marketPricesViewController = MarketPricesViewController(viewModel: marketPricesViewModel)
        let assistantViewModel = AIAssistantViewModel(assistantService: assistantService)
        let assistantViewController = AIAssistantViewController(viewModel: assistantViewModel)
        let profileViewController = PlaceholderViewController(titleText: "Profil")

        let dashboardNavigationController = makeNavigationController(root: dashboardViewController, title: "Ana Sayfa", imageName: "house")
        let walletNavigationController = makeNavigationController(root: marketPricesViewController, title: "Piyasalar", imageName: "chart.bar.xaxis.ascending")
        let assistantNavigationController = makeNavigationController(root: assistantViewController, title: "SWAY", imageName: "apple.intelligence")
        let sendMoneyNavigationController = makeNavigationController(root: sendMoneyViewController, title: "Transfer", imageName: "arrow.left.arrow.right")
        let profileNavigationController = makeNavigationController(root: profileViewController, title: "Profil", imageName: "person")

        self.sendMoneyNavigationController = sendMoneyNavigationController
        rootViewController.configureAssistantItem(assistantNavigationController.tabBarItem)

        dashboardViewController.onSeeAllTransactions = { [weak self] transactions in
            self?.showAllTransactions(transactions)
        }
        dashboardViewController.onSendMoneyTap = { [weak self] in
            self?.showSendMoneyTab()
        }
        dashboardViewController.onInvestmentTradingTap = { [weak self] in
            self?.showInvestmentTrading()
        }
        dashboardViewController.onInvestmentPortfolioTap = { [weak self] in
            self?.showInvestmentPortfolio()
        }
        dashboardViewController.onAnalysisTap = { [weak self] in
            self?.showExpenseAnalysis()
        }
        sendMoneyViewController.onTransferSucceeded = { [weak self] response in
            self?.showTransferSuccess(response)
        }
        assistantViewModel.onNavigationRequested = { [weak self] target in
            self?.handleAssistantNavigation(target)
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

    private func showExpenseAnalysis() {
        guard let controllers = rootViewController.viewControllers,
              let navigationController = controllers.first as? UINavigationController else { return }

        let viewModel = ExpenseAnalysisViewModel(walletService: walletService)
        let viewController = ExpenseAnalysisViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showInvestmentPortfolio() {
        guard let controllers = rootViewController.viewControllers,
              let navigationController = controllers.first as? UINavigationController else { return }

        let viewModel = InvestmentPortfolioViewModel(walletService: walletService)
        let viewController = InvestmentPortfolioViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onTradeTap = { [weak self] in
            self?.showInvestmentTrading()
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showInvestmentTrading(
        initialAsset: InvestmentTradingAssetType? = nil,
        initialDirection: InvestmentTradeDirection? = nil
    ) {
        guard let controllers = rootViewController.viewControllers,
              let navigationController = controllers.first as? UINavigationController else { return }

        let viewModel = InvestmentTradingViewModel(
            walletService: walletService,
            initialAsset: initialAsset,
            initialDirection: initialDirection
        )
        let viewController = InvestmentTradingViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onReviewTrade = { [weak self] context in
            self?.showInvestmentTradeConfirmation(context)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showInvestmentTradeConfirmation(_ context: InvestmentTradeContext) {
        guard let controllers = rootViewController.viewControllers,
              let navigationController = controllers.first as? UINavigationController else { return }

        let viewModel = InvestmentTradeConfirmationViewModel(walletService: walletService, context: context)
        let viewController = InvestmentTradeConfirmationViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onApproved = { [weak self] successContext in
            self?.showInvestmentTradeSuccess(successContext)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showInvestmentTradeSuccess(_ context: InvestmentTradeSuccessContext) {
        guard let controllers = rootViewController.viewControllers,
              let navigationController = controllers.first as? UINavigationController else { return }

        let viewModel = InvestmentTradeSuccessViewModel(context: context)
        let viewController = InvestmentTradeSuccessViewController(viewModel: viewModel)
        viewController.onClose = { [weak navigationController] in
            navigationController?.popToRootViewController(animated: true)
        }
        viewController.onReturnHome = { [weak self, weak navigationController] in
            navigationController?.popToRootViewController(animated: true)
            self?.rootViewController.selectedIndex = 0
        }
        viewController.onShowHistory = { [weak self] in
            self?.showInvestmentHistory()
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showInvestmentHistory() {
        guard let controllers = rootViewController.viewControllers,
              let navigationController = controllers.first as? UINavigationController else { return }

        let viewModel = InvestmentHistoryViewModel(walletService: walletService)
        let viewController = InvestmentHistoryViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showTransferSuccess(_ response: WalletTransferResponse) {
        guard let sendMoneyNavigationController else { return }

        let viewModel = TransferSuccessViewModel(response: response)
        let viewController = TransferSuccessViewController(viewModel: viewModel)
        viewController.onReturnHome = { [weak self, weak sendMoneyNavigationController] in
            sendMoneyNavigationController?.popToRootViewController(animated: false)
            self?.rootViewController.selectedIndex = 0
        }
        viewController.onViewReceipt = { [weak self] in
            self?.showTransferReceipt(response)
        }
        sendMoneyNavigationController.pushViewController(viewController, animated: true)
    }

    private func showTransferReceipt(_ response: WalletTransferResponse) {
        guard let sendMoneyNavigationController else { return }

        let viewModel = TransferReceiptViewModel(walletService: walletService, response: response)
        let viewController = TransferReceiptViewController(viewModel: viewModel)
        viewController.onReturnHome = { [weak self, weak sendMoneyNavigationController] in
            sendMoneyNavigationController?.popToRootViewController(animated: false)
            self?.rootViewController.selectedIndex = 0
        }
        sendMoneyNavigationController.pushViewController(viewController, animated: true)
    }

    private func handleAssistantNavigation(_ target: AIAssistantNavigationTarget) {
        switch target {
        case .investmentTrading(let asset, let direction):
            rootViewController.selectedIndex = 0
            showInvestmentTrading(initialAsset: asset, initialDirection: direction)
        case .expenseAnalysis:
            rootViewController.selectedIndex = 0
            showExpenseAnalysis()
        case .sendMoney:
            showSendMoneyTab()
        case .investmentPortfolio:
            rootViewController.selectedIndex = 0
            showInvestmentPortfolio()
        case .marketPrices:
            rootViewController.selectedIndex = 1
        }
    }
}
