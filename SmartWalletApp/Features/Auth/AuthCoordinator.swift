import UIKit

class AuthCoordinator: Coordinator {
    var children: [Coordinator] = []
    var onAuthCompleted: (() -> Void)?

    private let navigationController: UINavigationController
    private let authService: AuthService
    private let tokenStore: TokenStore

    init(navigationController: UINavigationController, authService: AuthService, tokenStore: TokenStore) {
        self.navigationController = navigationController
        self.authService = authService
        self.tokenStore = tokenStore
    }
 
    func start() {
        let viewController = WelcomeViewController()
        viewController.onLoginTap = { [weak self] in
            self?.showLogin()
        }
        viewController.onRegisterTap = { [weak self] in
            self?.showRegister()
        }
        navigationController.setViewControllers([viewController], animated: false)
    }

    private func showLogin() {
        let viewModel = LoginViewModel(authService: authService, tokenStore: tokenStore)
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        viewController.onRegister = { [weak self] in
            self?.showRegister()
        }
        viewController.onForgotPassword = { [weak self] in
            self?.showForgotPassword()
        }
        viewController.onAuthenticated = { [weak self] in
            self?.onAuthCompleted?()
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showRegister() {
        let viewModel = RegisterViewModel(authService: authService)
        let viewController = RegisterViewController(viewModel: viewModel)
        viewController.onLogin = { [weak self] in
            self?.routeToLoginFromRegister()
        }
        //viewcontrollerdan(registerdan) içi doldurulan gelen veriyi(context) kordinatöra veriyorum
        viewController.onVerify = { [weak self] context in
            self?.showVerificationCode(context: context)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func routeToLoginFromRegister() {
        if let loginViewController = navigationController.viewControllers.first(where: { $0 is LoginViewController }) {
            navigationController.popToViewController(loginViewController, animated: true)
            return
            
        }

        navigationController.popViewController(animated: false)
        showLogin()
    }

    private func showForgotPassword() {
        let viewModel = ForgotPasswordViewModel(authService: authService)
        let viewController = ForgotPasswordViewController(viewModel: viewModel)
        viewController.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        viewController.onCodeVerificationRequired = { [weak self] email in
            self?.showForgotPasswordCode(email: email)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showForgotPasswordCode(email: String) {
        let viewModel = ForgotPasswordCodeViewModel(email: email, authService: authService)
        let viewController = ForgotPasswordCodeViewController(viewModel: viewModel)
        viewController.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        viewController.onVerified = { [weak self] context in
            self?.showResetPassword(context: context)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showResetPassword(context: PendingPasswordResetContext) {
        let viewModel = ResetPasswordViewModel(context: context, authService: authService)
        let viewController = ResetPasswordViewController(viewModel: viewModel)
        viewController.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        viewController.onResetCompleted = { [weak self] in
            self?.showResetPasswordSuccess()
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showResetPasswordSuccess() {
        let viewModel = ResetPasswordSuccessViewModel()
        let viewController = ResetPasswordSuccessViewController(viewModel: viewModel)
        viewController.onLoginTap = { [weak self] in
            self?.routeToLoginFromForgotPassword()
        }
        viewController.onHomeTap = { [weak self] in
            self?.routeToWelcomeFromForgotPassword()
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func routeToLoginFromForgotPassword() {
        if let loginViewController = navigationController.viewControllers.first(where: { $0 is LoginViewController }) {
            navigationController.popToViewController(loginViewController, animated: true)
            return
        }

        navigationController.popToRootViewController(animated: false)
        showLogin()
    }

    private func routeToWelcomeFromForgotPassword() {
        navigationController.popToRootViewController(animated: true)
    }

    //registerin verdiği veriyi alıyor parametre olarak diğer ekrana(viewmodele) taşıyor
    private func showVerificationCode(context: PendingRegistrationContext) {
        let viewModel = VerificationCodeViewModel(context: context, authService: authService, tokenStore: tokenStore)
        let viewController = VerificationCodeViewController(viewModel: viewModel)
        viewController.onBackToLogin = { [weak self] in
            self?.routeToLoginFromVerification()
        }
        viewController.onVerify = { [weak self] verifiedContext in
            self?.showIbanCreated(context: verifiedContext)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func routeToLoginFromVerification() {
        if let loginViewController = navigationController.viewControllers.first(where: { $0 is LoginViewController }) {
            navigationController.popToViewController(loginViewController, animated: true)
            return
        }

        navigationController.popToRootViewController(animated: false)
        showLogin()
    }

    private func showIbanCreated(context: PendingRegistrationContext) { 
        let viewController = IbanCreatedViewController(ibanValueText: context.registration.iban)
        viewController.onContinue = { [weak self, weak viewController] in
            viewController?.dismiss(animated: true) {
                print("DEBUG Auth: auth akisi tamamlandi, home flow'a geciliyor.")
                self?.onAuthCompleted?()
            }
        }
        viewController.modalPresentationStyle = .pageSheet

        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 28
        }

        navigationController.present(viewController, animated: true)
    }
}
