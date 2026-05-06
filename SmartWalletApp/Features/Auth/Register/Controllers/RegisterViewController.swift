import UIKit

class RegisterViewController: BaseViewController {
    var onLogin: (() -> Void)?
    var onVerify: ((PendingRegistrationContext) -> Void)?

    private let viewModel: RegisterViewModel
    private let contentView = RegisterContentView()
    private var isTermsAccepted = false

    init(viewModel: RegisterViewModel) {
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
        enableInteractivePopGesture()
        bindActions()
        bindViewModel()
        updateCheckboxAppearance()
        startObservingKeyboard()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.applyCornerRadius()
    }
}

extension RegisterViewController {
    func bindActions() {
        contentView.checkboxButton.addTarget(self, action: #selector(handleCheckboxTap), for: .touchUpInside)
        contentView.loginButton.addTarget(self, action: #selector(handleLoginTap), for: .touchUpInside)
        contentView.registerButton.addTarget(self, action: #selector(handleRegisterTap), for: .touchUpInside)
        contentView.passwordField.setTrailingTarget(self, action: #selector(handlePasswordVisibilityTap))
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            switch state {
            case .idle:
                self.setLoading(false)
            case .loading:
                self.setLoading(true)
            case .verificationRequired(let context):
                self.setLoading(false)
                self.onVerify?(context)
            case .failure(let message):
                self.setLoading(false)
                self.showAlert(message: message)
            }
        }
    }

    func setLoading(_ isLoading: Bool) {
        contentView.registerButton.alpha = isLoading ? 0.85 : 1
        contentView.registerButton.isEnabled = !isLoading
        setCenteredLoading(isLoading)
    }

    func updateCheckboxAppearance() {
        let imageName = isTermsAccepted ? "checkmark" : nil
        contentView.checkboxButton.setImage(imageName == nil ? nil : UIImage(systemName: imageName!), for: .normal)
    }

    @objc func handleCheckboxTap() {
        isTermsAccepted.toggle()
        updateCheckboxAppearance()
    }

    @objc func handleLoginTap() {
        onLogin?()
    }

    @objc func handleRegisterTap() {
        Task {
            await viewModel.register(
                name: contentView.fullNameField.trimmedText,
                email: contentView.emailField.trimmedText,
                password: contentView.passwordField.text,
                confirmPassword: contentView.confirmPasswordField.text,
                isTermsAccepted: isTermsAccepted
            )
        }
    }

    @objc func handlePasswordVisibilityTap() {
        contentView.passwordField.toggleSecureEntry()
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
