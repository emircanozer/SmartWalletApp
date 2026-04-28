import UIKit

final class TransferReceiptsViewController: BaseViewController {
    var onBack: (() -> Void)?
    var onReceiptDetailSelected: ((String) -> Void)?

    private let viewModel: TransferReceiptsViewModel
    private let contentView = TransferReceiptsContentView()
    private var currentItems: [TransferReceiptsItemViewData] = []
    init(viewModel: TransferReceiptsViewModel) {
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
        configureTableView()
        configureMenus()
        loadReceipts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

 extension TransferReceiptsViewController {
    func bindActions() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.searchField.addTarget(self, action: #selector(handleSearchChanged), for: .editingChanged)

        installKeyboardDismissTap()
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
            case .loading:
                self.contentView.setLoading(true)
                self.setCenteredLoading(true)
            case .loaded(let data):
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
                self.contentView.apply(data)
                self.currentItems = data.items
                self.contentView.tableView.reloadData()
                self.configureMenus()
            case .failure(let message):
                self.contentView.setLoading(false)
                self.setCenteredLoading(false)
                self.showAlert(message: message)
            }
        }
    }

    func configureTableView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }

    func configureMenus() {
        contentView.dateFilterButton.menu = UIMenu(children: TransferReceiptsDateFilter.allCases.map { filter in
            UIAction(title: filter.title) { [weak self] _ in
                self?.viewModel.updateDateFilter(filter)
            }
        })
        contentView.typeFilterButton.menu = UIMenu(children: TransferReceiptsTypeFilter.allCases.map { filter in
            UIAction(title: filter.title) { [weak self] _ in
                self?.viewModel.updateTypeFilter(filter)
            }
        })
        contentView.dateFilterButton.showsMenuAsPrimaryAction = true
        contentView.typeFilterButton.showsMenuAsPrimaryAction = true
    }

    func loadReceipts() {
        Task {
            await viewModel.load()
        }
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleSearchChanged() {
        viewModel.updateSearchText(contentView.searchField.text ?? "")
    }

}

extension TransferReceiptsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TransferReceiptsItemCell.reuseIdentifier, for: indexPath) as? TransferReceiptsItemCell
        else {
            return UITableViewCell()
        }

        let item = currentItems[indexPath.row]
        cell.configure(with: item)
        cell.onDetailTap = { [weak self] in
            self?.onReceiptDetailSelected?(item.id)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        128
    }
}
