import UIKit

final class DeleteAccountViewController: UIViewController {
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
        registerKeyboardObservers()
        contentView.apply(viewModel.makeViewData())
        enableInteractivePopGesture()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DeleteAccountViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.cancelButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.checkboxButton.addTarget(self, action: #selector(handleCheckboxTap), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(handleDeleteTap), for: .touchUpInside)
        contentView.passwordField.setEditingChangedTarget(self, action: #selector(handleFormChanged))
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

    func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func updateFormState() {
        let isEnabled = isConfirmationChecked && !contentView.passwordField.trimmedText.isEmpty
        contentView.updateDeleteButton(isEnabled: isEnabled)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    func showDeletedAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.onDeleted?()
        })
        present(alert, animated: true)
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

    @objc func handleDeleteTap() {
        Task {
            await viewModel.deleteAccount(password: contentView.passwordField.text)
        }
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = max(0, keyboardFrame.height - view.safeAreaInsets.bottom) + 24
        contentView.setKeyboardBottomInset(bottomInset)
        contentView.scrollToVisible(contentView.passwordField)
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        contentView.setKeyboardBottomInset(0)
    }
}
