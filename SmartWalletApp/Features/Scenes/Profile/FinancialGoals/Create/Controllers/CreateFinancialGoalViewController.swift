import UIKit

final class CreateFinancialGoalViewController: BaseViewController {
    var onBack: (() -> Void)?

    private let viewModel: CreateFinancialGoalViewModel
    private let contentView = CreateFinancialGoalContentView()
    private let datePicker = UIDatePicker()
    private let hiddenDateTextField = UITextField()

    init(viewModel: CreateFinancialGoalViewModel) {
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
        configureKeyboardHandling()
        configureDatePicker()
        contentView.apply(viewModel.makeViewData())
        viewModel.updateTitle("")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CreateFinancialGoalViewController {
    private func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.approveButton.addTarget(self, action: #selector(handleApproveTap), for: .touchUpInside)
        contentView.nameField.setEditingChangedTarget(self, action: #selector(handleNameChanged))
        contentView.amountField.setEditingChangedTarget(self, action: #selector(handleAmountChanged))
        contentView.nameField.setEditingDidBeginTarget(self, action: #selector(handleNameFocus))
        contentView.amountField.setEditingDidBeginTarget(self, action: #selector(handleAmountFocus))
        contentView.onDateTap = { [weak self] in
            self?.dismissKeyboard()
            self?.hiddenDateTextField.becomeFirstResponder()
        }
        installKeyboardDismissTap()
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] formState in
            self?.contentView.applyFormState(formState)
        }
    }

    private func configureKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func configureDatePicker() {
        view.addSubview(hiddenDateTextField)
        hiddenDateTextField.translatesAutoresizingMaskIntoConstraints = false
        hiddenDateTextField.isHidden = true

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "tr_TR")
        datePicker.minimumDate = Date()
        hiddenDateTextField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Tamam", style: .done, target: self, action: #selector(handleDateDoneTap))
        ]
        hiddenDateTextField.inputAccessoryView = toolbar
    }

    @objc private func handleBackTap() {
        onBack?()
    }

    @objc private func handleApproveTap() {
        dismissKeyboard()
        Task { [weak self] in
            guard let self else { return }
            if let message = await viewModel.submit() {
                showAlert(message: message)
                return
            }
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func handleNameChanged() {
        viewModel.updateTitle(contentView.nameField.trimmedText)
    }

    @objc private func handleAmountChanged() {
        viewModel.updateAmount(contentView.amountField.text)
    }

    @objc private func handleNameFocus() {
        contentView.scrollToVisible(contentView.nameField)
    }

    @objc private func handleAmountFocus() {
        contentView.scrollToVisible(contentView.amountField)
    }

    @objc private func handleDateDoneTap() {
        viewModel.updateDate(datePicker.date)
        hiddenDateTextField.resignFirstResponder()
    }

    @objc private func handleKeyboardWillChangeFrame(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let overlap = max(view.bounds.maxY - keyboardFrameInView.minY, 0)
        contentView.setKeyboardBottomInset(overlap + 20)
    }

    @objc private func handleKeyboardWillHide() {
        contentView.setKeyboardBottomInset(0)
    }
}
