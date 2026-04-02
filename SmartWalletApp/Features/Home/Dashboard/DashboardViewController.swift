import UIKit

class DashboardViewController: UIViewController {
    var onSeeAllTransactions: (([DashboardTransaction]) -> Void)?

    private let viewModel: DashboardViewModel
    private let contentView = DashboardContentView()
    private let toastLabel = UILabel()
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
        configureToast()
        loadDashboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.contentView.setLoading(false)
            case .loading:
                self.contentView.setLoading(true)
            case .loaded(let data):
                self.contentView.setLoading(false)
                self.previewTransactions = data.previewTransactions
                self.allTransactions = data.allTransactions
                self.currentIban = data.ibanText
                self.contentView.applyData(data)
                self.contentView.tableView.reloadData()
            case .failure(let message):
                self.contentView.setLoading(false)
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
        toastLabel.backgroundColor = UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 0.92)
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
