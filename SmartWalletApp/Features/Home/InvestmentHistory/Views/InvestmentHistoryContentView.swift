import UIKit

final class InvestmentHistoryContentView: UIView {
    let backButton = UIButton(type: .system)
    let dateFilterButton = UIButton(type: .system)
    let typeFilterButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let filterCardView = UIView()
    private let dateFilterContainerView = UIView()
    private let dateFilterIconView = UIImageView()
    private let dateChevronView = UIImageView()
    private let typeFilterContainerView = UIView()
    private let typeFilterIconView = UIImageView()
    private let typeChevronView = UIImageView()
    private let cardsStack = UIStackView()
    private let summaryCard = UIView()
    private let summaryHeaderRow = UIStackView()
    private let summaryBadgeView = UIView()
    private let summaryTitleLabel = UILabel()
    private let summaryBodyLabel = UILabel()
    private let summaryIconView = UIImageView()
    private let summaryLoadingIndicator = UIActivityIndicatorView(style: .medium)
    private let emptyStateView = EmptyStateView()

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
        summaryCard.layer.cornerRadius = 24
        summaryBadgeView.layer.cornerRadius = 18
        filterCardView.layer.cornerRadius = 24
        [dateFilterContainerView, typeFilterContainerView].forEach { $0.layer.cornerRadius = 16 }
    }
}

extension InvestmentHistoryContentView {
    func setRefreshControl(_ refreshControl: UIRefreshControl) {
        scrollView.refreshControl = refreshControl
    }

    func apply(_ data: InvestmentHistoryViewData) {
        titleLabel.text = data.titleText
        dateFilterButton.setTitle(data.selectedDateFilterTitleText, for: .normal)
        typeFilterButton.setTitle(data.selectedTypeFilterTitleText, for: .normal)

        cardsStack.arrangedSubviews.forEach {
            cardsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        data.items.forEach { item in
            let cardView = InvestmentHistoryTransactionCardView()
            cardView.configure(with: item)
            cardsStack.addArrangedSubview(cardView)
        }

        let isEmpty = data.emptyMessageText != nil
        cardsStack.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
        if let message = data.emptyMessageText {
            emptyStateView.configure(
                title: "Henüz yatırım işleminiz yok",
                message: message,
                systemImageName: "clock.arrow.circlepath"
            )
        }
    }

    func setSummaryLoading(_ isLoading: Bool) {
        summaryCard.isHidden = false
        summaryTitleLabel.text = "Aylık Özet"
        if isLoading {
            summaryBodyLabel.isHidden = true
            summaryLoadingIndicator.startAnimating()
        } else {
            summaryLoadingIndicator.stopAnimating()
            summaryBodyLabel.isHidden = false
        }
    }

    func applySummary(_ data: InvestmentHistorySummaryViewData) {
        summaryTitleLabel.text = data.titleText
        summaryBodyLabel.text = data.bodyText
        setSummaryLoading(false)
    }

    func showSummaryFallback(_ message: String) {
        summaryTitleLabel.text = "Aylık Özet"
        summaryBodyLabel.text = message
        setSummaryLoading(false)
    }
}

extension InvestmentHistoryContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        filterCardView.backgroundColor = AppColor.surfaceMuted

        [dateFilterContainerView, typeFilterContainerView].forEach {
            $0.backgroundColor = AppColor.whitePrimary
        }

        dateFilterIconView.image = UIImage(systemName: "calendar")
        dateFilterIconView.tintColor = AppColor.navigationTint
        typeFilterIconView.image = UIImage(systemName: "line.3.horizontal.decrease")
        typeFilterIconView.tintColor = AppColor.navigationTint

        [dateChevronView, typeChevronView].forEach {
            $0.image = UIImage(systemName: "chevron.down")
            $0.tintColor = AppColor.iconMuted
        }

