import UIKit

final class ChangePasswordViewController: UIViewController {
    var onBack: (() -> Void)?
    var onForgotPassword: (() -> Void)?
    var onPasswordChanged: (() -> Void)?

    private let viewModel: ChangePasswordViewModel
    private let contentView = ChangePasswordContentView()
    private let backgroundTapGesture = UITapGestureRecognizer()

    init(viewModel: ChangePasswordViewModel) {
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

 extension ChangePasswordViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.updateButton.addTarget(self, action: #selector(handleUpdateTap), for: .touchUpInside)
        contentView.forgotPasswordButton.addTarget(self, action: #selector(handleForgotPasswordTap), for: .touchUpInside)

        [
            contentView.currentPasswordField,
            contentView.newPasswordField,
            contentView.confirmPasswordField
        ].forEach {
            $0.addEditingChangedTarget(self, action: #selector(handleFormChanged))
        }

        contentView.currentPasswordField.addEditingDidBeginTarget(self, action: #selector(handleCurrentPasswordFocus))
        contentView.newPasswordField.addEditingDidBeginTarget(self, action: #selector(handleNewPasswordFocus))
        contentView.confirmPasswordField.addEditingDidBeginTarget(self, action: #selector(handleConfirmPasswordFocus))

        contentView.currentPasswordField.addVisibilityTarget(self, action: #selector(handleCurrentPasswordVisibility))
        contentView.newPasswordField.addVisibilityTarget(self, action: #selector(handleNewPasswordVisibility))
        contentView.confirmPasswordField.addVisibilityTarget(self, action: #selector(handleConfirmPasswordVisibility))
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
            case .success:
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
                self.onPasswordChanged?()
            case .failure(let message):
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
                self.updateForm()
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
            currentPassword: contentView.currentPasswordField.trimmedText,
            newPassword: contentView.newPasswordField.trimmedText,
            confirmPassword: contentView.confirmPasswordField.trimmedText
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

    @objc func handleUpdateTap() {
        Task {
            await viewModel.changePassword(
                currentPassword: contentView.currentPasswordField.trimmedText,
                newPassword: contentView.newPasswordField.trimmedText,
                confirmPassword: contentView.confirmPasswordField.trimmedText
            )
        }
    }

    @objc func handleForgotPasswordTap() {
        onForgotPassword?()
    }

    @objc func handleFormChanged() {
        updateForm()
    }

    @objc func handleCurrentPasswordFocus() {
        contentView.scrollToVisible(contentView.currentPasswordField)
    }

    @objc func handleNewPasswordFocus() {
        contentView.scrollToVisible(contentView.newPasswordField)
    }

    @objc func handleConfirmPasswordFocus() {
        contentView.scrollToVisible(contentView.confirmPasswordField)
    }

    @objc func handleCurrentPasswordVisibility() {
        contentView.currentPasswordField.toggleSecureEntry()
    }

    @objc func handleNewPasswordVisibility() {
        contentView.newPasswordField.toggleSecureEntry()
    }

    @objc func handleConfirmPasswordVisibility() {
        contentView.confirmPasswordField.toggleSecureEntry()
    }

    @objc func handleBackgroundTap() {
        contentView.dismissKeyboard()
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = max(0, keyboardFrame.height - view.safeAreaInsets.bottom) + 24
        contentView.setKeyboardBottomInset(bottomInset)

        if let firstResponder = view.currentFirstResponder {
            let targetView = firstResponder.nearestSuperview(of: ChangePasswordSecureFieldView.self) ?? firstResponder
            contentView.scrollToVisible(targetView)
        }
    }

    @objc func handleKeyboardWillHide() {
        contentView.setKeyboardBottomInset(0)
    }
}
