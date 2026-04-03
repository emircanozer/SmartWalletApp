import UIKit

final class SendMoneyCategoryPickerViewController: UIViewController {
    var onCategorySelected: ((SendMoneyTransferCategory) -> Void)?

    private let categories = SendMoneyTransferCategory.allCases
    private let selectedCategory: SendMoneyTransferCategory?
    private let titleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)

    init(selectedCategory: SendMoneyTransferCategory?) {
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        buildHierarchy()
        setupLayout()
        configureSheet()
    }
}

private extension SendMoneyCategoryPickerViewController {
    func configureView() {
        view.backgroundColor = .white

        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)
        titleLabel.text = "Kategori Seç"

        tableView.backgroundColor = .white
        tableView.tintColor = UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.rowHeight = 58
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    func buildHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureSheet() {
        guard let sheet = sheetPresentationController else { return }
        sheet.detents = [.medium()]
        sheet.prefersGrabberVisible = true
        sheet.preferredCornerRadius = 24
    }
}

extension SendMoneyCategoryPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]

        var content = UIListContentConfiguration.subtitleCell()
        content.text = category.title
        content.secondaryText = category.subtitle
        content.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
        content.textProperties.color = UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)
        content.secondaryTextProperties.font = .systemFont(ofSize: 13, weight: .medium)
        content.secondaryTextProperties.color = UIColor(red: 0.46, green: 0.48, blue: 0.54, alpha: 1.0)
        cell.contentConfiguration = content
        cell.backgroundColor = .white
        cell.accessoryType = category == selectedCategory ? .checkmark : .none
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        dismiss(animated: true) { [weak self] in
            self?.onCategorySelected?(category)
        }
    }
}
