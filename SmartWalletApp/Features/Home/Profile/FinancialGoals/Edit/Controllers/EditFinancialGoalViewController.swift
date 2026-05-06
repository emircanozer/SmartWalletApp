import UIKit

final class EditFinancialGoalViewController: BaseViewController, UITextViewDelegate {
    var onBack: (() -> Void)?
    var onSaved: ((FinancialGoalRecord) -> Void)?
    var onDeleted: ((UUID) -> Void)?

    private let viewModel: EditFinancialGoalViewModel
    private let contentView = EditFinancialGoalContentView()
    private let datePicker = UIDatePicker()
    private let hiddenDateTextField = UITextField()

    init(viewModel: EditFinancialGoalViewModel) {
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
        contentView.setInitialValues(
            name: viewModel.initialTitleText,
            amount: viewModel.initialAmountText,
            note: viewModel.initialNoteText
        )
        viewModel.load()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension EditFinancialGoalViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(handleSaveTap), for: .touchUpInside)
        contentView.cancelButton.addTarget(self, action: #selector(handleCancelTap), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(handleDeleteTap), for: .touchUpInside)
        contentView.nameField.setEditingDidBeginTarget(self, action: #selector(handleFieldFocus))
        contentView.amountField.setEditingDidBeginTarget(self, action: #selector(handleFieldFocus))
        contentView.nameField.setEditingChangedTarget(self, action: #selector(handleNameChanged))
        contentView.amountField.setEditingChangedTarget(self, action: #selector(handleAmountChanged))
        contentView.noteTextView.delegate = self
        contentView.onDateTap = { [weak self] in
            self?.dismissKeyboard()
            self?.hiddenDateTextField.becomeFirstResponder()
        }
        installKeyboardDismissTap()
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.contentView.applyFormState(state)
        }
    }

    func configureKeyboardHandling() {
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

    func configureDatePicker() {
        view.addSubview(hiddenDateTextField)
        hiddenDateTextField.translatesAutoresizingMaskIntoConstraints = false
        hiddenDateTextField.isHidden = true

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.date = max(viewModel.initialDate, Date())
        hiddenDateTextField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Tamam", style: .done, target: self, action: #selector(handleDateDoneTap))
        ]
        hiddenDateTextField.inputAccessoryView = toolbar
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleSaveTap() {
        dismissKeyboard()
        Task { [weak self] in
            guard let self else { return }
            let result = await viewModel.submit()
            if let updatedGoal = result.goal {
                onSaved?(updatedGoal)
                navigationController?.popViewController(animated: true)
            } else if let message = result.errorMessage {
                showAlert(message: message)
            }
        }
    }

    @objc func handleCancelTap() {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleDeleteTap() {
        dismissKeyboard()
        Task { [weak self] in
            guard let self else { return }
            if let message = await viewModel.closeGoal() {
                showAlert(message: message)
                return
            }
            onDeleted?(viewModel.saveGoalID)
        }
    }

    @objc func handleNameChanged() {
        viewModel.updateTitle(contentView.nameField.trimmedText)
    }

    @objc func handleAmountChanged() {
        viewModel.updateAmount(contentView.amountField.text)
    }

    @objc func handleDateDoneTap() {
        viewModel.updateDate(datePicker.date)
        hiddenDateTextField.resignFirstResponder()
    }

    @objc func handleFieldFocus(_ sender: UIView) {
        contentView.scrollToVisible(sender)
    }

    @objc func handleKeyboardWillChangeFrame(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let overlap = max(view.bounds.maxY - keyboardFrameInView.minY, 0)
        contentView.setKeyboardBottomInset(overlap + 20)
    }

    @objc func handleKeyboardWillHide() {
        contentView.setKeyboardBottomInset(0)
    }
}

extension EditFinancialGoalViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == AppColor.placeholderText {
            textView.text = ""
            textView.textColor = AppColor.inputText
        }
        contentView.scrollToVisible(textView)
    }

    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateNote(textView.text)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        textView.text = "Istege bagli aciklama"
        textView.textColor = AppColor.placeholderText
    }
}
