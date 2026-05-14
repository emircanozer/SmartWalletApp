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

 extension SendMoneyCategoryPickerViewController {
    func configureView() {
        view.backgroundColor = AppColor.appBackground

        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.text = "Kategori Seç"

        tableView.backgroundColor = AppColor.appBackground
        tableView.tintColor = AppColor.primaryText
        tableView.separatorStyle = .none
        tableView.rowHeight = 84
        tableView.sectionHeaderTopPadding = 0
        tableView.register(SendMoneyCategoryCell.self, forCellReuseIdentifier: SendMoneyCategoryCell.reuseIdentifier)
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SendMoneyCategoryCell.reuseIdentifier,
            for: indexPath
        ) as? SendMoneyCategoryCell else {
            return UITableViewCell()
        }

        let category = categories[indexPath.row]
        cell.configure(with: category, isSelected: category == selectedCategory)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        dismiss(animated: true) { [weak self] in
            self?.onCategorySelected?(category)
        }
    }
}

private final class SendMoneyCategoryCell: UITableViewCell {
    static let reuseIdentifier = "SendMoneyCategoryCell"

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let textStackView = UIStackView()
    private let checkmarkView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 18
    }

    func configure(with category: SendMoneyTransferCategory, isSelected: Bool) {
        titleLabel.text = category.title
        subtitleLabel.text = category.subtitle
        checkmarkView.isHidden = !isSelected
        containerView.layer.borderColor = AppColor.resolvedCGColor(isSelected ? AppColor.primaryYellow : AppColor.borderSoft, for: traitCollection)
        containerView.backgroundColor = isSelected ? AppColor.surfaceWarm : AppColor.whitePrimary
    }
}

 extension SendMoneyCategoryCell {
    func configureView() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .clear

        containerView.backgroundColor = AppColor.whitePrimary
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = AppColor.resolvedCGColor(AppColor.borderSoft, for: traitCollection)

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = AppColor.bodyText
        subtitleLabel.numberOfLines = 1

        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.distribution = .fill
        textStackView.spacing = 6

        checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkView.tintColor = AppColor.accentOlive
        checkmarkView.contentMode = .scaleAspectFit
        checkmarkView.isHidden = true
    }

    func buildHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(textStackView)
        containerView.addSubview(checkmarkView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
    }

    func setupLayout() {
        [containerView, textStackView, checkmarkView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            textStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            textStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            textStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14),
            textStackView.trailingAnchor.constraint(equalTo: checkmarkView.leadingAnchor, constant: -14),

            checkmarkView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18),
            checkmarkView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 22),
            checkmarkView.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
