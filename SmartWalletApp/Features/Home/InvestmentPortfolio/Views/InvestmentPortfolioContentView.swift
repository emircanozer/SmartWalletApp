import UIKit

final class InvestmentPortfolioContentView: UIView {
    let backButton = UIButton(type: .system)
    let tradeButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let headerTitleLabel = UILabel()
    private let summaryCard = UIView()
    private let summaryTitleLabel = UILabel()
    private let totalValueLabel = UILabel()
    private let profitLossLabel = UILabel()
    private let profitLossDetailLabel = UILabel()
    private let summaryDivider = UIView()
    private let dominantShareLabel = UILabel()
    private let allocationTitleLabel = UILabel()
    private let allocationStack = UIStackView()
    private let assetsTitleLabel = UILabel()
    private let assetsCard = UIView()
    private let assetsScrollView = UIScrollView()
    private let assetsStack = UIStackView()
    private let emptyStateView = EmptyStateView()
    private var assetListHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
        applyStaticContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        summaryCard.layer.cornerRadius = 28
        assetsCard.layer.cornerRadius = 22
    }
}

extension InvestmentPortfolioContentView {
    func setRefreshControl(_ refreshControl: UIRefreshControl) {
        scrollView.refreshControl = refreshControl
    }

    // en önemli kısmı 
    func apply(_ data: InvestmentPortfolioViewData) {
        headerTitleLabel.text = data.titleText
        totalValueLabel.text = data.totalPortfolioValueText
        profitLossLabel.text = data.totalProfitLossText
        profitLossLabel.textColor = data.isProfit ? AppColor.accentGold : UIColor(red: 0.98, green: 0.78, blue: 0.52, alpha: 1.0)
        profitLossDetailLabel.text = data.totalProfitLossDetailText
        dominantShareLabel.text = data.dominantShareText

        let isEmpty = data.emptyMessageText != nil
        summaryCard.isHidden = isEmpty
        allocationTitleLabel.isHidden = isEmpty
        allocationStack.isHidden = isEmpty
        assetsTitleLabel.isHidden = isEmpty
        assetsCard.isHidden = isEmpty
        tradeButton.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
        if let message = data.emptyMessageText {
            emptyStateView.configure(
                title: "Henüz yatırım varlığınız yok",
                message: message,
                systemImageName: "briefcase"
            )
        }

        allocationStack.arrangedSubviews.forEach {
            allocationStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        data.allocationItems.forEach { item in
            let row = InvestmentPortfolioAllocationRowView()
            row.configure(with: item)
            allocationStack.addArrangedSubview(row)
        }

        assetsStack.arrangedSubviews.forEach {
            assetsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        data.assetItems.forEach { item in
            let row = InvestmentPortfolioAssetRowView()
            row.configure(with: item)
            assetsStack.addArrangedSubview(row)
        }

        let contentHeight = CGFloat(data.assetItems.count) * 108
        assetListHeightConstraint?.constant = min(max(contentHeight, 108), 360)
        assetsScrollView.isScrollEnabled = contentHeight > 360
    }

    private func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint

        headerTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        headerTitleLabel.textColor = AppColor.accentOlive

        summaryCard.backgroundColor = AppColor.darkSurfaceAlt
        summaryCard.layer.shadowColor = UIColor.black.cgColor
        summaryCard.layer.shadowOpacity = 0.14
        summaryCard.layer.shadowRadius = 28
        summaryCard.layer.shadowOffset = CGSize(width: 0, height: 12)

        summaryTitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        summaryTitleLabel.textColor = AppColor.white62

        totalValueLabel.font = .systemFont(ofSize: 42, weight: .bold)
        totalValueLabel.textColor = .white

        profitLossLabel.font = .systemFont(ofSize: 18, weight: .bold)
        profitLossDetailLabel.font = .systemFont(ofSize: 14, weight: .medium)
        profitLossDetailLabel.textColor = AppColor.white62

        summaryDivider.backgroundColor = UIColor.white.withAlphaComponent(0.12)

        dominantShareLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        dominantShareLabel.textColor = AppColor.white70

        allocationTitleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        allocationTitleLabel.textColor = AppColor.primaryText

        allocationStack.axis = .vertical
        allocationStack.spacing = 18

        assetsTitleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        assetsTitleLabel.textColor = AppColor.primaryText

        assetsCard.backgroundColor = AppColor.whitePrimary
        assetsCard.layer.shadowColor = UIColor.black.cgColor
        assetsCard.layer.shadowOpacity = 0.06
        assetsCard.layer.shadowRadius = 18
        assetsCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        tradeButton.setTitle("AL / SAT", for: .normal)
        tradeButton.setTitleColor(AppColor.accentOlive, for: .normal)
        tradeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        tradeButton.contentHorizontalAlignment = .center

        assetsScrollView.showsVerticalScrollIndicator = false
        assetsScrollView.alwaysBounceVertical = true

        assetsStack.axis = .vertical
        assetsStack.spacing = 14

        emptyStateView.isHidden = true
    }

    private func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            headerTitleLabel,
            summaryCard,
            allocationTitleLabel,
            allocationStack,
            assetsTitleLabel,
            assetsCard,
            tradeButton,
            emptyStateView
        ].forEach(contentContainer.addSubview)

