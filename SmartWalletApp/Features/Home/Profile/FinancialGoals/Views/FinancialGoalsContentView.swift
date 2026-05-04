import UIKit

final class FinancialGoalsContentView: UIView {
    let backButton = UIButton(type: .system)
    let createGoalButton = UIButton(type: .system)

    var onCreateGoalTap: (() -> Void)?
    var onGoalSelected: ((UUID) -> Void)?

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let summaryCardView = UIView()
    private let goalCountLabel = UILabel()
    private let totalSavedLabel = UILabel()
    private let totalTargetLabel = UILabel()
    private let summaryIconContainer = UIView()
    private let summaryIconView = UIImageView()
    private let progressTrackView = UIView()
    private let progressFillView = UIView()
    private let completionLabel = UILabel()
    private let remainingLabel = UILabel()
    private let sectionTitleLabel = UILabel()
    private let goalsStackView = UIStackView()
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
        [summaryCardView].forEach {
            $0.layer.cornerRadius = 22
        }
        [summaryIconContainer].forEach {
            $0.layer.cornerRadius = 14
        }
        createGoalButton.layer.cornerRadius = createGoalButton.bounds.height / 2
        updateProgressWidth()
    }
}

extension FinancialGoalsContentView {
    func apply(_ data: FinancialGoalsViewData) {
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText
        goalCountLabel.text = data.totalGoalCountText
        totalSavedLabel.text = data.totalSavedAmountText
        totalTargetLabel.text = "/ \(data.totalTargetAmountText)"
        completionLabel.text = data.completionText
        remainingLabel.text = data.remainingAmountText
        sectionTitleLabel.text = data.sectionTitleText
        progressFillView.accessibilityValue = "\(data.progress)"

        goalsStackView.arrangedSubviews.forEach {
            goalsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        data.items.forEach { item in
            let cardView = FinancialGoalCardView(item: item)
            cardView.onTap = { [weak self] id in
                self?.onGoalSelected?(id)
            }
            goalsStackView.addArrangedSubview(cardView)
        }

        progressWidthConstraint?.isActive = false
        progressWidthConstraint = progressFillView.widthAnchor.constraint(equalTo: progressTrackView.widthAnchor, multiplier: max(0.06, min(data.progress, 1)))
        progressWidthConstraint?.isActive = true
        setNeedsLayout()
    }
}

 extension FinancialGoalsContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = AppColor.accentOlive

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = AppColor.bodyText

        [summaryCardView].forEach {
            $0.backgroundColor = AppColor.whitePrimary
        }

        summaryCardView.layer.shadowColor = UIColor.black.cgColor
        summaryCardView.layer.shadowOpacity = 0.04
        summaryCardView.layer.shadowRadius = 14
        summaryCardView.layer.shadowOffset = CGSize(width: 0, height: 8)

        goalCountLabel.font = .systemFont(ofSize: 14, weight: .bold)
        goalCountLabel.textColor = AppColor.primaryText

        totalSavedLabel.font = .systemFont(ofSize: 28, weight: .bold)
        totalSavedLabel.textColor = AppColor.primaryText

        totalTargetLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        totalTargetLabel.textColor = AppColor.bodyText

        summaryIconContainer.backgroundColor = AppColor.surfaceWarmSoft
        summaryIconView.image = UIImage(systemName: "chart.bar.fill")
        summaryIconView.tintColor = AppColor.accentOlive
        summaryIconView.contentMode = .scaleAspectFit

        progressTrackView.backgroundColor = AppColor.divider
        progressTrackView.layer.cornerRadius = 6
        progressTrackView.clipsToBounds = true

        progressFillView.backgroundColor = AppColor.primaryYellow
        progressFillView.layer.cornerRadius = 6

        completionLabel.font = .systemFont(ofSize: 14, weight: .bold)
        completionLabel.textColor = AppColor.primaryText

        remainingLabel.font = .systemFont(ofSize: 14, weight: .bold)
        remainingLabel.textColor = AppColor.bodyText
        remainingLabel.textAlignment = .right

        sectionTitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        sectionTitleLabel.textColor = AppColor.secondaryText
        sectionTitleLabel.letterSpacing = 2

        goalsStackView.axis = .vertical
        goalsStackView.spacing = 16

