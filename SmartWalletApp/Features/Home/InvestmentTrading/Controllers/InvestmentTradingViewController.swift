import UIKit

final class InvestmentTradingViewController: BaseViewController {
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
        contentView.amountUnitButton.showsMenuAsPrimaryAction = true

        contentView.assetChipsView.onSelectionChanged = { [weak self] asset in // viewin seçtiği chip butonu view modele gönderir
            self?.viewModel.selectAsset(asset)
        }

        contentView.directionSegmentView.onDirectionChanged = { [weak self] direction in
            self?.viewModel.selectDirection(direction)
        }

        contentView.quickAmountChipsView.onQuickAmountSelected = { [weak self] amount in
            self?.viewModel.applyQuickAmount(amount)
        }
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
                self.configureAmountUnitMenu(with: data)
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

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = max(0, keyboardFrame.height - view.safeAreaInsets.bottom) + 24
        contentView.setBottomInset(bottomInset)
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        contentView.setBottomInset(0)
    }

    func configureAmountUnitMenu(with data: InvestmentTradingViewData) {
        let quantityAction = UIAction(
            title: data.quantityOptionTitle,
            state: data.selectedInputMode == .quantity ? .on : .off
        ) { [weak self] _ in
            self?.viewModel.selectInputMode(.quantity)
        }

        let fiatAction = UIAction(
            title: "TL",
            state: data.selectedInputMode == .fiat ? .on : .off
        ) { [weak self] _ in
            self?.viewModel.selectInputMode(.fiat)
        }

        contentView.amountUnitButton.menu = UIMenu(
            title: "",
            options: .displayInline,
            children: [quantityAction, fiatAction]
        )
    }
}
