import UIKit

final class InvestmentTradingContentView: UIView {
    let backButton = UIButton(type: .system)
    let actionButton = UIButton(type: .system)
    let amountTextField = UITextField()
    let amountUnitButton = UIButton(type: .system)
    let assetChipsView = InvestmentTradingAssetChipsView()
    let directionSegmentView = InvestmentTradingDirectionSegmentView()
    let quickAmountChipsView = InvestmentTradingQuickAmountChipsView()

    // ayrı ayrı tanımladığımız custom viewları burada toparladık
    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let priceCard = UIView()
    private let amountCard = UIView()
    private let summaryCard = UIView()
    private let validationLabel = UILabel()
    private let amountTitleLabel = UILabel()
    private let dividerView = UIView()
    private let summaryDividerView = UIView()
    private let estimateTitleLabel = UILabel()
    private let estimateValueLabel = UILabel()
    private let buyPriceMetricView = TradingMetricView()
    private let sellPriceMetricView = TradingMetricView()
    private let balanceMetricView = TradingMetricView()
    private let holdingMetricView = TradingMetricView()
    private let summaryStack = UIStackView()
    private let keyboardTapGesture = UITapGestureRecognizer()
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
        [priceCard, amountCard, summaryCard].forEach {
            $0.layer.cornerRadius = 22
        }
        actionButton.layer.cornerRadius = 20
    }
}

extension InvestmentTradingContentView {
    func setRefreshControl(_ refreshControl: UIRefreshControl) {
        scrollView.refreshControl = refreshControl
    }

    func apply(_ data: InvestmentTradingViewData) {
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText

        // chip item custom view oldu 
        assetChipsView.configure(with: data.assetItems)
        directionSegmentView.configure(selectedDirection: data.selectedDirection)

        buyPriceMetricView.configure(title: "ALIŞ FİYATI", value: data.buyPriceText, accentColor: AppColor.primaryText)
        sellPriceMetricView.configure(title: "SATIŞ FİYATI", value: data.sellPriceText, accentColor: AppColor.primaryText)
        balanceMetricView.configure(title: "KULLANILABİLİR BAKİYE", value: data.balanceText, accentColor: AppColor.accentOlive)
        holdingMetricView.configure(title: "VARLIK MİKTARI", value: data.holdingText, accentColor: AppColor.primaryText)

        amountTextField.text = data.amountText
        amountTitleLabel.text = data.amountTitleText
        amountTextField.placeholder = data.amountPlaceholderText
        amountUnitButton.setTitle(data.amountUnitText, for: .normal)

        quickAmountChipsView.configure(with: data.quickAmountItems)

        summaryStack.arrangedSubviews.forEach {
            summaryStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        data.summaryRows.forEach { item in
            let row = SummaryRowView()
            row.configure(title: item.title, value: item.value)
            summaryStack.addArrangedSubview(row)
        }

        estimateTitleLabel.text = data.estimateTitleText
        estimateValueLabel.text = data.estimateValueText

        actionButton.setTitle(data.actionButtonTitle, for: .normal)
        actionButton.isEnabled = data.isActionEnabled
        actionButton.alpha = data.isActionEnabled ? 1.0 : 0.55
        validationLabel.text = data.validationMessageText
        validationLabel.isHidden = data.validationMessageText == nil

        let isEmpty = data.emptyMessageText != nil
        [assetChipsView, directionSegmentView, priceCard, amountCard, summaryCard, quickAmountChipsView, actionButton, validationLabel].forEach {
            $0.isHidden = isEmpty
        }
        emptyStateView.isHidden = !isEmpty
        if let message = data.emptyMessageText {
            emptyStateView.configure(
                title: "İşlem verileri hazır değil",
                message: message,
                systemImageName: "chart.line.uptrend.xyaxis.circle"
            )
        }
    }

    func setBottomInset(_ inset: CGFloat) {
        scrollView.contentInset.bottom = inset
        scrollView.verticalScrollIndicatorInsets.bottom = inset
    }

    func dismissKeyboard() {
        endEditing(true)
    }
}

