import UIKit

class DashboardContentView: UIView {
    let tableView = UITableView(frame: .zero, style: .plain)
    let copyButton = UIButton(type: .system)
    let seeAllButton = UIButton(type: .system)
    var onQuickActionTap: ((DashboardQuickActionType) -> Void)?

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let headerTitleLabel = UILabel()
    private let greetingLabel = UILabel()
    private let balanceCard = UIView()
    private let ibanLabel = UILabel()
    private let balanceTitleLabel = UILabel()
    private let balanceAmountStack = UIStackView()
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
        .init(type: .investmentTrading, title: "YATIRIM İŞLEMİ", iconName: "chart.line.uptrend.xyaxis", isHighlighted: false),
        .init(type: .investmentPortfolio, title: "YATIRIM PORTFÖYÜ", iconName: "chart.pie", isHighlighted: false),
        .init(type: .analysis, title: "HARCAMA ANALİZİ", iconName: "chart.bar.horizontal.page", isHighlighted: false)
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
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        contentContainer.backgroundColor = AppColor.appBackground

        headerTitleLabel.textAlignment = .center
        headerTitleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        headerTitleLabel.textColor = AppColor.titleDark

        greetingLabel.font = .systemFont(ofSize: 32, weight: .bold)
        greetingLabel.textColor = AppColor.titleDark

        balanceCard.backgroundColor = AppColor.darkSurfaceAlt
        balanceCard.layer.shadowColor = UIColor.black.cgColor
        balanceCard.layer.shadowOpacity = 0.14
        balanceCard.layer.shadowRadius = 30
        balanceCard.layer.shadowOffset = CGSize(width: 0, height: 18)

        ibanLabel.font = .monospacedSystemFont(ofSize: 13, weight: .semibold)
        ibanLabel.textColor = AppColor.white62

        copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        copyButton.tintColor = AppColor.white70

        balanceTitleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        balanceTitleLabel.textColor = AppColor.white62
        balanceTitleLabel.numberOfLines = 1

        balanceAmountStack.axis = .horizontal
        balanceAmountStack.alignment = .lastBaseline
        balanceAmountStack.spacing = 8
        balanceAmountStack.distribution = .fill

        balanceValueLabel.font = .systemFont(ofSize: 42, weight: .bold)
        balanceValueLabel.textColor = AppColor.balanceDisplay
        balanceValueLabel.adjustsFontSizeToFitWidth = true
        balanceValueLabel.minimumScaleFactor = 0.55
        balanceValueLabel.lineBreakMode = .byClipping
        balanceValueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        balanceValueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        balanceCurrencyLabel.font = .systemFont(ofSize: 22, weight: .bold)
        balanceCurrencyLabel.textColor = AppColor.accentGold
        balanceCurrencyLabel.adjustsFontSizeToFitWidth = true
        balanceCurrencyLabel.minimumScaleFactor = 0.8
        balanceCurrencyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        balanceCurrencyLabel.setContentHuggingPriority(.required, for: .horizontal)

        quickActionsStack.axis = .horizontal
        quickActionsStack.alignment = .top
        quickActionsStack.distribution = .fillEqually
        quickActionsStack.spacing = 12

        sectionTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        sectionTitleLabel.textColor = AppColor.primaryText

        seeAllButton.setTitleColor(AppColor.accentOlive, for: .normal)
        seeAllButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = AppColor.primaryText

        tableView.backgroundColor = .clear
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
        contentContainer.addSubview(greetingLabel)
        contentContainer.addSubview(balanceCard)
        balanceCard.addSubview(ibanLabel)
        balanceCard.addSubview(copyButton)
        balanceCard.addSubview(balanceTitleLabel)
        balanceCard.addSubview(balanceAmountStack)
        balanceAmountStack.addArrangedSubview(balanceValueLabel)
        balanceAmountStack.addArrangedSubview(balanceCurrencyLabel)
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
            greetingLabel,
            balanceCard,
            ibanLabel,
            copyButton,
            balanceTitleLabel,
            balanceAmountStack,
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

            balanceAmountStack.topAnchor.constraint(equalTo: balanceTitleLabel.bottomAnchor, constant: 28),
            balanceAmountStack.leadingAnchor.constraint(equalTo: balanceCard.leadingAnchor, constant: 22),
            balanceAmountStack.trailingAnchor.constraint(lessThanOrEqualTo: balanceCard.trailingAnchor, constant: -22),
            balanceAmountStack.bottomAnchor.constraint(lessThanOrEqualTo: balanceCard.bottomAnchor, constant: -30),

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

    // controllerdan gelen veriyi basıyoruz
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
        let isEmpty = count == 0
        tableHeightConstraint?.constant = isEmpty ? 0 : CGFloat(count) * 122
        tableView.isHidden = isEmpty
        seeAllButton.isHidden = isEmpty
    }

    func applyCornerRadius() {
        balanceCard.layer.cornerRadius = 28
    }
}
