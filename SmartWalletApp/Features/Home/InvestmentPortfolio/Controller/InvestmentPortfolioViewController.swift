import UIKit

final class InvestmentPortfolioViewController: UIViewController {
    
    var onBack: (() -> Void)?
    var onTradeTap: (() -> Void)?

    private let viewModel: InvestmentPortfolioViewModel
    private let contentView = InvestmentPortfolioContentView()
    private let refreshControl = UIRefreshControl()

    init(viewModel: InvestmentPortfolioViewModel) {
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

    // yenileme !!! 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadPortfolio()
    }
}

extension InvestmentPortfolioViewController {
    private func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.tradeButton.addTarget(self, action: #selector(handleTradeTap), for: .touchUpInside)
    }

    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        contentView.setRefreshControl(refreshControl)
    }

    private func bindViewModel() {
        // viewmodelde içine veri verilmişti burada kullanılıyor 
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
                // state’i dinler
            case .loaded(let data):
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
                self.contentView.apply(data)  //UI’a basar
            case .failure(let message):
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
                self.showAlert(message: message)
            }
        }
    }

    // task içinde kullandık
    private func loadPortfolio() {
        Task {
            await viewModel.load()
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc private func handleBackTap() {
        onBack?()
    }

    @objc private func handlePullToRefresh() {
        loadPortfolio()
    }

    @objc private func handleTradeTap() {
        onTradeTap?()
    }
}
