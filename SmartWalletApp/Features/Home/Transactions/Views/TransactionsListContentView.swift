import UIKit

// butonların çizimi 
class TransactionsListContentView: UIView {
    let tableView = UITableView(frame: .zero, style: .plain)
    let dateFilterButton = UIButton(type: .system)
    let clearDateFilterButton = UIButton(type: .system)
    let emptyStateLabel = UILabel()
    let allFilterButton = UIButton(type: .system)
    let incomeFilterButton = UIButton(type: .system)
    let expenseFilterButton = UIButton(type: .system)

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let filtersStack = UIStackView()
    private let summaryCard = UIView()
    private let summaryTitleLabel = UILabel()
    private let summaryAmountLabel = UILabel()
    private let summaryIconContainer = UIView()
    private let summaryIconView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
        applyContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TransactionsListContentView {
    func configureView() {
        backgroundColor = .white

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = AppColor.tertiaryText
        subtitleLabel.numberOfLines = 0

        filtersStack.axis = .horizontal
        filtersStack.alignment = .fill
        filtersStack.distribution = .fillEqually
        filtersStack.spacing = 8

        summaryCard.backgroundColor = .black
        summaryCard.layer.shadowColor = UIColor.black.cgColor
        summaryCard.layer.shadowOpacity = 0.08
        summaryCard.layer.shadowRadius = 14
        summaryCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        summaryTitleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        summaryTitleLabel.textColor = AppColor.white62

        summaryAmountLabel.font = .systemFont(ofSize: 18, weight: .bold)
        summaryAmountLabel.textColor = AppColor.accentGold

        summaryIconContainer.backgroundColor = AppColor.titleDark
        summaryIconView.tintColor = AppColor.accentGold
        summaryIconView.contentMode = .scaleAspectFit

        dateFilterButton.backgroundColor = AppColor.primaryYellow
        dateFilterButton.setTitleColor(AppColor.primaryText, for: .normal)
        dateFilterButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)

        clearDateFilterButton.setTitleColor(AppColor.accentOlive, for: .normal)
        clearDateFilterButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)

        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emptyStateLabel.textColor = AppColor.quietText
        emptyStateLabel.isHidden = true

        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 122
        tableView.register(DashboardTransactionCell.self, forCellReuseIdentifier: DashboardTransactionCell.reuseIdentifier)

        [allFilterButton, incomeFilterButton, expenseFilterButton, dateFilterButton].forEach {
            $0.setTitleColor(AppColor.mutedText, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
            $0.backgroundColor = AppColor.chipSurface
        }

        dateFilterButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        dateFilterButton.backgroundColor = AppColor.primaryYellow
        dateFilterButton.setTitleColor(AppColor.primaryText, for: .normal)
    }

    func buildHierarchy() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(filtersStack)
        addSubview(clearDateFilterButton)
        addSubview(summaryCard)
        addSubview(tableView)
        addSubview(emptyStateLabel)

        [allFilterButton, incomeFilterButton, expenseFilterButton, dateFilterButton].forEach {
            filtersStack.addArrangedSubview($0)
        }

