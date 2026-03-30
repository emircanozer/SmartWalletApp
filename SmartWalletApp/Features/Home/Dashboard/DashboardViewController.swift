import UIKit

class DashboardViewController: UIViewController {
    private let contentView = DashboardContentView()
    private let toastLabel = UILabel()
    // mock verileri
    private let transactions: [DashboardTransaction] = [
        .init(category: .market, dateText: "1 Haziran", amountText: "-₺5.000", isIncome: false),
        .init(category: .salary, dateText: "1 Haziran", amountText: "+₺50.000", isIncome: true),
        .init(category: .restaurant, dateText: "28 Mayıs", amountText: "-₺1.200", isIncome: false)
    ]

    override func loadView() {
        view = contentView // tasarımı komple aldık
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
        bindActions()
        configureToast()
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

    @objc func handleCopyTap() {
        UIPasteboard.general.string = "TR12 3456 7890 1234 5678 90"
        showToast()
    }
}


extension DashboardViewController: UITableViewDataSource {
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

extension DashboardViewController: UITableViewDelegate { // row hight
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }

    //seçince highlight kalmaması için
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
