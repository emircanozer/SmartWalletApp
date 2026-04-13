import UIKit

class TransactionsListViewController: UIViewController {
    private let viewModel: TransactionsListViewModel
    private let contentView = TransactionsListContentView()
    private let refreshControl = UIRefreshControl()
    private var transactions: [DashboardTransaction] = []
    private var selectedStartDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    private var selectedEndDate = Date()

    init(viewModel: TransactionsListViewModel) {
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
        navigationItem.title = "Tüm İşlemler"
        bindTableView()
        bindActions()
        bindViewModel()
        configureRefreshControl()
        viewModel.loadInitialState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        refreshTransactions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.applyCornerRadius()
    }
}

extension TransactionsListViewController {
    func bindTableView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }

    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        contentView.tableView.refreshControl = refreshControl
    }

    func bindActions() {
        contentView.dateFilterButton.addTarget(self, action: #selector(handleDateFilterTap), for: .touchUpInside)
        contentView.clearDateFilterButton.addTarget(self, action: #selector(handleResetFilterTap), for: .touchUpInside)
        contentView.allFilterButton.addTarget(self, action: #selector(handleAllFilterTap), for: .touchUpInside)
        contentView.incomeFilterButton.addTarget(self, action: #selector(handleIncomeFilterTap), for: .touchUpInside)
        contentView.expenseFilterButton.addTarget(self, action: #selector(handleExpenseFilterTap), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onTransactionsChange = { [weak self] data in
            self?.refreshControl.endRefreshing()
            self?.transactions = data.transactions
            self?.contentView.setEmptyStateVisible(data.transactions.isEmpty)
            self?.contentView.applyFilterSelection(data.selectedFilter)
            self?.contentView.applySummary(
                title: data.summaryTitle,
                amountText: data.summaryAmountText,
                isPositive: data.summaryIsPositive,
                showsPrefix: data.summaryShowsPrefix
            )
            self?.contentView.tableView.reloadData()
        }

        viewModel.onError = { [weak self] message in
            self?.refreshControl.endRefreshing()
            self?.showAlert(message: message)
        }
    }

    @objc func handleDateFilterTap() {
        let viewController = TransactionsDateFilterViewController(
            startDate: selectedStartDate,
            endDate: selectedEndDate
        )

        viewController.onApply = { [weak self] startDate, endDate in
            guard let self else { return }
            self.selectedStartDate = startDate
            self.selectedEndDate = endDate
            self.contentView.updateDateFilterTitle(startDate: startDate, endDate: endDate)
            self.viewModel.applyFilter(startDate: startDate, endDate: endDate)
        }

        present(viewController, animated: true)
    }

    @objc func handleResetFilterTap() {
        selectedEndDate = Date()
        selectedStartDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        contentView.resetDateFilterTitle()
        viewModel.resetFilter()
    }

    @objc func handleAllFilterTap() {
        viewModel.applyFilterType(.all)
    }

    @objc func handleIncomeFilterTap() {
        viewModel.applyFilterType(.income)
    }

    @objc func handleExpenseFilterTap() {
        viewModel.applyFilterType(.expense)
    }

    @objc func handlePullToRefresh() {
        refreshTransactions()
    }

    func refreshTransactions() {
        Task {
            await viewModel.refreshTransactions()
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

extension TransactionsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTransactionCell.reuseIdentifier, for: indexPath) as? DashboardTransactionCell else {
            return UITableViewCell()
        }

        cell.configure(with: transactions[indexPath.row])
        return cell
    }
}

extension TransactionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        122
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
