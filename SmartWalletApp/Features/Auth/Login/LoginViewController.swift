import UIKit

class LoginViewController: UIViewController {
    var onBack: (() -> Void)?
    var onRegister: (() -> Void)?
    var onForgotPassword: (() -> Void)?
    var onAuthenticated: (() -> Void)?

    private let viewModel: LoginViewModel
    private let contentView = LoginContentView()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        bindActions()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.applyCornerRadius()
    }
}

extension LoginViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.loginButton.addTarget(self, action: #selector(handleLoginTap), for: .touchUpInside)
        contentView.registerButton.addTarget(self, action: #selector(handleRegisterTap), for: .touchUpInside)
        contentView.passwordField.setTrailingTarget(self, action: #selector(handlePasswordVisibilityTap))
        contentView.passwordField.setTopActionTarget(self, action: #selector(handleForgotPasswordTap))
    }

    func bindViewModel() {
        // enum tanımlamalarına göre state değişince yapılacaklar 
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            switch state {
            case .idle:
                self.setLoading(false)
            case .loading:
                self.setLoading(true)
            case .success:
                self.setLoading(false)
                self.onAuthenticated?()
            case .failure(let message):
                self.setLoading(false)
                self.showAlert(message: message)
            }
        }
    }

    func setLoading(_ isLoading: Bool) {
        contentView.loginButton.isEnabled = !isLoading
        contentView.loginButton.alpha = isLoading ? 0.7 : 1
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleLoginTap() {
        Task { // async olmayan ortamda net kullanılır async fonk kullanımı için
            await viewModel.login(
                email: contentView.emailField.trimmedText,
                password: contentView.passwordField.text
            )
        }
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
