import UIKit

final class ResetPasswordViewController: UIViewController {
    var onBack: (() -> Void)?
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
        bindActions()
        bindViewModel()
        configureGesture()
    }
}

private extension ResetPasswordViewController {
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
        contentView.updateButton.isEnabled = !isLoading
        contentView.updateButton.alpha = isLoading ? 0.7 : 1
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
}
