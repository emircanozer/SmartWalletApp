import UIKit

class DashboardContentView: UIView {
    let tableView = UITableView(frame: .zero, style: .plain)
    let copyButton = UIButton(type: .system)
    let seeAllButton = UIButton(type: .system)
    var onQuickActionTap: ((DashboardQuickActionType) -> Void)?

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let headerTitleLabel = UILabel()
    private let profileButton = UIButton(type: .system)
    private let greetingLabel = UILabel()
    private let balanceCard = UIView()
    private let ibanLabel = UILabel()
    private let balanceTitleLabel = UILabel()
    private let balanceValueLabel = UILabel()
    private let balanceCurrencyLabel = UILabel()
    private let quickActionsStack = UIStackView()
    private let sectionTitleLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private var tableHeightConstraint: NSLayoutConstraint?

    private let headerTitleText = "SmartWallet AI"
    private let balanceTitleText = "TOPLAM BAKİYE"
    private let sectionTitleText = "Son İşlemler"
    private let seeAllText = "Tümünü Gör"
    private let quickActions: [DashboardQuickAction] = [
        .init(type: .sendMoney, title: "Para Gönder", iconName: "paperplane", isHighlighted: false),
        .init(type: .requestMoney, title: "Para Al", iconName: "doc.text", isHighlighted: false),
        .init(type: .aiAssistant, title: "AI Asistan", iconName: "creditcard", isHighlighted: true),
        .init(type: .analysis, title: "Analiz", iconName: "chart.bar.fill", isHighlighted: false)
    ]

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

extension DashboardContentView {
    func setRefreshControl(_ refreshControl: UIRefreshControl) {
        scrollView.refreshControl = refreshControl
    }

    func configureView() {
        backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        contentContainer.backgroundColor = .white

        headerTitleLabel.textAlignment = .center
        headerTitleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        headerTitleLabel.textColor = UIColor(red: 0.1, green: 0.13, blue: 0.2, alpha: 1.0)

        profileButton.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        profileButton.setImage(UIImage(systemName: "wallet.pass"), for: .normal)
        profileButton.tintColor = .white

        greetingLabel.font = .systemFont(ofSize: 32, weight: .bold)
        greetingLabel.textColor = UIColor(red: 0.1, green: 0.13, blue: 0.2, alpha: 1.0)

        balanceCard.backgroundColor = UIColor(red: 0.12, green: 0.15, blue: 0.2, alpha: 1.0)
        balanceCard.layer.shadowColor = UIColor.black.cgColor
        balanceCard.layer.shadowOpacity = 0.14
        balanceCard.layer.shadowRadius = 30
        balanceCard.layer.shadowOffset = CGSize(width: 0, height: 18)

        ibanLabel.font = .monospacedSystemFont(ofSize: 13, weight: .semibold)
        ibanLabel.textColor = UIColor(white: 1.0, alpha: 0.62)

        copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        copyButton.tintColor = UIColor(white: 1.0, alpha: 0.7)

        balanceTitleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        balanceTitleLabel.textColor = UIColor(white: 1.0, alpha: 0.62)
        balanceTitleLabel.numberOfLines = 1

        balanceValueLabel.font = .systemFont(ofSize: 52, weight: .bold)
        balanceValueLabel.textColor = UIColor(red: 0.99, green: 0.97, blue: 0.92, alpha: 1.0)

        balanceCurrencyLabel.font = .systemFont(ofSize: 28, weight: .bold)
        balanceCurrencyLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.03, alpha: 1.0)

        quickActionsStack.axis = .horizontal
        quickActionsStack.alignment = .top
        quickActionsStack.distribution = .fillEqually
        quickActionsStack.spacing = 12

        sectionTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        sectionTitleLabel.textColor = UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)

