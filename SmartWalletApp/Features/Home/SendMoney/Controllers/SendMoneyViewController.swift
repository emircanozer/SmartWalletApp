import UIKit

enum SendMoneyPresentationStyle {
    case tabRoot
    case pushedFromDashboard
}

final class SendMoneyViewController: BaseViewController {
    private enum Constants {
        static let noteCharacterLimit = 40
    }

    var onTransferSucceeded: ((WalletTransferResponse) -> Void)?

    private let viewModel: SendMoneyViewModel
    private let presentationStyle: SendMoneyPresentationStyle
    private let contentView = SendMoneyContentView()
    private let refreshControl = UIRefreshControl()

    init(viewModel: SendMoneyViewModel, presentationStyle: SendMoneyPresentationStyle) {
        self.viewModel = viewModel
        self.presentationStyle = presentationStyle
        super.init(nibName: nil, bundle: nil)
        title = "Para Gönder"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBehavior()
        bindActions()
        bindViewModel()
        bindDismissKeyboard()
        configureRefreshControl()
        configureRecipientsTableView()
        observeKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch presentationStyle {
        case .tabRoot:
            navigationController?.setNavigationBarHidden(true, animated: false)
        case .pushedFromDashboard:
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        loadScreen()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

 extension SendMoneyViewController {
    func configureNavigationBehavior() {
        switch presentationStyle {
        case .tabRoot:
            navigationItem.hidesBackButton = true
            disableInteractivePopGesture()
        case .pushedFromDashboard:
            navigationItem.hidesBackButton = false
            enableInteractivePopGesture()
        }
    }

    func bindActions() {
        contentView.ibanTextField.addTarget(self, action: #selector(handleIBANChanged), for: .editingChanged)
        contentView.amountTextField.addTarget(self, action: #selector(handleAmountChanged), for: .editingChanged)
        contentView.ibanTextField.addTarget(self, action: #selector(handleEditingDidBegin(_:)), for: .editingDidBegin)
        contentView.amountTextField.addTarget(self, action: #selector(handleEditingDidBegin(_:)), for: .editingDidBegin)
        contentView.lookupView.starButton.addTarget(self, action: #selector(handleSaveRecipientTap), for: .touchUpInside)
        contentView.categoryButton.addTarget(self, action: #selector(handleCategoryTap), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(handleConfirmTap), for: .touchUpInside)
        contentView.noteTextView.delegate = self
    }

     // ViewController switch ile içini açıyor
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
            case .loading:
                if !self.refreshControl.isRefreshing {
                    self.setCenteredLoading(true) // indicator de geliyor
                }
                // gelen veriyi ekrana basacak 
            case .loaded(let data):
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
                self.contentView.applyData(data) // **
                self.bindAmountChips()
            case .transferSucceeded(let response):
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
                self.onTransferSucceeded?(response)
            case .failure(let message):
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
                self.showAlert(message: message)
            }
        }
    }

    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        contentView.setRefreshControl(refreshControl)
    }

    func configureRecipientsTableView() {
        contentView.recipientsTableView.dataSource = self
        contentView.recipientsTableView.delegate = self
    }

    func bindDismissKeyboard() {
        installKeyboardDismissTap()
    }

    func loadScreen() {
        Task {
            await viewModel.load()
        }
    }

    func bindAmountChips() {
        contentView.subviewsRecursive.compactMap { $0 as? SendMoneyAmountChipButton }.forEach { button in
            button.removeTarget(nil, action: nil, for: .allEvents)
            button.addTarget(self, action: #selector(handleAmountChipTap(_:)), for: .touchUpInside)
        }
    }

    func promptForRecipientName() {
        let alert = UIAlertController(
            title: "Aliciyi Kaydet",
            message: "Kayitli alicilar listenizde gorunecek ismi girin.",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Alici adi"
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .no
        }
        alert.addAction(UIAlertAction(title: "Iptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Kaydet", style: .default, handler: { [weak self, weak alert] _ in
            guard let self,
                  let contactName = alert?.textFields?.first?.text else { return }

            Task {
                await self.viewModel.saveLookupRecipient(contactName: contactName)
            }
        }))
        present(alert, animated: true)
    }

    @objc func handleIBANChanged() {
        viewModel.updateIBAN(contentView.ibanTextField.text ?? "")
    }

    @objc func handleAmountChanged() {
        viewModel.updateAmount(contentView.amountTextField.text ?? "")
    }

    @objc func handleSaveRecipientTap() {
        guard viewModel.canSaveLookupRecipient() else { return }
        promptForRecipientName()
    }

    @objc func handleConfirmTap() {
        Task {
            await viewModel.confirmTransfer()
        }
    }

    @objc func handleAmountChipTap(_ sender: SendMoneyAmountChipButton) {
        viewModel.selectQuickAmount(sender.amount)
    }

    @objc func handleCategoryTap() {
        let viewController = SendMoneyCategoryPickerViewController(selectedCategory: viewModel.currentSelectedCategory())
        viewController.onCategorySelected = { [weak self] category in
            self?.viewModel.selectCategory(category)
        }
        present(viewController, animated: true)
    }

    @objc func handlePullToRefresh() {
        loadScreen()
    }

    @objc func handleEditingDidBegin(_ sender: UIView) {
        contentView.scrollToVisible(sender)
    }

    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = max(0, keyboardFrame.height - view.safeAreaInsets.bottom) + 24
        contentView.setKeyboardBottomInset(bottomInset)

        if let firstResponder = view.currentFirstResponder {
            contentView.scrollToVisible(firstResponder)
        }
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        contentView.setKeyboardBottomInset(0)
    }

}

extension SendMoneyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentView.currentRecipients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SendMoneyRecipientCell.reuseIdentifier,
            for: indexPath
        ) as? SendMoneyRecipientCell else {
            return UITableViewCell()
        }

        let recipient = contentView.currentRecipients[indexPath.row]
        let isSelected = recipient.id == contentView.currentSelectedRecipientID
        cell.configure(with: recipient, isSelected: isSelected)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipient = contentView.currentRecipients[indexPath.row]
        viewModel.selectRecipient(id: recipient.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let recipient = contentView.currentRecipients[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completion in
            guard let self else {
                completion(false)
                return
            }

            Task {
                await self.viewModel.deleteRecipient(id: recipient.id)
            }
            completion(true)
        }

        deleteAction.backgroundColor = AppColor.dangerStrong
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension SendMoneyViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let currentText = textView.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: textRange, with: text)
        return updatedText.count <= Constants.noteCharacterLimit
    }

    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateNote(textView.text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        contentView.scrollToVisible(textView)
    }
}

 extension UIView {
    var subviewsRecursive: [UIView] {
        subviews + subviews.flatMap { $0.subviewsRecursive }
    }
}
