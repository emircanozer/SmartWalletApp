import UIKit

final class InvestmentTradeSuccessContentView: UIView {
    let closeButton = UIButton(type: .system)
    let primaryButton = UIButton(type: .system)
    let secondaryButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let headerTitleLabel = UILabel()
    private let successImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let detailCard = UIView()
    private let assetTitleLabel = UILabel()
    private let assetValueLabel = UILabel()
    private let directionTitleLabel = UILabel()
    private let directionValueLabel = UILabel()
    private let topDividerView = UIView()
    private let amountTitleLabel = UILabel()
    private let amountValueLabel = UILabel()
    private let totalTitleLabel = UILabel()
    private let totalValueLabel = UILabel()
    private let balanceContainerView = UIView()
    private let balanceTitleLabel = UILabel()
    private let balanceValueLabel = UILabel()
    private let statusPillView = UIView()
    private let statusDotView = UIView()
    private let statusLabel = UILabel()

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
        detailCard.layer.cornerRadius = 24
        balanceContainerView.layer.cornerRadius = 16
        statusPillView.layer.cornerRadius = 16
        statusDotView.layer.cornerRadius = 4
        [primaryButton, secondaryButton].forEach { $0.layer.cornerRadius = 20 }
    }
}

extension InvestmentTradeSuccessContentView {
    func apply(_ data: InvestmentTradeSuccessViewData) {
        headerTitleLabel.text = "İşlem Detayı"
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText
        assetValueLabel.text = data.assetTitleText
        directionValueLabel.text = data.directionText
        amountValueLabel.text = data.amountText
        totalValueLabel.text = data.totalAmountText
        balanceValueLabel.text = data.resultingBalanceText
        statusLabel.text = data.statusPillText
        primaryButton.setTitle(data.primaryButtonTitle, for: .normal)
        secondaryButton.setTitle(data.secondaryButtonTitle, for: .normal)
    }
}

 extension InvestmentTradeSuccessContentView {
    func configureView() {
        backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = AppColor.secondaryText

        headerTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        headerTitleLabel.textColor = AppColor.primaryText
        headerTitleLabel.textAlignment = .center

        successImageView.image = UIImage(named: "success2")
        successImageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        subtitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        detailCard.backgroundColor = .white
        detailCard.layer.shadowColor = UIColor.black.cgColor
        detailCard.layer.shadowOpacity = 0.05
        detailCard.layer.shadowRadius = 18
        detailCard.layer.shadowOffset = CGSize(width: 0, height: 10)

        [assetTitleLabel, directionTitleLabel, amountTitleLabel, totalTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 11, weight: .bold)
            $0.textColor = AppColor.secondaryText
        }

        [assetValueLabel, directionValueLabel, amountValueLabel, totalValueLabel].forEach {
            $0.font = .systemFont(ofSize: 18, weight: .bold)
            $0.textColor = AppColor.primaryText
            $0.numberOfLines = 2
        }

        directionValueLabel.textAlignment = .right
        totalValueLabel.textAlignment = .right

        topDividerView.backgroundColor = AppColor.divider

        balanceContainerView.backgroundColor = AppColor.surfaceMuted
        balanceTitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        balanceTitleLabel.textColor = AppColor.secondaryText
        balanceTitleLabel.text = "İşlem sonrası bakiye"

        balanceValueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        balanceValueLabel.textColor = AppColor.primaryText
        balanceValueLabel.textAlignment = .right

        statusPillView.backgroundColor = .white
        statusPillView.layer.borderWidth = 1
        statusPillView.layer.borderColor = AppColor.borderSoft.cgColor

        statusDotView.backgroundColor = AppColor.successStrong

        statusLabel.font = .systemFont(ofSize: 12, weight: .bold)
        statusLabel.textColor = AppColor.secondaryText

        var primaryConfiguration = UIButton.Configuration.filled()
        primaryConfiguration.baseBackgroundColor = AppColor.primaryYellow
        primaryConfiguration.baseForegroundColor = AppColor.primaryText
        primaryConfiguration.cornerStyle = .capsule
        primaryConfiguration.image = UIImage(systemName: "arrow.right")
        primaryConfiguration.imagePlacement = .trailing
        primaryConfiguration.imagePadding = 10
        primaryConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 24, bottom: 17, trailing: 24)
        primaryButton.configuration = primaryConfiguration
        primaryButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        var secondaryConfiguration = UIButton.Configuration.filled()
        secondaryConfiguration.baseBackgroundColor = .white
        secondaryConfiguration.baseForegroundColor = AppColor.primaryText
        secondaryConfiguration.cornerStyle = .capsule
        secondaryConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 24, bottom: 17, trailing: 24)
        secondaryButton.configuration = secondaryConfiguration
        secondaryButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [closeButton, headerTitleLabel, successImageView, titleLabel, subtitleLabel, detailCard, statusPillView, primaryButton, secondaryButton].forEach(contentContainer.addSubview)
        [assetTitleLabel, assetValueLabel, directionTitleLabel, directionValueLabel, topDividerView, amountTitleLabel, amountValueLabel, totalTitleLabel, totalValueLabel, balanceContainerView].forEach(detailCard.addSubview)
        [balanceTitleLabel, balanceValueLabel].forEach(balanceContainerView.addSubview)
        [statusDotView, statusLabel].forEach(statusPillView.addSubview)
    }

    func setupLayout() {
        [
            scrollView, contentContainer, closeButton, headerTitleLabel, successImageView,
            titleLabel, subtitleLabel, detailCard, assetTitleLabel, assetValueLabel, directionTitleLabel,
            directionValueLabel, topDividerView, amountTitleLabel, amountValueLabel, totalTitleLabel,
            totalValueLabel, balanceContainerView, balanceTitleLabel, balanceValueLabel, statusPillView,
            statusDotView, statusLabel, primaryButton, secondaryButton
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

            closeButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 8),
            closeButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28),

            headerTitleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            headerTitleLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),

            successImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            successImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            successImageView.widthAnchor.constraint(equalToConstant: 100),
            successImageView.heightAnchor.constraint(equalToConstant: 140),

            titleLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -28),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 42),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -42),

            detailCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28),
            detailCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            detailCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            assetTitleLabel.topAnchor.constraint(equalTo: detailCard.topAnchor, constant: 20),
            assetTitleLabel.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor, constant: 20),

            directionTitleLabel.topAnchor.constraint(equalTo: detailCard.topAnchor, constant: 20),
            directionTitleLabel.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor, constant: -20),

            assetValueLabel.topAnchor.constraint(equalTo: assetTitleLabel.bottomAnchor, constant: 6),
            assetValueLabel.leadingAnchor.constraint(equalTo: assetTitleLabel.leadingAnchor),
            assetValueLabel.trailingAnchor.constraint(equalTo: detailCard.centerXAnchor, constant: -8),

            directionValueLabel.topAnchor.constraint(equalTo: directionTitleLabel.bottomAnchor, constant: 6),
            directionValueLabel.leadingAnchor.constraint(equalTo: detailCard.centerXAnchor, constant: 8),
            directionValueLabel.trailingAnchor.constraint(equalTo: directionTitleLabel.trailingAnchor),

            topDividerView.topAnchor.constraint(equalTo: assetValueLabel.bottomAnchor, constant: 18),
            topDividerView.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor, constant: 20),
            topDividerView.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor, constant: -20),
            topDividerView.heightAnchor.constraint(equalToConstant: 1),

            amountTitleLabel.topAnchor.constraint(equalTo: topDividerView.bottomAnchor, constant: 18),
            amountTitleLabel.leadingAnchor.constraint(equalTo: assetTitleLabel.leadingAnchor),

            totalTitleLabel.topAnchor.constraint(equalTo: topDividerView.bottomAnchor, constant: 18),
            totalTitleLabel.trailingAnchor.constraint(equalTo: directionTitleLabel.trailingAnchor),

            amountValueLabel.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor, constant: 6),
            amountValueLabel.leadingAnchor.constraint(equalTo: amountTitleLabel.leadingAnchor),
            amountValueLabel.trailingAnchor.constraint(equalTo: detailCard.centerXAnchor, constant: -8),

            totalValueLabel.topAnchor.constraint(equalTo: totalTitleLabel.bottomAnchor, constant: 6),
            totalValueLabel.leadingAnchor.constraint(equalTo: detailCard.centerXAnchor, constant: 8),
            totalValueLabel.trailingAnchor.constraint(equalTo: totalTitleLabel.trailingAnchor),

            balanceContainerView.topAnchor.constraint(equalTo: amountValueLabel.bottomAnchor, constant: 24),
            balanceContainerView.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor, constant: 20),
            balanceContainerView.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor, constant: -20),
            balanceContainerView.bottomAnchor.constraint(equalTo: detailCard.bottomAnchor, constant: -20),

            balanceTitleLabel.topAnchor.constraint(equalTo: balanceContainerView.topAnchor, constant: 14),
            balanceTitleLabel.leadingAnchor.constraint(equalTo: balanceContainerView.leadingAnchor, constant: 14),
            balanceTitleLabel.bottomAnchor.constraint(equalTo: balanceContainerView.bottomAnchor, constant: -14),

            balanceValueLabel.centerYAnchor.constraint(equalTo: balanceTitleLabel.centerYAnchor),
            balanceValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: balanceTitleLabel.trailingAnchor, constant: 12),
            balanceValueLabel.trailingAnchor.constraint(equalTo: balanceContainerView.trailingAnchor, constant: -14),

            statusPillView.topAnchor.constraint(equalTo: detailCard.bottomAnchor, constant: 24),
            statusPillView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),

            statusDotView.leadingAnchor.constraint(equalTo: statusPillView.leadingAnchor, constant: 12),
            statusDotView.centerYAnchor.constraint(equalTo: statusPillView.centerYAnchor),
            statusDotView.widthAnchor.constraint(equalToConstant: 8),
            statusDotView.heightAnchor.constraint(equalToConstant: 8),

            statusLabel.topAnchor.constraint(equalTo: statusPillView.topAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: statusDotView.trailingAnchor, constant: 8),
            statusLabel.trailingAnchor.constraint(equalTo: statusPillView.trailingAnchor, constant: -12),
            statusLabel.bottomAnchor.constraint(equalTo: statusPillView.bottomAnchor, constant: -8),

            primaryButton.topAnchor.constraint(equalTo: statusPillView.bottomAnchor, constant: 28),
            primaryButton.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor),
            primaryButton.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor),
            primaryButton.heightAnchor.constraint(equalToConstant: 56),

            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: 16),
            secondaryButton.leadingAnchor.constraint(equalTo: primaryButton.leadingAnchor),
            secondaryButton.trailingAnchor.constraint(equalTo: primaryButton.trailingAnchor),
            secondaryButton.heightAnchor.constraint(equalToConstant: 56),
            secondaryButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -28)
        ])
    }
}