        seeAllButton.setTitleColor(UIColor(red: 0.49, green: 0.43, blue: 0.2, alpha: 1.0), for: .normal)
        seeAllButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)

        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.rowHeight = 122
        tableView.register(DashboardTransactionCell.self, forCellReuseIdentifier: DashboardTransactionCell.reuseIdentifier)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        contentContainer.addSubview(headerTitleLabel)
        contentContainer.addSubview(profileButton)
        contentContainer.addSubview(greetingLabel)
        contentContainer.addSubview(balanceCard)
        balanceCard.addSubview(ibanLabel)
        balanceCard.addSubview(copyButton)
        balanceCard.addSubview(balanceTitleLabel)
        balanceCard.addSubview(balanceValueLabel)
        balanceCard.addSubview(balanceCurrencyLabel)
        contentContainer.addSubview(quickActionsStack)
        contentContainer.addSubview(sectionTitleLabel)
        contentContainer.addSubview(seeAllButton)
        contentContainer.addSubview(tableView)
        contentContainer.addSubview(loadingIndicator)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            headerTitleLabel,
            profileButton,
            greetingLabel,
            balanceCard,
            ibanLabel,
            copyButton,
            balanceTitleLabel,
            balanceValueLabel,
            balanceCurrencyLabel,
            quickActionsStack,
            sectionTitleLabel,
            seeAllButton,
            tableView,
            loadingIndicator
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 288)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            contentContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            headerTitleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 12),
            headerTitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            headerTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: profileButton.leadingAnchor, constant: -16),

            profileButton.centerYAnchor.constraint(equalTo: headerTitleLabel.centerYAnchor),
            profileButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),
            profileButton.widthAnchor.constraint(equalToConstant: 42),
            profileButton.heightAnchor.constraint(equalToConstant: 42),

            greetingLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 36),
            greetingLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            greetingLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            balanceCard.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 26),
            balanceCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            balanceCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            balanceCard.heightAnchor.constraint(equalToConstant: 210),

            ibanLabel.topAnchor.constraint(equalTo: balanceCard.topAnchor, constant: 28),
            ibanLabel.leadingAnchor.constraint(equalTo: balanceCard.leadingAnchor, constant: 22),
            ibanLabel.trailingAnchor.constraint(lessThanOrEqualTo: copyButton.leadingAnchor, constant: -12),

            copyButton.trailingAnchor.constraint(equalTo: balanceCard.trailingAnchor, constant: -22),
            copyButton.centerYAnchor.constraint(equalTo: ibanLabel.centerYAnchor),
            copyButton.widthAnchor.constraint(equalToConstant: 24),
            copyButton.heightAnchor.constraint(equalToConstant: 24),

            balanceTitleLabel.topAnchor.constraint(equalTo: ibanLabel.bottomAnchor, constant: 14),
            balanceTitleLabel.leadingAnchor.constraint(equalTo: balanceCard.leadingAnchor, constant: 22),
            balanceTitleLabel.trailingAnchor.constraint(equalTo: balanceCard.trailingAnchor, constant: -22),

            balanceValueLabel.topAnchor.constraint(equalTo: balanceTitleLabel.bottomAnchor, constant: 28),
            balanceValueLabel.leadingAnchor.constraint(equalTo: balanceCard.leadingAnchor, constant: 28),

            balanceCurrencyLabel.leadingAnchor.constraint(equalTo: balanceValueLabel.trailingAnchor, constant: 8),
            balanceCurrencyLabel.bottomAnchor.constraint(equalTo: balanceValueLabel.bottomAnchor, constant: -6),

            quickActionsStack.topAnchor.constraint(equalTo: balanceCard.bottomAnchor, constant: 26),
            quickActionsStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 14),
            quickActionsStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -14),

            sectionTitleLabel.topAnchor.constraint(equalTo: quickActionsStack.bottomAnchor, constant: 30),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 14),

            seeAllButton.centerYAnchor.constraint(equalTo: sectionTitleLabel.centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),

            tableView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -20),

            loadingIndicator.centerXAnchor.constraint(equalTo: balanceCard.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: balanceCard.centerYAnchor)
        ])

        tableHeightConstraint?.isActive = true
    }

    func applyContent() {
        headerTitleLabel.text = headerTitleText
        balanceTitleLabel.text = balanceTitleText
        sectionTitleLabel.text = sectionTitleText
        seeAllButton.setTitle(seeAllText, for: .normal)
        greetingLabel.text = "Merhaba"
        ibanLabel.text = "-"
        balanceValueLabel.text = "0"
        balanceCurrencyLabel.text = "TL"

        quickActions.forEach { action in
            let control = DashboardQuickActionControl(item: action)
            control.addTarget(self, action: #selector(handleQuickActionTap(_:)), for: .touchUpInside)
            quickActionsStack.addArrangedSubview(control)
        }
    }

    @objc func handleQuickActionTap(_ sender: DashboardQuickActionControl) {
        onQuickActionTap?(sender.actionType)
    }

    func applyData(_ data: DashboardViewData) {
        greetingLabel.text = data.greetingText
        ibanLabel.text = data.ibanText
        balanceValueLabel.text = data.balanceText
        balanceCurrencyLabel.text = data.currencyText
        updateTransactionsHeight(count: data.previewTransactions.count)
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    func updateTransactionsHeight(count: Int) {
        tableHeightConstraint?.constant = count == 0 ? 0 : CGFloat(count) * 122
    }

    func applyCornerRadius() {
        profileButton.layer.cornerRadius = 12
        balanceCard.layer.cornerRadius = 28
    }
}
