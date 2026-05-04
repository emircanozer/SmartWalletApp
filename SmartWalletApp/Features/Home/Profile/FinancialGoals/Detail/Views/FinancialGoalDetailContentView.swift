import UIKit

final class FinancialGoalDetailContentView: UIView {
    let backButton = UIButton(type: .system)
    let addMoneyButton = UIButton(type: .system)
    let editButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let summaryCardView = UIView()
    private let goalTitleLabel = UILabel()
    private let deadlineLabel = UILabel()
    private let badgeLabel = UILabel()
    private let savedTitleLabel = UILabel()
    private let savedAmountLabel = UILabel()
    private let targetAmountLabel = UILabel()
    private let remainingTitleLabel = UILabel()
    private let remainingAmountLabel = UILabel()
    private let progressTrackView = UIView()
    private let progressFillView = UIView()
    private let progressLabel = UILabel()
    private let daysLabel = UILabel()
    private let actionStackView = UIStackView()
    private let aiCardView = UIView()
    private let aiIconContainerView = UIView()
    private let aiIconView = UIImageView()
    private let aiTitleLabel = UILabel()
    private let aiBodyLabel = UILabel()
    private let historyTitleLabel = UILabel()
    private let viewAllButton = UIButton(type: .system)
    private let historyStackView = UIStackView()
    private var progressWidthConstraint: NSLayoutConstraint?

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
        [summaryCardView, aiCardView, addMoneyButton, editButton].forEach {
            $0.layer.cornerRadius = 20
        }
        [badgeLabel, aiIconContainerView].forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
        }
        progressTrackView.layer.cornerRadius = progressTrackView.bounds.height / 2
        progressFillView.layer.cornerRadius = progressFillView.bounds.height / 2
    }
}

extension FinancialGoalDetailContentView {
    func apply(_ data: FinancialGoalDetailViewData) {
        titleLabel.text = data.navigationTitleText
        goalTitleLabel.text = data.goalTitleText
        deadlineLabel.text = data.deadlineText
        badgeLabel.text = data.badgeText
        savedTitleLabel.text = data.savedTitleText
        savedAmountLabel.text = data.savedAmountText
        targetAmountLabel.text = data.targetAmountText
        remainingTitleLabel.text = data.remainingTitleText
        remainingAmountLabel.text = data.remainingAmountText
        progressLabel.text = data.progressText
        daysLabel.text = data.daysRemainingText
        var addMoneyConfiguration = addMoneyButton.configuration
        addMoneyConfiguration?.title = data.addMoneyButtonTitleText
        addMoneyButton.configuration = addMoneyConfiguration

        var editConfiguration = editButton.configuration
        editConfiguration?.title = data.editButtonTitleText
        editButton.configuration = editConfiguration
        aiTitleLabel.text = data.aiSuggestionTitleText
        aiBodyLabel.text = data.aiSuggestionBodyText
        historyTitleLabel.text = data.historySectionTitleText
        viewAllButton.setTitle(data.viewAllTitleText, for: .normal)

        historyStackView.arrangedSubviews.forEach {
            historyStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        data.historyItems.forEach { historyStackView.addArrangedSubview(ContributionHistoryCardView(item: $0)) }

        progressWidthConstraint?.isActive = false
        progressWidthConstraint = progressFillView.widthAnchor.constraint(equalTo: progressTrackView.widthAnchor, multiplier: max(0.06, min(data.progress, 1)))
        progressWidthConstraint?.isActive = true
        setNeedsLayout()
    }
}

 extension FinancialGoalDetailContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = AppColor.primaryText

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        [summaryCardView, aiCardView].forEach {
            $0.backgroundColor = AppColor.whitePrimary
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.03
            $0.layer.shadowRadius = 12
            $0.layer.shadowOffset = CGSize(width: 0, height: 6)
        }

        goalTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        goalTitleLabel.textColor = AppColor.primaryText

        deadlineLabel.font = .systemFont(ofSize: 14, weight: .medium)
        deadlineLabel.textColor = AppColor.secondaryText

