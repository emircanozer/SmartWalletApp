import UIKit

final class ForgotPasswordCodeViewController: UIViewController {
    var onBack: (() -> Void)?
    var onVerified: ((String) -> Void)?

    private let viewModel: ForgotPasswordCodeViewModel
    private let contentView = ForgotPasswordCodeContentView()

    init(viewModel: ForgotPasswordCodeViewModel) {
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
        observeKeyboard()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.codeInputView.focus()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension ForgotPasswordCodeViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.verifyButton.addTarget(self, action: #selector(handleVerifyTap), for: .touchUpInside)
        contentView.resendButton.addTarget(self, action: #selector(handleResendTap), for: .touchUpInside)
        contentView.codeInputView.onCodeChange = { [weak self] _ in
            self?.updateVerifyButtonState()
        }
        updateVerifyButtonState()
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.setLoading(false)
            case .loading:
                self.setLoading(true)
            case .success(let message):
                self.setLoading(false)
                self.onVerified?(self.viewModel.email)
                self.showAlert(message: message)
            case .resendSuccess(let message):
                self.setLoading(false)
                self.contentView.codeInputView.clear()
                self.contentView.codeInputView.focus()
                self.updateVerifyButtonState()
                self.showAlert(message: message)
            case .failure(let message):
                self.setLoading(false)
                self.showAlert(message: message)
            }
        }
    }

    func setLoading(_ isLoading: Bool) {
        contentView.verifyButton.isEnabled = !isLoading
        contentView.verifyButton.alpha = isLoading ? 0.7 : 1
        contentView.resendButton.isEnabled = !isLoading
        contentView.resendButton.alpha = isLoading ? 0.7 : 1
    }

    func updateVerifyButtonState() {
        let enabled = contentView.codeInputView.code.count == 6
        contentView.verifyButton.isEnabled = enabled
        contentView.verifyButton.alpha = enabled ? 1 : 0.65
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleVerifyTap() {
        guard contentView.codeInputView.code.count == 6 else { return }
        Task {
            await viewModel.verify(code: contentView.codeInputView.code)
        }
    }

    @objc func handleResendTap() {
        Task {
            await viewModel.resendCode()
        }
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.height
        let translation = min((keyboardHeight * 0.28), 90)

        UIView.animate(withDuration: duration) {
            self.contentView.moveForKeyboard(y: -translation)
        }
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        UIView.animate(withDuration: duration) {
            self.contentView.moveForKeyboard(y: 0)
        }
    }
}
