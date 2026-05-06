import UIKit

class LoginViewController: BaseViewController {
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
        enableInteractivePopGesture()
        bindActions()
        bindViewModel()
        startObservingKeyboard()
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
        contentView.emailField.setEditingDidBeginTarget(self, action: #selector(handleFieldEditingDidBegin(_:)))
        contentView.passwordField.setEditingDidBeginTarget(self, action: #selector(handleFieldEditingDidBegin(_:)))
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
        contentView.loginButton.alpha = isLoading ? 0.85 : 1
        contentView.loginButton.isEnabled = !isLoading
        setCenteredLoading(isLoading, backgroundColor: UIColor.black.withAlphaComponent(0.08))
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

    
    @objc func handleFieldEditingDidBegin(_ sender: UIView) {
        let targetView = sender.nearestSuperview(of: AuthInputFieldView.self) ?? sender
        contentView.scrollToVisible(targetView)
    }

    override func keyboardDidUpdate(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        let bottomInset = height + 24
        contentView.setKeyboardBottomInset(bottomInset)

        if let firstResponder = view.currentFirstResponder {
            let targetView = firstResponder.nearestSuperview(of: AuthInputFieldView.self) ?? firstResponder
            contentView.scrollToVisible(targetView)
        }
    }

    override func keyboardDidHide(duration: TimeInterval, options: UIView.AnimationOptions) {
        contentView.setKeyboardBottomInset(0)
    }
}
