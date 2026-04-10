import UIKit

final class MarketPricesViewController: UIViewController {
    private let viewModel: MarketPricesViewModel
    private let contentView = MarketPricesContentView()
    private let refreshControl = UIRefreshControl()

    init(viewModel: MarketPricesViewModel) {
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
        bindViewModel()
        configureRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadPrices()
    }
}

private extension MarketPricesViewController {
    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        contentView.setRefreshControl(refreshControl)
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
            case .failure(let message):
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
                self.showAlert(message: message)
            }
        }
    }

    func loadPrices() {
        Task {
            await viewModel.load()
        }
    }

    // çıkarılacak 
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handlePullToRefresh() {
        loadPrices()
    }
}