        createGoalButton.backgroundColor = AppColor.primaryYellow
        createGoalButton.tintColor = AppColor.accentOlive
        createGoalButton.setImage(UIImage(systemName: "plus"), for: .normal)
        createGoalButton.layer.shadowColor = UIColor.black.cgColor
        createGoalButton.layer.shadowOpacity = 0.08
        createGoalButton.layer.shadowRadius = 14
        createGoalButton.layer.shadowOffset = CGSize(width: 0, height: 8)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            titleLabel,
            subtitleLabel,
            summaryCardView,
            sectionTitleLabel,
            goalsStackView
        ].forEach(contentContainer.addSubview)
        addSubview(createGoalButton)

        [
            goalCountLabel,
            totalSavedLabel,
            totalTargetLabel,
            summaryIconContainer,
            progressTrackView,
            completionLabel,
            remainingLabel
        ].forEach(summaryCardView.addSubview)

        summaryIconContainer.addSubview(summaryIconView)
        progressTrackView.addSubview(progressFillView)

        createGoalButton.addTarget(self, action: #selector(handleCreateGoalTap), for: .touchUpInside)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            titleLabel,
            subtitleLabel,
            summaryCardView,
            goalCountLabel,
            totalSavedLabel,
            totalTargetLabel,
            summaryIconContainer,
            summaryIconView,
            progressTrackView,
            progressFillView,
            completionLabel,
            remainingLabel,
            sectionTitleLabel,
            goalsStackView,
            createGoalButton
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

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 42),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            summaryCardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 26),
            summaryCardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            summaryCardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            goalCountLabel.topAnchor.constraint(equalTo: summaryCardView.topAnchor, constant: 24),
            goalCountLabel.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor, constant: 24),
            goalCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: summaryIconContainer.leadingAnchor, constant: -12),

            summaryIconContainer.topAnchor.constraint(equalTo: summaryCardView.topAnchor, constant: 18),
            summaryIconContainer.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor, constant: -18),
            summaryIconContainer.widthAnchor.constraint(equalToConstant: 36),
            summaryIconContainer.heightAnchor.constraint(equalToConstant: 36),

            summaryIconView.centerXAnchor.constraint(equalTo: summaryIconContainer.centerXAnchor),
            summaryIconView.centerYAnchor.constraint(equalTo: summaryIconContainer.centerYAnchor),
            summaryIconView.widthAnchor.constraint(equalToConstant: 18),
            summaryIconView.heightAnchor.constraint(equalToConstant: 18),

            totalSavedLabel.topAnchor.constraint(equalTo: goalCountLabel.bottomAnchor, constant: 12),
            totalSavedLabel.leadingAnchor.constraint(equalTo: goalCountLabel.leadingAnchor),

            totalTargetLabel.lastBaselineAnchor.constraint(equalTo: totalSavedLabel.lastBaselineAnchor),
            totalTargetLabel.leadingAnchor.constraint(equalTo: totalSavedLabel.trailingAnchor, constant: 8),
            totalTargetLabel.trailingAnchor.constraint(lessThanOrEqualTo: summaryCardView.trailingAnchor, constant: -24),

            progressTrackView.topAnchor.constraint(equalTo: totalSavedLabel.bottomAnchor, constant: 18),
            progressTrackView.leadingAnchor.constraint(equalTo: goalCountLabel.leadingAnchor),
            progressTrackView.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor, constant: -24),
            progressTrackView.heightAnchor.constraint(equalToConstant: 12),

            progressFillView.topAnchor.constraint(equalTo: progressTrackView.topAnchor),
            progressFillView.leadingAnchor.constraint(equalTo: progressTrackView.leadingAnchor),
            progressFillView.bottomAnchor.constraint(equalTo: progressTrackView.bottomAnchor),

            completionLabel.topAnchor.constraint(equalTo: progressTrackView.bottomAnchor, constant: 12),
            completionLabel.leadingAnchor.constraint(equalTo: progressTrackView.leadingAnchor),
            completionLabel.bottomAnchor.constraint(equalTo: summaryCardView.bottomAnchor, constant: -24),

            remainingLabel.centerYAnchor.constraint(equalTo: completionLabel.centerYAnchor),
            remainingLabel.trailingAnchor.constraint(equalTo: progressTrackView.trailingAnchor),

            sectionTitleLabel.topAnchor.constraint(equalTo: summaryCardView.bottomAnchor, constant: 28),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),

            goalsStackView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 18),
            goalsStackView.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            goalsStackView.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),
            goalsStackView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -112),

            createGoalButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24),
            createGoalButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24),
            createGoalButton.widthAnchor.constraint(equalToConstant: 54),
            createGoalButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        progressWidthConstraint = progressFillView.widthAnchor.constraint(equalToConstant: 28)
        progressWidthConstraint?.isActive = true
    }

    func updateProgressWidth() {
        progressFillView.layer.cornerRadius = progressFillView.bounds.height / 2
    }

    @objc func handleCreateGoalTap() {
        onCreateGoalTap?()
    }
}
private final class FinancialGoalCardView: UIView {
    var onTap: ((UUID) -> Void)?

