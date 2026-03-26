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
        viewController.onLoginTap = { [weak self] in
            self?.showLogin()
        }
        viewController.onRegisterTap = { [weak self] in
            self?.showRegister()
        }
        navigationController.setViewControllers([viewController], animated: false)
        // push yerine set kullanmamızın sebebi stack yığınını sıfırlamak istiyoruz yani kullanıcıya geri dönüş butonu çıkmasın geri dönemesin set kullanılan ekranlar genelde ilk açılan ekranlar olur

    }

    private func showLogin() {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
            // on back propunun içini pop yani geri dön ile doldurduk diğer sayfanın içinde ise handle tap fonkunda kullandık 
        }
        viewController.onRegister = { [weak self] in
            self?.showRegister()
        }
        viewController.onForgotPassword = { [weak self] in
            self?.showResetPassword()
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showRegister() {
        let viewModel = RegisterViewModel()
        let viewController = RegisterViewController(viewModel: viewModel)
        viewController.onLogin = { [weak self] in
            self?.routeToLoginFromRegister()
        }
        viewController.onVerify = { [weak self] in
            self?.showVerificationCode()
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

    private func showResetPassword() {
        let viewModel = ResetPasswordViewModel()
        let viewController = ResetPasswordViewController(viewModel: viewModel)
        viewController.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showVerificationCode() {
        let viewModel = VerificationCodeViewModel()
        let viewController = VerificationCodeViewController(viewModel: viewModel)
        viewController.onBackToLogin = { [weak self] in
            self?.routeToLoginFromVerification()
        }
        viewController.onVerify = { [weak self] in
            self?.showAccountCreated()
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

    private func showAccountCreated() {
        let viewModel = AccountCreatedViewModel()
        let viewController = AccountCreatedViewController(viewModel: viewModel)
        viewController.onContinue = { [weak viewController] in
            viewController?.dismiss(animated: true)
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