        [dateFilterButton, typeFilterButton].forEach {
            $0.setTitleColor(AppColor.primaryText, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.contentHorizontalAlignment = .left
        }

        cardsStack.axis = .vertical
        cardsStack.spacing = 18

        summaryCard.backgroundColor = AppColor.whitePrimary
        summaryCard.layer.borderWidth = 1
        summaryCard.layer.borderColor = AppColor.resolvedCGColor(AppColor.borderSoft, for: traitCollection)
        summaryCard.layer.shadowColor = UIColor.black.cgColor
        summaryCard.layer.shadowOpacity = 0.04
        summaryCard.layer.shadowRadius = 16
        summaryCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        summaryHeaderRow.axis = .horizontal
        summaryHeaderRow.alignment = .center
        summaryHeaderRow.spacing = 12

        summaryBadgeView.backgroundColor = AppColor.surfaceWarmSoft

        summaryTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        summaryTitleLabel.textColor = AppColor.warmActionText

        summaryBodyLabel.font = .systemFont(ofSize: 15, weight: .medium)
        summaryBodyLabel.textColor = AppColor.bodyText
        summaryBodyLabel.numberOfLines = 0
        summaryBodyLabel.lineBreakMode = .byWordWrapping
        summaryBodyLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        summaryBodyLabel.setContentHuggingPriority(.required, for: .vertical)

        summaryIconView.image = UIImage(systemName: "sparkles")
        summaryIconView.tintColor = AppColor.warmActionText
        summaryIconView.contentMode = .scaleAspectFit

        summaryLoadingIndicator.color = AppColor.warmActionText

        emptyStateView.isHidden = true
        summaryCard.isHidden = true
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [backButton, titleLabel, filterCardView, cardsStack, emptyStateView, summaryCard].forEach(contentContainer.addSubview)
        [dateFilterContainerView, typeFilterContainerView].forEach(filterCardView.addSubview)
        [dateFilterIconView, dateFilterButton, dateChevronView].forEach(dateFilterContainerView.addSubview)
        [typeFilterIconView, typeFilterButton, typeChevronView].forEach(typeFilterContainerView.addSubview)
        [summaryHeaderRow, summaryBodyLabel, summaryLoadingIndicator].forEach(summaryCard.addSubview)
        summaryHeaderRow.addArrangedSubview(summaryBadgeView)
        summaryHeaderRow.addArrangedSubview(summaryTitleLabel)
        summaryBadgeView.addSubview(summaryIconView)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            titleLabel,
            filterCardView,
            dateFilterContainerView,
            dateFilterIconView,
            dateFilterButton,
            dateChevronView,
            typeFilterContainerView,
            typeFilterIconView,
            typeFilterButton,
            typeChevronView,
            cardsStack,
            emptyStateView,
            summaryCard,
            summaryHeaderRow,
            summaryBadgeView,
            summaryTitleLabel,
            summaryBodyLabel,
            summaryIconView,
            summaryLoadingIndicator
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
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            filterCardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            filterCardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            filterCardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            dateFilterContainerView.topAnchor.constraint(equalTo: filterCardView.topAnchor, constant: 18),
            dateFilterContainerView.leadingAnchor.constraint(equalTo: filterCardView.leadingAnchor, constant: 16),
            dateFilterContainerView.trailingAnchor.constraint(equalTo: filterCardView.trailingAnchor, constant: -16),
            dateFilterContainerView.heightAnchor.constraint(equalToConstant: 48),

            dateFilterIconView.leadingAnchor.constraint(equalTo: dateFilterContainerView.leadingAnchor, constant: 16),
            dateFilterIconView.centerYAnchor.constraint(equalTo: dateFilterContainerView.centerYAnchor),
            dateFilterIconView.widthAnchor.constraint(equalToConstant: 18),
            dateFilterIconView.heightAnchor.constraint(equalToConstant: 18),

            dateChevronView.trailingAnchor.constraint(equalTo: dateFilterContainerView.trailingAnchor, constant: -16),
            dateChevronView.centerYAnchor.constraint(equalTo: dateFilterContainerView.centerYAnchor),
            dateChevronView.widthAnchor.constraint(equalToConstant: 14),
            dateChevronView.heightAnchor.constraint(equalToConstant: 14),

            dateFilterButton.leadingAnchor.constraint(equalTo: dateFilterIconView.trailingAnchor, constant: 12),
            dateFilterButton.trailingAnchor.constraint(equalTo: dateChevronView.leadingAnchor, constant: -10),
            dateFilterButton.centerYAnchor.constraint(equalTo: dateFilterContainerView.centerYAnchor),

            typeFilterContainerView.topAnchor.constraint(equalTo: dateFilterContainerView.bottomAnchor, constant: 14),
            typeFilterContainerView.leadingAnchor.constraint(equalTo: dateFilterContainerView.leadingAnchor),
            typeFilterContainerView.trailingAnchor.constraint(equalTo: dateFilterContainerView.trailingAnchor),
            typeFilterContainerView.heightAnchor.constraint(equalToConstant: 48),
            typeFilterContainerView.bottomAnchor.constraint(equalTo: filterCardView.bottomAnchor, constant: -18),

            typeFilterIconView.leadingAnchor.constraint(equalTo: typeFilterContainerView.leadingAnchor, constant: 16),
            typeFilterIconView.centerYAnchor.constraint(equalTo: typeFilterContainerView.centerYAnchor),
            typeFilterIconView.widthAnchor.constraint(equalToConstant: 18),
            typeFilterIconView.heightAnchor.constraint(equalToConstant: 18),

            typeChevronView.trailingAnchor.constraint(equalTo: typeFilterContainerView.trailingAnchor, constant: -16),
            typeChevronView.centerYAnchor.constraint(equalTo: typeFilterContainerView.centerYAnchor),
            typeChevronView.widthAnchor.constraint(equalToConstant: 14),
            typeChevronView.heightAnchor.constraint(equalToConstant: 14),

            typeFilterButton.leadingAnchor.constraint(equalTo: typeFilterIconView.trailingAnchor, constant: 12),
            typeFilterButton.trailingAnchor.constraint(equalTo: typeChevronView.leadingAnchor, constant: -10),
            typeFilterButton.centerYAnchor.constraint(equalTo: typeFilterContainerView.centerYAnchor),

            cardsStack.topAnchor.constraint(equalTo: filterCardView.bottomAnchor, constant: 20),
            cardsStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            cardsStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            emptyStateView.topAnchor.constraint(equalTo: filterCardView.bottomAnchor, constant: 36),
            emptyStateView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            summaryCard.topAnchor.constraint(equalTo: cardsStack.bottomAnchor, constant: 24),
            summaryCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            summaryCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            summaryCard.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -32),
            summaryCard.topAnchor.constraint(greaterThanOrEqualTo: emptyStateView.bottomAnchor, constant: 24),