        badgeLabel.backgroundColor = AppColor.surfaceWarmSoft
        badgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textColor = AppColor.accentOlive
        badgeLabel.textAlignment = .center

        [savedTitleLabel, remainingTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 10, weight: .bold)
            $0.textColor = AppColor.secondaryText
        }

        savedAmountLabel.font = .systemFont(ofSize: 28, weight: .bold)
        savedAmountLabel.textColor = AppColor.primaryText

        targetAmountLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        targetAmountLabel.textColor = AppColor.secondaryText

        remainingAmountLabel.font = .systemFont(ofSize: 16, weight: .bold)
        remainingAmountLabel.textColor = AppColor.accentOlive
        remainingAmountLabel.numberOfLines = 2
        remainingAmountLabel.textAlignment = .right

        progressTrackView.backgroundColor = AppColor.divider
        progressFillView.backgroundColor = AppColor.primaryYellow

        progressLabel.font = .systemFont(ofSize: 13, weight: .bold)
        progressLabel.textColor = AppColor.accentOlive
        progressLabel.textAlignment = .center

        daysLabel.font = .systemFont(ofSize: 14, weight: .medium)
        daysLabel.textColor = AppColor.secondaryText
        daysLabel.textAlignment = .center

        actionStackView.axis = .horizontal
        actionStackView.spacing = 12
        actionStackView.distribution = .fillEqually

        addMoneyButton.backgroundColor = AppColor.primaryYellow
        addMoneyButton.setTitleColor(AppColor.authHeadingText, for: .normal)
        addMoneyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        var addMoneyConfiguration = UIButton.Configuration.plain()
        addMoneyConfiguration.image = UIImage(systemName: "plus.circle")
        addMoneyConfiguration.imagePadding = 8
        addMoneyConfiguration.baseForegroundColor = AppColor.authHeadingText
        addMoneyButton.configuration = addMoneyConfiguration
        editButton.backgroundColor = AppColor.whitePrimary
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = AppColor.resolvedCGColor(AppColor.borderSoft, for: traitCollection)
        editButton.setTitleColor(AppColor.primaryText, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        var editConfiguration = UIButton.Configuration.plain()
        editConfiguration.image = UIImage(systemName: "pencil")
        editConfiguration.imagePadding = 8
        editConfiguration.baseForegroundColor = AppColor.primaryText
        editButton.configuration = editConfiguration

        aiIconContainerView.backgroundColor = AppColor.surfaceMuted
        aiIconView.image = UIImage(systemName: "sparkles")
        aiIconView.tintColor = AppColor.navigationTint
        aiIconView.contentMode = .scaleAspectFit

        aiTitleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        aiTitleLabel.textColor = AppColor.navigationTint

        aiBodyLabel.font = .systemFont(ofSize: 15, weight: .medium)
        aiBodyLabel.textColor = AppColor.bodyText
        aiBodyLabel.numberOfLines = 0
        aiBodyLabel.setLineSpacing(5)

        historyTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        historyTitleLabel.textColor = AppColor.primaryText

        viewAllButton.setTitleColor(AppColor.accentOlive, for: .normal)
        viewAllButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        viewAllButton.isUserInteractionEnabled = false

        historyStackView.axis = .vertical
        historyStackView.spacing = 12
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            titleLabel,
            summaryCardView,
            actionStackView,
            aiCardView,
            historyTitleLabel,
            viewAllButton,
            historyStackView
        ].forEach(contentContainer.addSubview)

        [
            goalTitleLabel,
            deadlineLabel,
            badgeLabel,
            savedTitleLabel,
            savedAmountLabel,
            targetAmountLabel,
            remainingTitleLabel,
            remainingAmountLabel,
            progressTrackView,
            progressLabel,
            daysLabel
        ].forEach(summaryCardView.addSubview)
        progressTrackView.addSubview(progressFillView)

        [addMoneyButton, editButton].forEach(actionStackView.addArrangedSubview)
        [aiIconContainerView, aiTitleLabel, aiBodyLabel].forEach(aiCardView.addSubview)
        aiIconContainerView.addSubview(aiIconView)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            titleLabel,
            summaryCardView,
            goalTitleLabel,
            deadlineLabel,
            badgeLabel,
            savedTitleLabel,
            savedAmountLabel,
            targetAmountLabel,
            remainingTitleLabel,
            remainingAmountLabel,
            progressTrackView,
            progressFillView,
            progressLabel,
            daysLabel,
            actionStackView,
            addMoneyButton,
            editButton,
            aiCardView,
            aiIconContainerView,
            aiIconView,
            aiTitleLabel,
            aiBodyLabel,
            historyTitleLabel,
            viewAllButton,
            historyStackView
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

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            summaryCardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28),
            summaryCardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            summaryCardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            goalTitleLabel.topAnchor.constraint(equalTo: summaryCardView.topAnchor, constant: 18),
            goalTitleLabel.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor, constant: 16),
            goalTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: badgeLabel.leadingAnchor, constant: -12),

            badgeLabel.topAnchor.constraint(equalTo: summaryCardView.topAnchor, constant: 16),
            badgeLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor, constant: -16),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            badgeLabel.heightAnchor.constraint(equalToConstant: 24),

            deadlineLabel.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 4),
            deadlineLabel.leadingAnchor.constraint(equalTo: goalTitleLabel.leadingAnchor),
            deadlineLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor, constant: -16),

            savedTitleLabel.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor, constant: 20),
            savedTitleLabel.leadingAnchor.constraint(equalTo: goalTitleLabel.leadingAnchor),

            remainingTitleLabel.centerYAnchor.constraint(equalTo: savedTitleLabel.centerYAnchor),
            remainingTitleLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor, constant: -16),

            savedAmountLabel.topAnchor.constraint(equalTo: savedTitleLabel.bottomAnchor, constant: 6),
            savedAmountLabel.leadingAnchor.constraint(equalTo: savedTitleLabel.leadingAnchor),

            targetAmountLabel.lastBaselineAnchor.constraint(equalTo: savedAmountLabel.lastBaselineAnchor),
            targetAmountLabel.leadingAnchor.constraint(equalTo: savedAmountLabel.trailingAnchor, constant: 8),
            targetAmountLabel.trailingAnchor.constraint(lessThanOrEqualTo: remainingAmountLabel.leadingAnchor, constant: -12),

            remainingAmountLabel.topAnchor.constraint(equalTo: remainingTitleLabel.bottomAnchor, constant: 6),
            remainingAmountLabel.trailingAnchor.constraint(equalTo: remainingTitleLabel.trailingAnchor),
            remainingAmountLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 110),

            progressTrackView.topAnchor.constraint(equalTo: savedAmountLabel.bottomAnchor, constant: 16),
            progressTrackView.leadingAnchor.constraint(equalTo: savedAmountLabel.leadingAnchor),
            progressTrackView.trailingAnchor.constraint(equalTo: remainingAmountLabel.trailingAnchor),
            progressTrackView.heightAnchor.constraint(equalToConstant: 10),

            progressFillView.topAnchor.constraint(equalTo: progressTrackView.topAnchor),
            progressFillView.leadingAnchor.constraint(equalTo: progressTrackView.leadingAnchor),
            progressFillView.bottomAnchor.constraint(equalTo: progressTrackView.bottomAnchor),

            progressLabel.topAnchor.constraint(equalTo: progressTrackView.bottomAnchor, constant: 12),
            progressLabel.centerXAnchor.constraint(equalTo: summaryCardView.centerXAnchor),

            daysLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 18),
            daysLabel.leadingAnchor.constraint(equalTo: goalTitleLabel.leadingAnchor),
            daysLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor, constant: -16),
            daysLabel.bottomAnchor.constraint(equalTo: summaryCardView.bottomAnchor, constant: -18),

            actionStackView.topAnchor.constraint(equalTo: summaryCardView.bottomAnchor, constant: 18),
            actionStackView.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            actionStackView.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),
            actionStackView.heightAnchor.constraint(equalToConstant: 52),

            aiCardView.topAnchor.constraint(equalTo: actionStackView.bottomAnchor, constant: 18),
            aiCardView.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            aiCardView.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),

            aiIconContainerView.topAnchor.constraint(equalTo: aiCardView.topAnchor, constant: 18),
            aiIconContainerView.leadingAnchor.constraint(equalTo: aiCardView.leadingAnchor, constant: 16),
            aiIconContainerView.widthAnchor.constraint(equalToConstant: 28),
            aiIconContainerView.heightAnchor.constraint(equalToConstant: 28),

            aiIconView.centerXAnchor.constraint(equalTo: aiIconContainerView.centerXAnchor),
            aiIconView.centerYAnchor.constraint(equalTo: aiIconContainerView.centerYAnchor),
            aiIconView.widthAnchor.constraint(equalToConstant: 16),
            aiIconView.heightAnchor.constraint(equalToConstant: 16),

            aiTitleLabel.centerYAnchor.constraint(equalTo: aiIconContainerView.centerYAnchor),
            aiTitleLabel.leadingAnchor.constraint(equalTo: aiIconContainerView.trailingAnchor, constant: 10),
            aiTitleLabel.trailingAnchor.constraint(equalTo: aiCardView.trailingAnchor, constant: -16),

            aiBodyLabel.topAnchor.constraint(equalTo: aiTitleLabel.bottomAnchor, constant: 12),
            aiBodyLabel.leadingAnchor.constraint(equalTo: aiIconContainerView.leadingAnchor),
            aiBodyLabel.trailingAnchor.constraint(equalTo: aiCardView.trailingAnchor, constant: -16),
            aiBodyLabel.bottomAnchor.constraint(equalTo: aiCardView.bottomAnchor, constant: -18),

            historyTitleLabel.topAnchor.constraint(equalTo: aiCardView.bottomAnchor, constant: 22),
            historyTitleLabel.leadingAnchor.constraint(equalTo: aiCardView.leadingAnchor),

            viewAllButton.centerYAnchor.constraint(equalTo: historyTitleLabel.centerYAnchor),
            viewAllButton.trailingAnchor.constraint(equalTo: aiCardView.trailingAnchor),

            historyStackView.topAnchor.constraint(equalTo: historyTitleLabel.bottomAnchor, constant: 14),
            historyStackView.leadingAnchor.constraint(equalTo: aiCardView.leadingAnchor),
            historyStackView.trailingAnchor.constraint(equalTo: aiCardView.trailingAnchor),
            historyStackView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -110)
        ])

        progressWidthConstraint = progressFillView.widthAnchor.constraint(equalToConstant: 28)
        progressWidthConstraint?.isActive = true
    }
}

