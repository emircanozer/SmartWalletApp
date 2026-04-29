import UIKit

class HomeCoordinator: Coordinator {
    var children: [Coordinator] = []
    var onLogoutRequested: (() -> Void)?

    let rootViewController = MainTabBarController()

    private let walletService: WalletService
    private let assistantService: AssistantService
    private let authService: AuthService
    private let tokenStore: TokenStore
    private weak var sendMoneyNavigationController: UINavigationController?

    init(walletService: WalletService, assistantService: AssistantService, authService: AuthService, tokenStore: TokenStore) {
        self.walletService = walletService
        self.assistantService = assistantService
        self.authService = authService
        self.tokenStore = tokenStore
    }

    func start() {
        let dashboardViewModel = DashboardViewModel(walletService: walletService)
        let dashboardViewController = DashboardViewController(viewModel: dashboardViewModel)
        let sendMoneyViewController = makeSendMoneyViewController(
            presentationStyle: .tabRoot,
            navigationController: nil
        )
        let marketPricesViewModel = MarketPricesViewModel(walletService: walletService)
        let marketPricesViewController = MarketPricesViewController(viewModel: marketPricesViewModel)
        let assistantViewModel = AIAssistantViewModel(assistantService: assistantService)
        let assistantViewController = AIAssistantViewController(viewModel: assistantViewModel)
        let profileViewModel = ProfileViewModel(
            authService: authService,
            tokenStore: tokenStore,
            isDarkModeEnabled: ThemePreferenceStore.shared.isDarkModeEnabled
        )
        let profileViewController = ProfileViewController(viewModel: profileViewModel)

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
        dashboardViewController.onSendMoneyTap = { [weak self, weak dashboardNavigationController] in
            guard let self, let dashboardNavigationController else { return }
            self.showSendMoney(in: dashboardNavigationController, presentationStyle: .pushedFromDashboard)
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
        marketPricesViewController.onTradeTap = { [weak self, weak walletNavigationController] in
            guard let self, let walletNavigationController else { return }
            self.showInvestmentTrading(in: walletNavigationController)
        }
        assistantViewModel.onNavigationRequested = { [weak self] target in
            self?.handleAssistantNavigation(target)
        }
        profileViewController.onActionSelected = { [weak self] action in
            self?.handleProfileAction(action)
        }
        profileViewController.onEmailSelected = { [weak self] email in
            self?.showUpdateEmail(currentEmail: email)
        }
        profileViewController.onLogout = { [weak self] in
            self?.onLogoutRequested?()
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

    private func showSendMoney(
        in navigationController: UINavigationController,
        presentationStyle: SendMoneyPresentationStyle
    ) {
        let viewController = makeSendMoneyViewController(
            presentationStyle: presentationStyle,
            navigationController: navigationController
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    private func makeSendMoneyViewController(
        presentationStyle: SendMoneyPresentationStyle,
        navigationController: UINavigationController?
    ) -> SendMoneyViewController {
        let sendMoneyViewModel = SendMoneyViewModel(walletService: walletService)
        let sendMoneyViewController = SendMoneyViewController(
            viewModel: sendMoneyViewModel,
            presentationStyle: presentationStyle
        )
        sendMoneyViewController.onTransferSucceeded = { [weak self, weak navigationController] response in
            let targetNavigationController = navigationController ?? self?.sendMoneyNavigationController
            self?.showTransferSuccess(response, in: targetNavigationController)
        }
        return sendMoneyViewController
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

    private func showInvestmentTrading(
        in navigationController: UINavigationController,
        initialAsset: InvestmentTradingAssetType? = nil,
        initialDirection: InvestmentTradeDirection? = nil
    ) {
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
        guard let navigationController = rootViewController.selectedViewController as? UINavigationController else { return }

        let viewModel = InvestmentHistoryViewModel(walletService: walletService)
        let viewController = InvestmentHistoryViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showTransferSuccess(
        _ response: WalletTransferResponse,
        in navigationController: UINavigationController?
    ) {
        guard let navigationController else { return }

        let viewModel = TransferSuccessViewModel(response: response)
        let viewController = TransferSuccessViewController(viewModel: viewModel)
        viewController.onReturnHome = { [weak self, weak navigationController] in
            navigationController?.popToRootViewController(animated: false)
            self?.rootViewController.selectedIndex = 0
        }
        viewController.onViewReceipt = { [weak self, weak navigationController] in
            self?.showTransferReceipt(response, in: navigationController)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showTransferReceipt(
        _ response: WalletTransferResponse,
        in navigationController: UINavigationController?
    ) {
        guard let navigationController else { return }

        let viewModel = TransferReceiptViewModel(walletService: walletService, response: response)
        let viewController = TransferReceiptViewController(viewModel: viewModel)
        viewController.onReturnHome = { [weak self, weak navigationController] in
            navigationController?.popToRootViewController(animated: false)
            self?.rootViewController.selectedIndex = 0
        }
        navigationController.pushViewController(viewController, animated: true)
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

    private func handleProfileAction(_ action: ProfileRowAction) {
        if action == .deleteAccount {
            showDeleteAccount()
            return
        }

        if action == .contactUs {
            showContactUs()
            return
        }

        if action == .changePassword {
            showChangePassword()
            return
        }

        if action == .transferReceipts {
            showTransferReceipts()
            return
        }

        if action == .tradeHistory {
            showInvestmentHistory()
            return
        }

        if action == .privacy {
            showPrivacy()
            return
        }

        let alert = UIAlertController(
            title: "Bilgi",
            message: "Bu alanın detay akışını sonraki adımda bağlayacağız.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        rootViewController.present(alert, animated: true)
    }

    private func showPrivacy() {
        guard let navigationController = rootViewController.selectedViewController as? UINavigationController else { return }

        let viewModel = PrivacyViewModel()
        let viewController = PrivacyViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showDeleteAccount() {
        guard let navigationController = rootViewController.selectedViewController as? UINavigationController else { return }

        let viewModel = DeleteAccountViewModel(authService: authService, tokenStore: tokenStore)
        let viewController = DeleteAccountViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onDeleted = { [weak self] in
            self?.onLogoutRequested?()
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showContactUs() {
        guard let navigationController = rootViewController.selectedViewController as? UINavigationController else { return }

        let viewController = makeContactUsViewController(in: navigationController)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func makeContactUsViewController(in navigationController: UINavigationController) -> ContactUsViewController {
        let viewModel = ContactUsViewModel()
        let viewController = ContactUsViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onMailSent = { [weak self, weak navigationController] in
            guard let navigationController else { return }
            self?.showContactUsSuccess(in: navigationController)
        }
        return viewController
    }

    private func showContactUsSuccess(in navigationController: UINavigationController) {
        let viewModel = ContactUsSuccessViewModel()
        let viewController = ContactUsSuccessViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onReturnHome = { [weak self, weak navigationController] in
            navigationController?.popToRootViewController(animated: false)
            self?.rootViewController.selectedIndex = 0
        }
        viewController.onCreateNewMessage = { [weak self, weak navigationController] in
            guard let self, let navigationController else { return }
            var stack = navigationController.viewControllers
            if stack.last is ContactUsSuccessViewController {
                stack.removeLast()
            }
            if stack.last is ContactUsViewController {
                stack.removeLast()
            }
            stack.append(self.makeContactUsViewController(in: navigationController))
            navigationController.setViewControllers(stack, animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showChangePassword() {
        guard let navigationController = rootViewController.selectedViewController as? UINavigationController else { return }

        let viewModel = ChangePasswordViewModel(authService: authService)
        let viewController = ChangePasswordViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onForgotPassword = { [weak self, weak navigationController] in
            guard let navigationController else { return }
            self?.showForgotPassword(in: navigationController)
        }
        viewController.onPasswordChanged = { [weak self, weak navigationController] in
            guard let navigationController else { return }
            self?.showChangePasswordSuccess(in: navigationController)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showTransferReceipts() {
        guard let navigationController = rootViewController.selectedViewController as? UINavigationController else { return }

        let viewModel = TransferReceiptsViewModel(walletService: walletService)
        let viewController = TransferReceiptsViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onReceiptDetailSelected = { [weak self, weak navigationController] transactionId in
            guard let navigationController else { return }
            self?.showTransferReceiptDetail(transactionId: transactionId, in: navigationController)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showTransferReceiptDetail(transactionId: String, in navigationController: UINavigationController) {
        let viewModel = TransferReceiptDetailViewModel(walletService: walletService, transactionId: transactionId)
        let viewController = TransferReceiptDetailViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onReturnHome = { [weak self, weak navigationController] in
            navigationController?.popToRootViewController(animated: false)
            self?.rootViewController.selectedIndex = 0
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showUpdateEmail(currentEmail: String) {
        guard let navigationController = rootViewController.selectedViewController as? UINavigationController else { return }

        let viewModel = UpdateEmailViewModel(currentEmail: currentEmail, authService: authService)
        let viewController = UpdateEmailViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onVerificationSent = { [weak self, weak navigationController] context in
            guard let navigationController else { return }
            self?.showUpdateEmailCode(context: context, in: navigationController)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showUpdateEmailCode(context: UpdateEmailVerificationContext, in navigationController: UINavigationController) {
        let viewModel = UpdateEmailCodeViewModel(context: context, authService: authService)
        let viewController = UpdateEmailCodeViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onVerified = { [weak self, weak navigationController] in
            guard let navigationController else { return }
            self?.showUpdateEmailSuccess(in: navigationController)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showUpdateEmailSuccess(in navigationController: UINavigationController) {
        let viewModel = UpdateEmailSuccessViewModel()
        let viewController = UpdateEmailSuccessViewController(viewModel: viewModel)
        viewController.onReturnHome = { [weak self, weak navigationController] in
            navigationController?.popToRootViewController(animated: false)
            self?.rootViewController.selectedIndex = 0
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showChangePasswordSuccess(in navigationController: UINavigationController) {
        let viewModel = ChangePasswordSuccessViewModel()
        let viewController = ChangePasswordSuccessViewController(viewModel: viewModel)
        viewController.onReturnHome = { [weak self, weak navigationController] in
            navigationController?.popToRootViewController(animated: false)
            self?.rootViewController.selectedIndex = 0
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showForgotPassword(in navigationController: UINavigationController) {
        let viewModel = ForgotPasswordViewModel(authService: authService)
        let viewController = ForgotPasswordViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onCodeVerificationRequired = { [weak self, weak navigationController] email in
            guard let navigationController else { return }
            self?.showForgotPasswordCode(email: email, in: navigationController)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showForgotPasswordCode(email: String, in navigationController: UINavigationController) {
        let viewModel = ForgotPasswordCodeViewModel(email: email, authService: authService)
        let viewController = ForgotPasswordCodeViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onVerified = { [weak self, weak navigationController] context in
            guard let navigationController else { return }
            self?.showResetPassword(context: context, in: navigationController)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showResetPassword(context: PendingPasswordResetContext, in navigationController: UINavigationController) {
        let viewModel = ResetPasswordViewModel(context: context, authService: authService)
        let viewController = ResetPasswordViewController(viewModel: viewModel)
        viewController.onBack = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        viewController.onResetCompleted = { [weak self, weak navigationController] in
            guard let navigationController else { return }
            self?.showResetPasswordSuccess(in: navigationController)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showResetPasswordSuccess(in navigationController: UINavigationController) {
        let viewModel = ResetPasswordSuccessViewModel()
        let viewController = ResetPasswordSuccessViewController(viewModel: viewModel)
        viewController.onLoginTap = { [weak self] in
            self?.onLogoutRequested?()
        }
        viewController.onHomeTap = { [weak self, weak navigationController] in
            navigationController?.popToRootViewController(animated: false)
            self?.rootViewController.selectedIndex = 0
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}