            summaryHeaderRow.topAnchor.constraint(equalTo: summaryCard.topAnchor, constant: 20),
            summaryHeaderRow.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 18),
            summaryHeaderRow.trailingAnchor.constraint(lessThanOrEqualTo: summaryCard.trailingAnchor, constant: -18),

            summaryBadgeView.widthAnchor.constraint(equalToConstant: 36),
            summaryBadgeView.heightAnchor.constraint(equalToConstant: 36),

            summaryIconView.centerXAnchor.constraint(equalTo: summaryBadgeView.centerXAnchor),
            summaryIconView.centerYAnchor.constraint(equalTo: summaryBadgeView.centerYAnchor),
            summaryIconView.widthAnchor.constraint(equalToConstant: 16),
            summaryIconView.heightAnchor.constraint(equalToConstant: 16),

            summaryLoadingIndicator.centerXAnchor.constraint(equalTo: summaryCard.centerXAnchor),
            summaryLoadingIndicator.centerYAnchor.constraint(equalTo: summaryCard.centerYAnchor, constant: 10),

            summaryBodyLabel.topAnchor.constraint(equalTo: summaryHeaderRow.bottomAnchor, constant: 14),
            summaryBodyLabel.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 20),
            summaryBodyLabel.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -20),
            summaryBodyLabel.bottomAnchor.constraint(equalTo: summaryCard.bottomAnchor, constant: -20)
        ])
    }

    func applyStaticContent() {
        dateFilterButton.setTitle("Tüm Tarihler", for: .normal)
        typeFilterButton.setTitle("Tümü", for: .normal)
    }
}
