import UIKit

/* ViewModel state’ini dinliyor
 loading / loaded / failure durumlarına göre UI’ı güncelliyor
 */

class DashboardViewController: UIViewController {
    var onSeeAllTransactions: (([DashboardTransaction]) -> Void)?
    var onSendMoneyTap: (() -> Void)?
    var onInvestmentPortfolioTap: (() -> Void)?
    var onAnalysisTap: (() -> Void)?

    private let viewModel: DashboardViewModel
    private let contentView = DashboardContentView()
    private let toastLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    private var previewTransactions: [DashboardTransaction] = []
    private var allTransactions: [DashboardTransaction] = []
    private var currentIban: String = ""

    init(viewModel: DashboardViewModel) {
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
        bindTableView()
        bindActions()
        bindViewModel()
        configureRefreshControl()
        configureToast()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadDashboard()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.applyCornerRadius()
    }
}

extension DashboardViewController {
    func bindTableView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }

    func bindActions() {
        contentView.copyButton.addTarget(self, action: #selector(handleCopyTap), for: .touchUpInside)
        contentView.seeAllButton.addTarget(self, action: #selector(handleSeeAllTap), for: .touchUpInside)
        contentView.onQuickActionTap = { [weak self] actionType in
            switch actionType {
            case .sendMoney:
                self?.onSendMoneyTap?()
            case .investmentPortfolio:
                self?.onInvestmentPortfolioTap?()
            case .analysis:
                self?.onAnalysisTap?()
            default:
                break
            }
        }
    }

    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        contentView.setRefreshControl(refreshControl)
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
                //vm'den closure ile gelen ekrana basacağımız data verisini burada alıp kullanıyoruz 
            case .loaded(let data):
                self.contentView.setLoading(false)
                self.refreshControl.endRefreshing()
                self.previewTransactions = data.previewTransactions
                self.allTransactions = data.allTransactions
                self.currentIban = data.ibanText
                self.contentView.applyData(data)
                self.contentView.tableView.reloadData()
            case .failure(let message):
                self.contentView.setLoading(false)
                self.refreshControl.endRefreshing()
                self.showAlert(message: message)
            }
        }
    }

    func loadDashboard() {
        Task {
            await viewModel.loadDashboard()
        }
    }

    func configureToast() {
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.alpha = 0
        toastLabel.text = "IBAN kopyalandı"
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        toastLabel.textColor = .white
        toastLabel.backgroundColor = AppColor.primaryText.withAlphaComponent(0.92)
        toastLabel.layer.cornerRadius = 12
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)

        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26),
            toastLabel.heightAnchor.constraint(equalToConstant: 40),
            toastLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])
    }

    func showToast() {
        UIView.animate(withDuration: 0.2) {
            self.toastLabel.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            UIView.animate(withDuration: 0.2) {
                self?.toastLabel.alpha = 0
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleCopyTap() {
        guard !currentIban.isEmpty else { return }
        UIPasteboard.general.string = currentIban
        showToast()
    }

    @objc func handleSeeAllTap() {
        guard !allTransactions.isEmpty else { return }
        onSeeAllTransactions?(allTransactions)
    }

    @objc func handlePullToRefresh() {
        loadDashboard()
    }

}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        previewTransactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTransactionCell.reuseIdentifier, for: indexPath) as? DashboardTransactionCell else {
            return UITableViewCell()
        }

        cell.configure(with: previewTransactions[indexPath.row])
        return cell
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        122
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
