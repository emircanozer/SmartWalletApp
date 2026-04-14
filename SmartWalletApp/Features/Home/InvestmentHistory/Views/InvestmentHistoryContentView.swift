import UIKit

final class InvestmentHistoryContentView: UIView {
    let backButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let cardsStack = UIStackView()
    private let summaryCard = UIView()
    private let summaryHeaderRow = UIStackView()
    private let summaryBadgeView = UIView()
    private let summaryTitleLabel = UILabel()
    private let summaryBodyLabel = UILabel()
    private let summaryIconView = UIImageView()
    private let emptyStateLabel = UILabel()

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
        summaryCard.layer.cornerRadius = 24
        summaryBadgeView.layer.cornerRadius = 18
    }
}

extension InvestmentHistoryContentView {
    func setRefreshControl(_ refreshControl: UIRefreshControl) {
        scrollView.refreshControl = refreshControl
    }

    func apply(_ data: InvestmentHistoryViewData) {
        titleLabel.text = data.titleText
        summaryTitleLabel.text = data.monthlySummaryTitleText
        summaryBodyLabel.text = data.monthlySummaryBodyText
        emptyStateLabel.text = data.emptyMessageText

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
        emptyStateLabel.isHidden = !isEmpty

        let hasSummary = !data.monthlySummaryBodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        summaryCard.isHidden = !hasSummary
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

        cardsStack.axis = .vertical
        cardsStack.spacing = 18

        summaryCard.backgroundColor = UIColor.white
        summaryCard.layer.borderWidth = 1
        summaryCard.layer.borderColor = AppColor.borderWarm.cgColor
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

        summaryIconView.image = UIImage(systemName: "sparkles")
        summaryIconView.tintColor = AppColor.warmActionText
        summaryIconView.contentMode = .scaleAspectFit

        emptyStateLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        emptyStateLabel.textColor = AppColor.secondaryText
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.isHidden = true
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [backButton, titleLabel, cardsStack, emptyStateLabel, summaryCard].forEach(contentContainer.addSubview)
        [summaryHeaderRow, summaryBodyLabel].forEach(summaryCard.addSubview)
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
            cardsStack,
            emptyStateLabel,
            summaryCard,
            summaryHeaderRow,
            summaryBadgeView,
            summaryTitleLabel,
            summaryBodyLabel,
            summaryIconView
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

            cardsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            cardsStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            cardsStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            emptyStateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 120),
            emptyStateLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -32),

            summaryCard.topAnchor.constraint(equalTo: cardsStack.bottomAnchor, constant: 24),
            summaryCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            summaryCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            summaryCard.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -32),
            summaryCard.topAnchor.constraint(greaterThanOrEqualTo: emptyStateLabel.bottomAnchor, constant: 24),

            summaryHeaderRow.topAnchor.constraint(equalTo: summaryCard.topAnchor, constant: 20),
            summaryHeaderRow.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 18),
            summaryHeaderRow.trailingAnchor.constraint(lessThanOrEqualTo: summaryCard.trailingAnchor, constant: -18),

            summaryBadgeView.widthAnchor.constraint(equalToConstant: 36),
            summaryBadgeView.heightAnchor.constraint(equalToConstant: 36),

            summaryIconView.centerXAnchor.constraint(equalTo: summaryBadgeView.centerXAnchor),
            summaryIconView.centerYAnchor.constraint(equalTo: summaryBadgeView.centerYAnchor),
            summaryIconView.widthAnchor.constraint(equalToConstant: 16),
            summaryIconView.heightAnchor.constraint(equalToConstant: 16),

            summaryBodyLabel.topAnchor.constraint(equalTo: summaryHeaderRow.bottomAnchor, constant: 14),
            summaryBodyLabel.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 20),
            summaryBodyLabel.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -20),
            summaryBodyLabel.bottomAnchor.constraint(equalTo: summaryCard.bottomAnchor, constant: -20)
        ])
    }
}