private final class ContributionHistoryCardView: UIView {
    init(item: FinancialGoalContributionItemViewData) {
        super.init(frame: .zero)
        configureView()
        buildHierarchy()
        setupLayout()
        apply(item)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let cardView = UIView()
    private let iconContainerView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.cornerRadius = 18
        iconContainerView.layer.cornerRadius = 12
    }

    private func configureView() {
        cardView.backgroundColor = AppColor.whitePrimary
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.03
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5)

        iconContainerView.backgroundColor = AppColor.surfaceWarmSoft
        iconView.image = UIImage(systemName: "banknote")
        iconView.tintColor = AppColor.accentOlive
        iconView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        dateLabel.font = .systemFont(ofSize: 13, weight: .medium)
        dateLabel.textColor = AppColor.secondaryText
    }

    private func buildHierarchy() {
        addSubview(cardView)
        [iconContainerView, titleLabel, dateLabel].forEach(cardView.addSubview)
        iconContainerView.addSubview(iconView)
    }

    private func setupLayout() {
        [cardView, iconContainerView, iconView, titleLabel, dateLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconContainerView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 40),
            iconContainerView.heightAnchor.constraint(equalToConstant: 40),

            iconView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }

    private func apply(_ item: FinancialGoalContributionItemViewData) {
        titleLabel.text = item.titleText
        dateLabel.text = item.dateText
    }
}