 extension InvestmentTradingContentView {
    func configureView() {
        backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive

        keyboardTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        keyboardTapGesture.cancelsTouchesInView = false
        addGestureRecognizer(keyboardTapGesture)

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.numberOfLines = 2

        [priceCard, amountCard, summaryCard].forEach {
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.06
            $0.layer.shadowRadius = 18
            $0.layer.shadowOffset = CGSize(width: 0, height: 8)
        }

        amountTitleLabel.text = "MİKTAR GİRİNİZ"
        amountTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        amountTitleLabel.textColor = AppColor.fieldTitleText

        amountTextField.font = .systemFont(ofSize: 38, weight: .bold)
        amountTextField.textColor = AppColor.primaryText
        amountTextField.keyboardType = .decimalPad
        amountTextField.borderStyle = .none

        var amountUnitConfiguration = UIButton.Configuration.plain()
        amountUnitConfiguration.image = UIImage(systemName: "chevron.down")
        amountUnitConfiguration.imagePlacement = .trailing
        amountUnitConfiguration.imagePadding = 6
        amountUnitButton.configuration = amountUnitConfiguration
        amountUnitButton.setTitleColor(AppColor.accentOlive, for: .normal)
        amountUnitButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        amountUnitButton.contentHorizontalAlignment = .trailing

        dividerView.backgroundColor = AppColor.divider
        summaryDividerView.backgroundColor = AppColor.divider

        summaryStack.axis = .vertical
        summaryStack.spacing = 14

        estimateTitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        estimateTitleLabel.textColor = AppColor.accentOlive

        estimateValueLabel.font = .systemFont(ofSize: 18, weight: .bold)
        estimateValueLabel.textColor = AppColor.accentOlive
        estimateValueLabel.textAlignment = .right
        estimateValueLabel.adjustsFontSizeToFitWidth = true
        estimateValueLabel.minimumScaleFactor = 0.75
        estimateValueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        var actionConfiguration = UIButton.Configuration.filled()
        actionConfiguration.baseBackgroundColor = AppColor.primaryYellow
        actionConfiguration.baseForegroundColor = AppColor.primaryText
        actionConfiguration.cornerStyle = .capsule
        actionConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 24, bottom: 17, trailing: 24)
        actionButton.configuration = actionConfiguration
        actionButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)

        validationLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        validationLabel.textColor = AppColor.dangerStrong
        validationLabel.numberOfLines = 0
        validationLabel.textAlignment = .center
        validationLabel.isHidden = true