        [
            summaryTitleLabel,
            totalValueLabel,
            profitLossLabel,
            profitLossDetailLabel,
            summaryDivider,
            dominantShareLabel
        ].forEach(summaryCard.addSubview)

        assetsCard.addSubview(assetsScrollView)
        assetsScrollView.addSubview(assetsStack)
    }

    private func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            headerTitleLabel,
            summaryCard,
            summaryTitleLabel,
            totalValueLabel,
            profitLossLabel,
            profitLossDetailLabel,
            summaryDivider,
            dominantShareLabel,
            allocationTitleLabel,
            allocationStack,
            assetsTitleLabel,
            assetsCard,
            tradeButton,
            assetsScrollView,
            assetsStack,
            emptyStateView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        assetListHeightConstraint = assetsScrollView.heightAnchor.constraint(equalToConstant: 108)

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

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 28),

            headerTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            headerTitleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),

            summaryCard.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            summaryCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            summaryCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            summaryTitleLabel.topAnchor.constraint(equalTo: summaryCard.topAnchor, constant: 20),
            summaryTitleLabel.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 18),
            summaryTitleLabel.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -18),

            totalValueLabel.topAnchor.constraint(equalTo: summaryTitleLabel.bottomAnchor, constant: 8),
            totalValueLabel.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 18),
            totalValueLabel.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -18),

            profitLossLabel.topAnchor.constraint(equalTo: totalValueLabel.bottomAnchor, constant: 10),
            profitLossLabel.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 18),

            profitLossDetailLabel.firstBaselineAnchor.constraint(equalTo: profitLossLabel.firstBaselineAnchor),
            profitLossDetailLabel.leadingAnchor.constraint(equalTo: profitLossLabel.trailingAnchor, constant: 8),
            profitLossDetailLabel.trailingAnchor.constraint(lessThanOrEqualTo: summaryCard.trailingAnchor, constant: -18),

            summaryDivider.topAnchor.constraint(equalTo: profitLossLabel.bottomAnchor, constant: 18),
            summaryDivider.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 18),
            summaryDivider.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -18),
            summaryDivider.heightAnchor.constraint(equalToConstant: 1),

            dominantShareLabel.topAnchor.constraint(equalTo: summaryDivider.bottomAnchor, constant: 18),
            dominantShareLabel.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 18),
            dominantShareLabel.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -18),
            dominantShareLabel.bottomAnchor.constraint(equalTo: summaryCard.bottomAnchor, constant: -20),

            allocationTitleLabel.topAnchor.constraint(equalTo: summaryCard.bottomAnchor, constant: 30),
            allocationTitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            allocationTitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            allocationStack.topAnchor.constraint(equalTo: allocationTitleLabel.bottomAnchor, constant: 20),
            allocationStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            allocationStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            assetsTitleLabel.topAnchor.constraint(equalTo: allocationStack.bottomAnchor, constant: 28),
            assetsTitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            assetsTitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            assetsCard.topAnchor.constraint(equalTo: assetsTitleLabel.bottomAnchor, constant: 16),
            assetsCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            assetsCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            
            tradeButton.topAnchor.constraint(equalTo: assetsCard.bottomAnchor, constant: 18),
            tradeButton.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            tradeButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -24),

            assetsScrollView.topAnchor.constraint(equalTo: assetsCard.topAnchor, constant: 16),
            assetsScrollView.leadingAnchor.constraint(equalTo: assetsCard.leadingAnchor, constant: 16),
            assetsScrollView.trailingAnchor.constraint(equalTo: assetsCard.trailingAnchor, constant: -16),
            assetsScrollView.bottomAnchor.constraint(equalTo: assetsCard.bottomAnchor, constant: -16),

            assetsStack.topAnchor.constraint(equalTo: assetsScrollView.contentLayoutGuide.topAnchor),
            assetsStack.leadingAnchor.constraint(equalTo: assetsScrollView.contentLayoutGuide.leadingAnchor),
            assetsStack.trailingAnchor.constraint(equalTo: assetsScrollView.contentLayoutGuide.trailingAnchor),
            assetsStack.bottomAnchor.constraint(equalTo: assetsScrollView.contentLayoutGuide.bottomAnchor),
            assetsStack.widthAnchor.constraint(equalTo: assetsScrollView.frameLayoutGuide.widthAnchor),

            emptyStateView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 36),
            emptyStateView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            emptyStateView.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -40)
        ])

        assetListHeightConstraint?.isActive = true
    }

    private func applyStaticContent() {
        summaryTitleLabel.text = "Toplam Portföy Değeri"
        allocationTitleLabel.text = "Portföy Dağılımı"
        assetsTitleLabel.text = "Varlıklarım"
        headerTitleLabel.text = "Ana Sayfaya Dön"
    }
}