        summaryCard.addSubview(summaryTitleLabel)
        summaryCard.addSubview(summaryAmountLabel)
        summaryCard.addSubview(summaryIconContainer)
        summaryIconContainer.addSubview(summaryIconView)
    }

    func setupLayout() {
        [
            titleLabel,
            subtitleLabel,
            filtersStack,
            summaryCard,
            summaryTitleLabel,
            summaryAmountLabel,
            summaryIconContainer,
            summaryIconView,
            dateFilterButton,
            clearDateFilterButton,
            tableView,
            emptyStateLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            filtersStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            filtersStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            filtersStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            filtersStack.heightAnchor.constraint(equalToConstant: 42),

            clearDateFilterButton.topAnchor.constraint(equalTo: filtersStack.bottomAnchor, constant: 10),
            clearDateFilterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            clearDateFilterButton.heightAnchor.constraint(equalToConstant: 24),

            tableView.topAnchor.constraint(equalTo: clearDateFilterButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            summaryCard.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 14),
            summaryCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            summaryCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            summaryTitleLabel.topAnchor.constraint(equalTo: summaryCard.topAnchor, constant: 16),
            summaryTitleLabel.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 20),
            summaryTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: summaryIconContainer.leadingAnchor, constant: -16),

            summaryAmountLabel.topAnchor.constraint(equalTo: summaryTitleLabel.bottomAnchor, constant: 8),
            summaryAmountLabel.leadingAnchor.constraint(equalTo: summaryTitleLabel.leadingAnchor),
            summaryAmountLabel.bottomAnchor.constraint(equalTo: summaryCard.bottomAnchor, constant: -16),

            summaryIconContainer.centerYAnchor.constraint(equalTo: summaryCard.centerYAnchor),
            summaryIconContainer.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -18),
            summaryIconContainer.widthAnchor.constraint(equalToConstant: 42),
            summaryIconContainer.heightAnchor.constraint(equalToConstant: 42),

            summaryIconView.centerXAnchor.constraint(equalTo: summaryIconContainer.centerXAnchor),
            summaryIconView.centerYAnchor.constraint(equalTo: summaryIconContainer.centerYAnchor),
            summaryIconView.widthAnchor.constraint(equalToConstant: 20),
            summaryIconView.heightAnchor.constraint(equalToConstant: 20),
            summaryCard.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyStateLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 40),
            emptyStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])
    }

    func applyContent() {
        titleLabel.text = "Tüm İşlemler"
        subtitleLabel.text = "Son harcamalarınızı ve gelirlerinizi takip edin."
        dateFilterButton.setTitle("Tarih Seç", for: .normal)
        clearDateFilterButton.setTitle("Sıfırla", for: .normal)
        emptyStateLabel.text = "Bu tarih aralığında işlem bulunamadı."
        allFilterButton.setTitle(TransactionsFilterType.all.title, for: .normal)
        incomeFilterButton.setTitle(TransactionsFilterType.income.title, for: .normal)
        expenseFilterButton.setTitle(TransactionsFilterType.expense.title, for: .normal)
        summaryTitleLabel.text = "TOPLAM HAREKET"
        summaryAmountLabel.text = "₺0"
        summaryIconView.image = UIImage(systemName: "arrow.down.right")
    }

    func applyCornerRadius() {
        [allFilterButton, incomeFilterButton, expenseFilterButton, dateFilterButton].forEach {
            $0.layer.cornerRadius = 21
        }
        summaryCard.layer.cornerRadius = 18
        summaryIconContainer.layer.cornerRadius = 12
    }

    func setEmptyStateVisible(_ isVisible: Bool) {
        emptyStateLabel.isHidden = !isVisible
        tableView.isHidden = isVisible
    }

    func applyFilterSelection(_ filter: TransactionsFilterType) {
        let buttons: [(UIButton, TransactionsFilterType)] = [
            (allFilterButton, .all),
            (incomeFilterButton, .income),
            (expenseFilterButton, .expense)
        ]

        buttons.forEach { button, buttonFilter in
            let isSelected = buttonFilter == filter
            button.backgroundColor = isSelected
                ? AppColor.primaryYellow
                : AppColor.chipSurface
            button.setTitleColor(
                isSelected
                    ? AppColor.primaryText
                    : AppColor.mutedText,
                for: .normal
            )
        }
    }

    func applySummary(title: String, amountText: String, isPositive: Bool, showsPrefix: Bool) {
        summaryTitleLabel.text = title
        summaryAmountLabel.text = amountText
        summaryAmountLabel.textColor = isPositive
            ? AppColor.accentGold
            : AppColor.warningOrange
        summaryIconView.image = UIImage(systemName: showsPrefix ? (isPositive ? "arrow.down.left" : "arrow.up.right") : "equal")
    }

    func updateDateFilterTitle(startDate: Date, endDate: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd.MM.yyyy"
        let title = "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
        dateFilterButton.setTitle(title, for: .normal)
    }

    func resetDateFilterTitle() {
        dateFilterButton.setTitle("Tarih Seç", for: .normal)
    }
}
