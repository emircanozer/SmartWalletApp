import UIKit

class LoginViewController: UIViewController {
    var onBack: (() -> Void)?
    var onRegister: (() -> Void)?
    var onForgotPassword: (() -> Void)?

    private let contentView = LoginContentView()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        bindActions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.applyCornerRadius()
    }
}

extension LoginViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.registerButton.addTarget(self, action: #selector(handleRegisterTap), for: .touchUpInside)
        contentView.passwordField.setTrailingTarget(self, action: #selector(handlePasswordVisibilityTap))
        contentView.passwordField.setTopActionTarget(self, action: #selector(handleForgotPasswordTap))
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleRegisterTap() {
        onRegister?()
    }

    @objc func handlePasswordVisibilityTap() {
        contentView.passwordField.toggleSecureEntry()
    }

    @objc func handleForgotPasswordTap() {
        onForgotPassword?()
    }
}