        emptyStateView.isHidden = true
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            titleLabel,
            subtitleLabel,
            assetChipsView,
            directionSegmentView,
            priceCard,
            amountCard,
            quickAmountChipsView,
            summaryCard,
            actionButton,
            validationLabel,
            emptyStateView
        ].forEach(contentContainer.addSubview)

        [buyPriceMetricView, sellPriceMetricView, balanceMetricView, holdingMetricView].forEach(priceCard.addSubview)

        [amountTitleLabel, amountTextField, amountUnitButton, dividerView].forEach(amountCard.addSubview)

        [summaryStack, summaryDividerView, estimateTitleLabel, estimateValueLabel].forEach(summaryCard.addSubview)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            titleLabel,
            subtitleLabel,
            assetChipsView,
            directionSegmentView,
            priceCard,
            amountCard,
            quickAmountChipsView,
            summaryCard,
            actionButton,
            validationLabel,
            emptyStateView,
            buyPriceMetricView,
            sellPriceMetricView,
            balanceMetricView,
            holdingMetricView,
            amountTitleLabel,
            amountTextField,
            amountUnitButton,
            dividerView,
            summaryStack,
            summaryDividerView,
            estimateTitleLabel,
            estimateValueLabel
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

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            assetChipsView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 22),
            assetChipsView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            assetChipsView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            assetChipsView.heightAnchor.constraint(equalToConstant: 44),

            directionSegmentView.topAnchor.constraint(equalTo: assetChipsView.bottomAnchor, constant: 18),
            directionSegmentView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            directionSegmentView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            priceCard.topAnchor.constraint(equalTo: directionSegmentView.bottomAnchor, constant: 18),
            priceCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            priceCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            buyPriceMetricView.topAnchor.constraint(equalTo: priceCard.topAnchor, constant: 18),
            buyPriceMetricView.leadingAnchor.constraint(equalTo: priceCard.leadingAnchor, constant: 18),
            buyPriceMetricView.trailingAnchor.constraint(equalTo: priceCard.centerXAnchor, constant: -8),

            sellPriceMetricView.topAnchor.constraint(equalTo: priceCard.topAnchor, constant: 18),
            sellPriceMetricView.leadingAnchor.constraint(equalTo: priceCard.centerXAnchor, constant: 8),
            sellPriceMetricView.trailingAnchor.constraint(equalTo: priceCard.trailingAnchor, constant: -18),

            balanceMetricView.topAnchor.constraint(equalTo: buyPriceMetricView.bottomAnchor, constant: 18),
            balanceMetricView.leadingAnchor.constraint(equalTo: priceCard.leadingAnchor, constant: 18),
            balanceMetricView.trailingAnchor.constraint(equalTo: priceCard.centerXAnchor, constant: -8),
            balanceMetricView.bottomAnchor.constraint(equalTo: priceCard.bottomAnchor, constant: -18),

            holdingMetricView.topAnchor.constraint(equalTo: sellPriceMetricView.bottomAnchor, constant: 18),
            holdingMetricView.leadingAnchor.constraint(equalTo: priceCard.centerXAnchor, constant: 8),
            holdingMetricView.trailingAnchor.constraint(equalTo: priceCard.trailingAnchor, constant: -18),
            holdingMetricView.bottomAnchor.constraint(equalTo: priceCard.bottomAnchor, constant: -18),

            amountCard.topAnchor.constraint(equalTo: priceCard.bottomAnchor, constant: 18),
            amountCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            amountCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            amountTitleLabel.topAnchor.constraint(equalTo: amountCard.topAnchor, constant: 18),
            amountTitleLabel.leadingAnchor.constraint(equalTo: amountCard.leadingAnchor, constant: 18),
            amountTitleLabel.trailingAnchor.constraint(equalTo: amountCard.trailingAnchor, constant: -18),

            amountTextField.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor, constant: 16),
            amountTextField.leadingAnchor.constraint(equalTo: amountCard.leadingAnchor, constant: 18),
            amountTextField.trailingAnchor.constraint(lessThanOrEqualTo: amountUnitButton.leadingAnchor, constant: -12),
            amountTextField.bottomAnchor.constraint(equalTo: amountCard.bottomAnchor, constant: -18),

            amountUnitButton.trailingAnchor.constraint(equalTo: amountCard.trailingAnchor, constant: -18),
            amountUnitButton.centerYAnchor.constraint(equalTo: amountTextField.centerYAnchor),
            amountUnitButton.leadingAnchor.constraint(greaterThanOrEqualTo: amountTextField.trailingAnchor, constant: 8),

            dividerView.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor, constant: 12),
            dividerView.leadingAnchor.constraint(equalTo: amountCard.leadingAnchor, constant: 18),
            dividerView.trailingAnchor.constraint(equalTo: amountCard.trailingAnchor, constant: -18),
            dividerView.heightAnchor.constraint(equalToConstant: 1),

            quickAmountChipsView.topAnchor.constraint(equalTo: amountCard.bottomAnchor, constant: 14),
            quickAmountChipsView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            quickAmountChipsView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            summaryCard.topAnchor.constraint(equalTo: quickAmountChipsView.bottomAnchor, constant: 16),
            summaryCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            summaryCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            summaryStack.topAnchor.constraint(equalTo: summaryCard.topAnchor, constant: 18),
            summaryStack.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 18),
            summaryStack.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -18),

            summaryDividerView.topAnchor.constraint(equalTo: summaryStack.bottomAnchor, constant: 18),
            summaryDividerView.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 18),
            summaryDividerView.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -18),
            summaryDividerView.heightAnchor.constraint(equalToConstant: 1),

            estimateTitleLabel.topAnchor.constraint(equalTo: summaryDividerView.bottomAnchor, constant: 16),
            estimateTitleLabel.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 18),
            estimateTitleLabel.bottomAnchor.constraint(equalTo: summaryCard.bottomAnchor, constant: -18),

            estimateValueLabel.centerYAnchor.constraint(equalTo: estimateTitleLabel.centerYAnchor),
            estimateValueLabel.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -18),
            estimateValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: estimateTitleLabel.trailingAnchor, constant: 12),

            actionButton.topAnchor.constraint(equalTo: summaryCard.bottomAnchor, constant: 20),
            actionButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 56),

            validationLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 10),
            validationLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 28),
            validationLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -28),
            validationLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -28),

            emptyStateView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 36),
            emptyStateView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            emptyStateView.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -32)
        ])

    }

    @objc func handleBackgroundTap() {
        dismissKeyboard()
    }
}

private final class TradingMetricView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, value: String, accentColor: UIColor) {
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textColor = accentColor
    }

    private func configureView() {
        titleLabel.font = .systemFont(ofSize: 11, weight: .bold)
        titleLabel.textColor = AppColor.fieldTitleText

        valueLabel.font = .systemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = AppColor.primaryText
        valueLabel.numberOfLines = 2
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.75
    }

    private func buildHierarchy() {
        addSubview(titleLabel)
        addSubview(valueLabel)
    }

    private func setupLayout() {
        [titleLabel, valueLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private final class SummaryRowView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }

    private func configureView() {
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = AppColor.secondaryText

        valueLabel.font = .systemFont(ofSize: 15, weight: .bold)
        valueLabel.textColor = AppColor.primaryText
        valueLabel.textAlignment = .right
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.75
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func buildHierarchy() {
        addSubview(titleLabel)
        addSubview(valueLabel)
    }

    private func setupLayout() {
        [titleLabel, valueLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
