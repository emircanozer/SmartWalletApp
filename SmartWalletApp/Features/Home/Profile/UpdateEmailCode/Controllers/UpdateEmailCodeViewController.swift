import UIKit

final class UpdateEmailCodeViewController: UIViewController {
    var onBack: (() -> Void)?
    var onVerified: (() -> Void)?

    private let viewModel: UpdateEmailCodeViewModel
    private let contentView = UpdateEmailCodeContentView()

    init(viewModel: UpdateEmailCodeViewModel) {
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
        observeKeyboard()
        contentView.apply(viewModel.makeViewData())
        updateVerifyButtonState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.codeInputView.focus()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

 extension UpdateEmailCodeViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.verifyButton.addTarget(self, action: #selector(handleVerifyTap), for: .touchUpInside)
        contentView.resendButton.addTarget(self, action: #selector(handleResendTap), for: .touchUpInside)
        contentView.backgroundTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        contentView.codeInputView.onCodeChange = { [weak self] _ in
            self?.updateVerifyButtonState()
        }
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
                self.onVerified?()
            case .resendSuccess(let message):
                self.setLoading(false)
                self.contentView.codeInputView.clear()
                self.contentView.codeInputView.focus()
                self.showAlert(message: message)
            case .failure(let message):
                self.setLoading(false)
                self.showAlert(message: message)
            }
        }
    }

    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setLoading(_ isLoading: Bool) {
        contentView.setLoading(isLoading)
        setCenteredLoading(isLoading)
        if !isLoading {
            updateVerifyButtonState()
        }
    }

    func updateVerifyButtonState() {
        contentView.setVerifyEnabled(contentView.codeInputView.code.count == 6)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleVerifyTap() {
        Task {
            await viewModel.verify(code: contentView.codeInputView.code)
        }
    }

    @objc func handleResendTap() {
        Task {
            await viewModel.resendCode()
        }
    }

    @objc func handleBackgroundTap() {
        view.endEditing(true)
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
