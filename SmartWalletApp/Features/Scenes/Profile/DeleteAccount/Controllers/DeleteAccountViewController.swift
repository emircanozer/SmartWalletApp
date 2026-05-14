import UIKit

final class DeleteAccountViewController: BaseViewController {
    var onBack: (() -> Void)?
    var onDeleted: (() -> Void)?

    private let viewModel: DeleteAccountViewModel
    private let contentView = DeleteAccountContentView()
    private var isConfirmationChecked = false

    init(viewModel: DeleteAccountViewModel) {
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
        bindActions()
        bindViewModel()
        installKeyboardDismissTap()
        startObservingKeyboard()
        contentView.apply(viewModel.makeViewData())
        enableInteractivePopGesture()
    }
}

extension DeleteAccountViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.cancelButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.checkboxButton.addTarget(self, action: #selector(handleCheckboxTap), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(handleDeleteTap), for: .touchUpInside)
        contentView.passwordField.setEditingChangedTarget(self, action: #selector(handleFormChanged))
        contentView.passwordField.setTrailingTarget(self, action: #selector(handlePasswordVisibilityTap))
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.setCenteredLoading(false)
            case .loading:
                self.setCenteredLoading(true)
            case .deleted(let message):
                self.setCenteredLoading(false)
                self.showDeletedAlert(message: message)
            case .failure(let message):
                self.setCenteredLoading(false)
                self.showAlert(message: message)
            }
        }
    }

    func updateFormState() {
        let isEnabled = isConfirmationChecked && !contentView.passwordField.trimmedText.isEmpty
        contentView.updateDeleteButton(isEnabled: isEnabled)
    }

    func showDeletedAlert(message: String) {
        showAlert(message: message) { [weak self] in
            self?.onDeleted?()
        }
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleCheckboxTap() {
        isConfirmationChecked.toggle()
        contentView.setConfirmationChecked(isConfirmationChecked)
        updateFormState()
    }

    @objc func handleFormChanged() {
        updateFormState()
    }

    @objc func handlePasswordVisibilityTap() {
        contentView.passwordField.toggleSecureEntry()
    }

    @objc func handleDeleteTap() {
        Task {
            await viewModel.deleteAccount(password: contentView.passwordField.text)
        }
    }

    override func keyboardDidUpdate(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        let bottomInset = height + 24
        contentView.setKeyboardBottomInset(bottomInset)
        contentView.scrollToVisible(contentView.passwordField)
    }

    override func keyboardDidHide(duration: TimeInterval, options: UIView.AnimationOptions) {
        contentView.setKeyboardBottomInset(0)
    }
}
