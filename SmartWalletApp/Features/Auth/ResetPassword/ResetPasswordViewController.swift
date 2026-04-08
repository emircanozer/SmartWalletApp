import UIKit

final class ResetPasswordViewController: UIViewController {
    var onBack: (() -> Void)?
    // şifre sıfırlama başarılı olursa dışarı haber verebilirim
    var onResetCompleted: (() -> Void)?

    private let viewModel: ResetPasswordViewModel
    private let contentView = ResetPasswordContentView()
    private let backgroundTapGesture = UITapGestureRecognizer()

    init(viewModel: ResetPasswordViewModel) {
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
        configureGesture()
        observeKeyboard()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

 extension ResetPasswordViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.updateButton.addTarget(self, action: #selector(handleUpdateTap), for: .touchUpInside)
        contentView.passwordField.setTrailingTarget(self, action: #selector(handlePasswordVisibility))
        contentView.confirmPasswordField.setTrailingTarget(self, action: #selector(handleConfirmPasswordVisibility))
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.setLoading(false)
            case .loading:
                self.setLoading(true)
            case .success:
                
                self.setLoading(false)
                self.onResetCompleted?()
            case .failure(let message):
                self.setLoading(false)
                self.showAlert(message: message)
            }
        }
    }

    func configureGesture() {
        backgroundTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        backgroundTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(backgroundTapGesture)
    }

    func setLoading(_ isLoading: Bool) {
        contentView.updateButton.alpha = isLoading ? 0.85 : 1
        contentView.updateButton.isEnabled = !isLoading
        setCenteredLoading(isLoading)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleUpdateTap() {
        Task {
            await viewModel.resetPassword(
                newPassword: contentView.passwordField.trimmedText,
                confirmPassword: contentView.confirmPasswordField.trimmedText
            )
        }
    }

    @objc func handlePasswordVisibility() {
        contentView.passwordField.toggleSecureEntry()
    }

    @objc func handleConfirmPasswordVisibility() {
        contentView.confirmPasswordField.toggleSecureEntry()
    }

    @objc func handleBackgroundTap() {
        contentView.dismissKeyboard()
    }

    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = max(0, keyboardFrame.height - view.safeAreaInsets.bottom) + 24
        contentView.setKeyboardBottomInset(bottomInset)

        if let firstResponder = view.currentFirstResponder {
            let targetView = firstResponder.nearestSuperview(of: AuthInputFieldView.self) ?? firstResponder
            contentView.scrollToVisible(targetView)
        }
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        contentView.setKeyboardBottomInset(0)
    }
}
