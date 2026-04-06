import UIKit

final class SendMoneyViewController: UIViewController {
    var onTransferSucceeded: ((WalletTransferResponse) -> Void)?

    private let viewModel: SendMoneyViewModel
    private let contentView = SendMoneyContentView()
    private let refreshControl = UIRefreshControl()

    init(viewModel: SendMoneyViewModel) {
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
        bindDismissKeyboard()
        configureRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadScreen()
    }
}

 extension SendMoneyViewController {
    func bindActions() {
        contentView.ibanTextField.addTarget(self, action: #selector(handleIBANChanged), for: .editingChanged)
        contentView.amountTextField.addTarget(self, action: #selector(handleAmountChanged), for: .editingChanged)
        contentView.lookupView.starButton.addTarget(self, action: #selector(handleSaveRecipientTap), for: .touchUpInside)
        contentView.categoryButton.addTarget(self, action: #selector(handleCategoryTap), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(handleConfirmTap), for: .touchUpInside)
        contentView.noteTextView.delegate = self
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.contentView.setLoading(false)
                self.refreshControl.endRefreshing()
            case .loading:
                if !self.refreshControl.isRefreshing {
                    self.contentView.setLoading(true)
                }
                // gelen veriyi ekrana basacak 
            case .loaded(let data):
                self.contentView.setLoading(false)
                self.refreshControl.endRefreshing()
                self.contentView.applyData(data) // **
                self.bindRecipientRows()
                self.bindAmountChips()
            case .transferSucceeded(let response):
                self.contentView.setLoading(false)
                self.refreshControl.endRefreshing()
                self.onTransferSucceeded?(response)
            case .failure(let message):
                self.contentView.setLoading(false)
                self.refreshControl.endRefreshing()
                self.showAlert(message: message)
            }
        }
    }

    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        contentView.setRefreshControl(refreshControl)
    }

    func bindDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    func loadScreen() {
        Task {
            await viewModel.load()
        }
    }

    func bindRecipientRows() {
        contentView.subviewsRecursive.compactMap { $0 as? SendMoneyRecipientRowView }.forEach { view in
            view.removeTarget(nil, action: nil, for: .allEvents)
            view.addTarget(self, action: #selector(handleRecipientTap(_:)), for: .touchUpInside)
        }
    }

    func bindAmountChips() {
        contentView.subviewsRecursive.compactMap { $0 as? SendMoneyAmountChipButton }.forEach { button in
            button.removeTarget(nil, action: nil, for: .allEvents)
            button.addTarget(self, action: #selector(handleAmountChipTap(_:)), for: .touchUpInside)
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
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

    @objc func handleRecipientTap(_ sender: SendMoneyRecipientRowView) {
        viewModel.selectRecipient(id: sender.recipient.id)
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

    @objc func handleBackgroundTap() {
        view.endEditing(true)
    }

    @objc func handlePullToRefresh() {
        loadScreen()
    }
}

extension SendMoneyViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateNote(textView.text)
    }
}

 extension UIView {
    var subviewsRecursive: [UIView] {
        subviews + subviews.flatMap { $0.subviewsRecursive }
    }
}
