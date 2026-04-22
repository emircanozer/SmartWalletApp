import UIKit

final class UpdateEmailViewController: UIViewController {
    var onBack: (() -> Void)?
    var onVerificationSent: ((UpdateEmailVerificationContext) -> Void)?

    private let viewModel: UpdateEmailViewModel
    private let contentView = UpdateEmailContentView()
    private let backgroundTapGesture = UITapGestureRecognizer()

    init(viewModel: UpdateEmailViewModel) {
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
        contentView.apply(viewModel.makeViewData())
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UpdateEmailViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.cancelButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.sendButton.addTarget(self, action: #selector(handleSendTap), for: .touchUpInside)
        contentView.newEmailField.setEditingChangedTarget(self, action: #selector(handleFormChanged))
        contentView.confirmEmailField.setEditingChangedTarget(self, action: #selector(handleFormChanged))
        contentView.newEmailField.setEditingDidBeginTarget(self, action: #selector(handleNewEmailFocus))
        contentView.confirmEmailField.setEditingDidBeginTarget(self, action: #selector(handleConfirmEmailFocus))
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
            case .formUpdated(let formState):
                self.contentView.applyFormState(formState)
            case .loading:
                self.contentView.setLoading(true)
                self.setCenteredLoading(true)
            case .success(_, let context):
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
                self.onVerificationSent?(context)
            case .failure(let message):
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
                self.showAlert(message: message)
            }
        }
    }

    func configureGesture() {
        backgroundTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        backgroundTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(backgroundTapGesture)
    }

    func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func updateForm() {
        viewModel.updateForm(
            newEmail: contentView.newEmailField.trimmedText,
            confirmEmail: contentView.confirmEmailField.trimmedText
        )
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleSendTap() {
        Task {
            await viewModel.sendVerificationCode(
                newEmail: contentView.newEmailField.trimmedText,
                confirmEmail: contentView.confirmEmailField.trimmedText
            )
        }
    }

    @objc func handleFormChanged() {
        updateForm()
    }

    @objc func handleNewEmailFocus() {
        contentView.scrollToVisible(contentView.newEmailField)
    }

    @objc func handleConfirmEmailFocus() {
        contentView.scrollToVisible(contentView.confirmEmailField)
    }

    @objc func handleBackgroundTap() {
        contentView.dismissKeyboard()
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = max(0, keyboardFrame.height - view.safeAreaInsets.bottom) + 24
        contentView.setKeyboardBottomInset(bottomInset)
    }

    @objc func handleKeyboardWillHide() {
        contentView.setKeyboardBottomInset(0)
    }
}
