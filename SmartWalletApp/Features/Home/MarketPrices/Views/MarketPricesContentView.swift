import UIKit

final class MarketPricesContentView: UIView {
    let tradeButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let headerTitleLabel = UILabel()
    private let headerSubtitleLabel = UILabel()
    private let tableCard = UIView()
    private let tableTitleLabel = UILabel()
    private let tableHeaderStack = UIStackView()
    private let rowsStack = UIStackView()
    private let emptyStateView = EmptyStateView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableCard.layer.cornerRadius = 22
        tradeButton.layer.cornerRadius = tradeButton.bounds.height / 2
    }
}

extension MarketPricesContentView {
    func setRefreshControl(_ refreshControl: UIRefreshControl) {
        scrollView.refreshControl = refreshControl
    }

    // veri apply 
    func apply(_ data: MarketPricesViewData) {
        headerTitleLabel.text = data.titleText

        let isEmpty = data.emptyMessageText != nil
        tableCard.isHidden = isEmpty
        tradeButton.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
        if let message = data.emptyMessageText {
            emptyStateView.configure(
                title: "Henüz piyasa verisi yok",
                message: message,
                systemImageName: "chart.line.downtrend.xyaxis"
            )
        }

        rowsStack.arrangedSubviews.forEach {
            rowsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        data.items.enumerated().forEach { index, item in
            let row = MarketPriceRowView()
            row.configure(with: item, showsSeparator: index < data.items.count - 1)
            rowsStack.addArrangedSubview(row)
        }
    }
}

 extension MarketPricesContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        headerTitleLabel.text = "Piyasalar"
        headerTitleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        headerTitleLabel.textColor = AppColor.primaryText

        headerSubtitleLabel.text = "Güncel alış ve satış fiyatları"
        headerSubtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        headerSubtitleLabel.textColor = AppColor.secondaryText

        tableCard.backgroundColor = AppColor.whitePrimary
        tableCard.layer.shadowColor = UIColor.black.cgColor
        tableCard.layer.shadowOpacity = 0.06
        tableCard.layer.shadowRadius = 18
        tableCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        tableTitleLabel.text = "Piyasa Tablosu"
        tableTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        tableTitleLabel.textColor = AppColor.primaryText

        tableHeaderStack.axis = .horizontal
        tableHeaderStack.spacing = 10

        rowsStack.axis = .vertical
        rowsStack.spacing = 0

        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.title = "Döviz Al / Sat"
        buttonConfiguration.baseBackgroundColor = AppColor.surfaceWarmSoft
        buttonConfiguration.baseForegroundColor = AppColor.accentOlive
        buttonConfiguration.cornerStyle = .capsule
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 14, bottom: 9, trailing: 14)
        tradeButton.configuration = buttonConfiguration
        tradeButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)

        emptyStateView.isHidden = true

        configureTableHeader()
    }

    func configureTableHeader() {
        [
            makeHeaderLabel("Varlık", alignment: .left, width: 102),
            makeHeaderLabel("Alış", alignment: .right, width: 68),
            makeHeaderLabel("Satış", alignment: .right, width: 68),
            makeHeaderLabel("Günlük", alignment: .center, width: nil)
        ].forEach(tableHeaderStack.addArrangedSubview)
    }

    func makeHeaderLabel(_ text: String, alignment: NSTextAlignment, width: CGFloat?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = AppColor.secondaryText
        label.textAlignment = alignment

        if let width {
            label.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        return label
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [headerTitleLabel, headerSubtitleLabel, tradeButton, tableCard, emptyStateView].forEach(contentContainer.addSubview)
        [tableTitleLabel, tableHeaderStack, rowsStack].forEach(tableCard.addSubview)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            headerTitleLabel,
            headerSubtitleLabel,
            tableCard,
            tableTitleLabel,
            tableHeaderStack,
            rowsStack,
            tradeButton,
            emptyStateView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

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

            headerTitleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 18),
            headerTitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),

            headerSubtitleLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 6),
            headerSubtitleLabel.leadingAnchor.constraint(equalTo: headerTitleLabel.leadingAnchor),
            headerSubtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: tradeButton.leadingAnchor, constant: -16),

            tradeButton.centerYAnchor.constraint(equalTo: headerTitleLabel.centerYAnchor),
            tradeButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),
            tradeButton.leadingAnchor.constraint(greaterThanOrEqualTo: headerTitleLabel.trailingAnchor, constant: 12),

            tableCard.topAnchor.constraint(equalTo: headerSubtitleLabel.bottomAnchor, constant: 28),
            tableCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            tableCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            tableTitleLabel.topAnchor.constraint(equalTo: tableCard.topAnchor, constant: 18),
            tableTitleLabel.leadingAnchor.constraint(equalTo: tableCard.leadingAnchor, constant: 16),
            tableTitleLabel.trailingAnchor.constraint(equalTo: tableCard.trailingAnchor, constant: -16),

            tableHeaderStack.topAnchor.constraint(equalTo: tableTitleLabel.bottomAnchor, constant: 18),
            tableHeaderStack.leadingAnchor.constraint(equalTo: tableCard.leadingAnchor, constant: 16),
            tableHeaderStack.trailingAnchor.constraint(equalTo: tableCard.trailingAnchor, constant: -14),

            rowsStack.topAnchor.constraint(equalTo: tableHeaderStack.bottomAnchor, constant: 8),
            rowsStack.leadingAnchor.constraint(equalTo: tableCard.leadingAnchor),
            rowsStack.trailingAnchor.constraint(equalTo: tableCard.trailingAnchor),
            rowsStack.bottomAnchor.constraint(equalTo: tableCard.bottomAnchor, constant: -8),

            tableCard.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -32),

            emptyStateView.topAnchor.constraint(equalTo: headerSubtitleLabel.bottomAnchor, constant: 64),
            emptyStateView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            emptyStateView.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -32)
        ])
    }
}
