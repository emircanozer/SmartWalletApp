import UIKit

final class FinancialGoalAddMoneyViewController: BaseViewController, UITextViewDelegate {
    var onBack: (() -> Void)?
    var onContributionAdded: ((FinancialGoalAddMoneySuccessContext) -> Void)?

    private let viewModel: FinancialGoalAddMoneyViewModel
    private let contentView = FinancialGoalAddMoneyContentView()

    init(viewModel: FinancialGoalAddMoneyViewModel) {
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
        contentView.apply(viewModel.makeViewData())
        viewModel.load()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

 extension FinancialGoalAddMoneyViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(handleConfirmTap), for: .touchUpInside)
        contentView.amountField.addTarget(self, action: #selector(handleAmountChanged), for: .editingChanged)
        contentView.amountField.addTarget(self, action: #selector(handleAmountFocus), for: .editingDidBegin)
        contentView.onQuickAmountTap = { [weak self] amount in
            self?.dismissKeyboard()
            self?.viewModel.selectQuickAmount(amount)
        }
        contentView.noteTextView.delegate = self
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

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleConfirmTap() {
        dismissKeyboard()
        guard let context = viewModel.makeSuccessContext() else { return }
        onContributionAdded?(context)
    }

    @objc func handleAmountChanged() {
        viewModel.updateAmount(contentView.amountField.text ?? "")
    }

    @objc func handleAmountFocus() {
        contentView.scrollToVisible(contentView.amountField)
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

extension FinancialGoalAddMoneyViewController {
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
        textView.text = "Orn: Bu ay maastan ayirdim"
        textView.textColor = AppColor.placeholderText
    }
}
