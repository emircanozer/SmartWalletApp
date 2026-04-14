import UIKit

final class InvestmentTradingViewController: UIViewController {
    var onBack: (() -> Void)?
    var onReviewTrade: ((InvestmentTradeContext) -> Void)?

    private let viewModel: InvestmentTradingViewModel
    private let contentView = InvestmentTradingContentView()
    private let refreshControl = UIRefreshControl()
    private var currentViewData: InvestmentTradingViewData?

    init(viewModel: InvestmentTradingViewModel) {
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
        configureRefreshControl()
        registerKeyboardObservers()
        enableInteractivePopGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

 extension InvestmentTradingViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.actionButton.addTarget(self, action: #selector(handleActionTap), for: .touchUpInside)
        contentView.amountTextField.addTarget(self, action: #selector(handleAmountChanged), for: .editingChanged)

        contentView.assetChipsView.onSelectionChanged = { [weak self] asset in // viewin seçtiği chip butonu view modele gönderir
            self?.viewModel.selectAsset(asset)
        }

        contentView.directionSegmentView.onDirectionChanged = { [weak self] direction in
            self?.viewModel.selectDirection(direction)
        }

        contentView.quickAmountChipsView.onQuickAmountSelected = { [weak self] amount in
            self?.viewModel.applyQuickAmount(amount)
        }
        contentView.amountUnitButton.addTarget(self, action: #selector(handleAmountUnitTap), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
            case .loading:
                if !self.refreshControl.isRefreshing {
                    self.setCenteredLoading(true)
                }
            case .loaded(let data):
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
                self.currentViewData = data
                self.contentView.apply(data)
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

    func loadData() {
        Task {
            await viewModel.load()
        }
    }

    func registerKeyboardObservers() {
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

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleActionTap() {
        contentView.dismissKeyboard()
        guard let context = viewModel.makeTradeContext() else {
            showAlert(message: "İşlem bilgileri hazırlanamadı. Lütfen girişlerinizi kontrol edin.")
            return
        }
        onReviewTrade?(context)
    }

    @objc func handleAmountChanged() {
        viewModel.updateEnteredAmount(contentView.amountTextField.text ?? "")
    }

    @objc func handlePullToRefresh() {
        loadData()
    }

    @objc func handleAmountUnitTap() {
        guard let data = currentViewData else { return }

        let alert = UIAlertController(title: "Giriş Türü", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: data.quantityOptionTitle, style: .default) { [weak self] _ in
            self?.viewModel.selectInputMode(.quantity)
        })
        alert.addAction(UIAlertAction(title: "TL", style: .default) { [weak self] _ in
            self?.viewModel.selectInputMode(.fiat)
        })
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))

        if let popover = alert.popoverPresentationController {
            popover.sourceView = contentView.amountUnitButton
            popover.sourceRect = contentView.amountUnitButton.bounds
        }

        present(alert, animated: true)
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = max(0, keyboardFrame.height - view.safeAreaInsets.bottom) + 24
        contentView.setBottomInset(bottomInset)
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        contentView.setBottomInset(0)
    }
}