    init(item: FinancialGoalItemViewData) {
        self.itemID = item.id
        super.init(frame: .zero)
        configureView()
        apply(item)
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let cardView = UIView()
    private let iconContainerView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let deadlineLabel = UILabel()
    private let chevronView = UIImageView()
    private let currentAmountLabel = UILabel()
    private let targetAmountLabel = UILabel()
    private let progressTrackView = UIView()
    private let progressFillView = UIView()
    private let tapButton = UIButton(type: .custom)
    private var progressWidthConstraint: NSLayoutConstraint?
    private let itemID: UUID

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.cornerRadius = 22
        iconContainerView.layer.cornerRadius = 14
        progressTrackView.layer.cornerRadius = 5
        progressFillView.layer.cornerRadius = 5
    }

    private func configureView() {
        backgroundColor = .clear
        cardView.backgroundColor = AppColor.whitePrimary
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.03
        cardView.layer.shadowRadius = 12
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)

        iconView.contentMode = .scaleAspectFit
        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.tintColor = AppColor.navigationTint
        chevronView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        deadlineLabel.font = .systemFont(ofSize: 15, weight: .medium)
        deadlineLabel.textColor = AppColor.bodyText

        currentAmountLabel.font = .systemFont(ofSize: 15, weight: .bold)
        currentAmountLabel.textColor = AppColor.primaryText

        targetAmountLabel.font = .systemFont(ofSize: 15, weight: .bold)
        targetAmountLabel.textColor = AppColor.bodyText
        targetAmountLabel.textAlignment = .right

        progressTrackView.backgroundColor = AppColor.divider
        progressFillView.backgroundColor = AppColor.primaryYellow

        tapButton.backgroundColor = .clear
        tapButton.accessibilityTraits = .button
    }

    private func apply(_ item: FinancialGoalItemViewData) {
        titleLabel.text = item.titleText
        deadlineLabel.text = item.deadlineText
        currentAmountLabel.text = item.currentAmountText
        targetAmountLabel.text = item.targetAmountText
        iconView.image = UIImage(systemName: item.iconName)
        iconView.tintColor = item.iconTintColor
        iconContainerView.backgroundColor = item.iconBackgroundColor
        progressWidthConstraint = progressFillView.widthAnchor.constraint(equalTo: progressTrackView.widthAnchor, multiplier: max(0.06, min(item.progress, 1)))
    }

    private func buildHierarchy() {
        addSubview(cardView)
        [iconContainerView, titleLabel, deadlineLabel, chevronView, currentAmountLabel, targetAmountLabel, progressTrackView, tapButton].forEach(cardView.addSubview)
        iconContainerView.addSubview(iconView)
        progressTrackView.addSubview(progressFillView)
        tapButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    private func setupLayout() {
        [
            cardView,
            iconContainerView,
            iconView,
            titleLabel,
            deadlineLabel,
            chevronView,
            currentAmountLabel,
            targetAmountLabel,
            progressTrackView,
            progressFillView,
            tapButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconContainerView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            iconContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            iconContainerView.widthAnchor.constraint(equalToConstant: 52),
            iconContainerView.heightAnchor.constraint(equalToConstant: 52),

            iconView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),

            chevronView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            chevronView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            chevronView.widthAnchor.constraint(equalToConstant: 12),
            chevronView.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronView.leadingAnchor, constant: -12),

            deadlineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            deadlineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            deadlineLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            currentAmountLabel.topAnchor.constraint(equalTo: iconContainerView.bottomAnchor, constant: 18),
            currentAmountLabel.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor),

            targetAmountLabel.centerYAnchor.constraint(equalTo: currentAmountLabel.centerYAnchor),
            targetAmountLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            progressTrackView.topAnchor.constraint(equalTo: currentAmountLabel.bottomAnchor, constant: 12),
            progressTrackView.leadingAnchor.constraint(equalTo: currentAmountLabel.leadingAnchor),
            progressTrackView.trailingAnchor.constraint(equalTo: targetAmountLabel.trailingAnchor),
            progressTrackView.heightAnchor.constraint(equalToConstant: 10),
            progressTrackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),

            progressFillView.topAnchor.constraint(equalTo: progressTrackView.topAnchor),
            progressFillView.leadingAnchor.constraint(equalTo: progressTrackView.leadingAnchor),
            progressFillView.bottomAnchor.constraint(equalTo: progressTrackView.bottomAnchor),

            tapButton.topAnchor.constraint(equalTo: cardView.topAnchor),
            tapButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            tapButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            tapButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])

        progressWidthConstraint?.isActive = true
    }

    @objc private func handleTap() {
        onTap?(itemID)
    }
}
