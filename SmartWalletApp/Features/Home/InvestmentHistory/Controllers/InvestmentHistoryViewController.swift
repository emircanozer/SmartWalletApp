import UIKit

final class InvestmentHistoryViewController: UIViewController {
    var onBack: (() -> Void)?

    private let viewModel: InvestmentHistoryViewModel
    private let contentView = InvestmentHistoryContentView()
    private let refreshControl = UIRefreshControl()

    init(viewModel: InvestmentHistoryViewModel) {
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
        enableInteractivePopGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadHistory()
    }
}

 extension InvestmentHistoryViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.allFilterButton.addTarget(self, action: #selector(handleAllFilterTap), for: .touchUpInside)
        contentView.buyFilterButton.addTarget(self, action: #selector(handleBuyFilterTap), for: .touchUpInside)
        contentView.sellFilterButton.addTarget(self, action: #selector(handleSellFilterTap), for: .touchUpInside)
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
                self.contentView.apply(data)
            case .aiSummaryLoading:
                self.contentView.setSummaryLoading(true)
            case .aiSummaryLoaded(let data):
                self.contentView.applySummary(data)
            case .aiSummaryFailed(let message):
                self.contentView.showSummaryFallback(message)
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

    func loadHistory() {
        Task {
            await viewModel.load()
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handlePullToRefresh() {
        loadHistory()
    }

    @objc func handleAllFilterTap() {
        viewModel.applyFilter(.all)
    }

    @objc func handleBuyFilterTap() {
        viewModel.applyFilter(.buy)
    }

    @objc func handleSellFilterTap() {
        viewModel.applyFilter(.sell)
    }
}
