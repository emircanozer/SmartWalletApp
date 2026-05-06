import UIKit

final class FinancialGoalAddMoneySuccessContentView: UIView {
    let returnButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let heroImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let amountsStackView = UIStackView()
    private let goalCardView = UIView()
    private let goalIconContainerView = UIView()
    private let goalIconView = UIImageView()
    private let goalTitleLabel = UILabel()
    private let deadlineLabel = UILabel()
    private let badgeLabel = UILabel()
    private let progressTrackView = UIView()
    private let progressFillView = UIView()
    private let progressTextLabel = UILabel()
    private let progressAmountLabel = UILabel()
    private let remainingAmountLabel = UILabel()
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
        [goalCardView, returnButton].forEach {
            $0.layer.cornerRadius = 22
        }
        badgeLabel.layer.cornerRadius = badgeLabel.bounds.height / 2
        goalIconContainerView.layer.cornerRadius = 16
        progressTrackView.layer.cornerRadius = progressTrackView.bounds.height / 2
        progressFillView.layer.cornerRadius = progressFillView.bounds.height / 2
    }
}

extension FinancialGoalAddMoneySuccessContentView {
    func apply(_ data: FinancialGoalAddMoneySuccessViewData) {
        heroImageView.image = UIImage(named: data.heroImageName)
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText
        goalTitleLabel.text = data.goalTitleText
        deadlineLabel.text = data.deadlineText
        badgeLabel.text = data.badgeText
        progressTextLabel.text = data.progressText
        progressAmountLabel.text = data.progressAmountText
        remainingAmountLabel.text = data.remainingAmountText
        goalIconView.image = UIImage(systemName: data.iconName)
        goalIconView.tintColor = data.iconTintColor
        goalIconContainerView.backgroundColor = data.iconBackgroundColor
        returnButton.setTitle(data.returnButtonTitleText, for: .normal)

        amountsStackView.arrangedSubviews.forEach {
            amountsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        [
            makeAmountCard(title: data.previousAmountTitleText, value: data.previousAmountValueText, isHighlighted: false),
            makeAmountCard(title: data.addedAmountTitleText, value: data.addedAmountValueText, isHighlighted: true),
            makeAmountCard(title: data.updatedAmountTitleText, value: data.updatedAmountValueText, isHighlighted: false)
        ].forEach(amountsStackView.addArrangedSubview)

        progressWidthConstraint?.isActive = false
        progressWidthConstraint = progressFillView.widthAnchor.constraint(
            equalTo: progressTrackView.widthAnchor,
            multiplier: max(0.06, min(data.progress, 1))
        )
        progressWidthConstraint?.isActive = true
        setNeedsLayout()
    }
}

 extension FinancialGoalAddMoneySuccessContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        heroImageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        subtitleLabel.textColor = AppColor.bodyText
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2

        amountsStackView.axis = .vertical
        amountsStackView.spacing = 14

        goalCardView.backgroundColor = AppColor.whitePrimary
        goalCardView.layer.shadowColor = UIColor.black.cgColor
        goalCardView.layer.shadowOpacity = 0.05
        goalCardView.layer.shadowRadius = 16
        goalCardView.layer.shadowOffset = CGSize(width: 0, height: 8)

        goalIconView.contentMode = .scaleAspectFit

        goalTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        goalTitleLabel.textColor = AppColor.primaryText

        deadlineLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        deadlineLabel.textColor = AppColor.secondaryText

        badgeLabel.backgroundColor = AppColor.surfaceWarmSoft
        badgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textColor = AppColor.accentOlive
        badgeLabel.textAlignment = .center
        badgeLabel.clipsToBounds = true

        progressTrackView.backgroundColor = AppColor.divider
        progressFillView.backgroundColor = AppColor.primaryYellow

        progressTextLabel.font = .systemFont(ofSize: 12, weight: .bold)
        progressTextLabel.textColor = AppColor.accentOlive

        progressAmountLabel.font = .systemFont(ofSize: 16, weight: .bold)
        progressAmountLabel.textColor = AppColor.primaryText

        remainingAmountLabel.font = .systemFont(ofSize: 16, weight: .bold)
        remainingAmountLabel.textColor = AppColor.accentOlive
        remainingAmountLabel.textAlignment = .right

        returnButton.backgroundColor = AppColor.primaryYellow
        returnButton.setTitleColor(AppColor.primaryYellowText, for: .normal)
        returnButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        returnButton.layer.shadowColor = UIColor.black.cgColor
        returnButton.layer.shadowOpacity = 0.12
        returnButton.layer.shadowRadius = 18
        returnButton.layer.shadowOffset = CGSize(width: 0, height: 10)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            heroImageView,
            titleLabel,
            subtitleLabel,
            amountsStackView,
            returnButton,
            goalCardView
        ].forEach(contentContainer.addSubview)

        [
            goalIconContainerView,
            goalTitleLabel,
            deadlineLabel,
            badgeLabel,
            progressTrackView,
            progressTextLabel,
            progressAmountLabel,
            remainingAmountLabel
        ].forEach(goalCardView.addSubview)

        goalIconContainerView.addSubview(goalIconView)
        progressTrackView.addSubview(progressFillView)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            heroImageView,
            titleLabel,
            subtitleLabel,
            amountsStackView,
            returnButton,
            goalCardView,
            goalIconContainerView,
            goalIconView,
            goalTitleLabel,
            deadlineLabel,
            badgeLabel,
            progressTrackView,
            progressFillView,
            progressTextLabel,
            progressAmountLabel,
            remainingAmountLabel
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

            heroImageView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 8),
            heroImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 36),
            heroImageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -36),
            heroImageView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            amountsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            amountsStackView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            amountsStackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            returnButton.topAnchor.constraint(equalTo: amountsStackView.bottomAnchor, constant: 24),
            returnButton.leadingAnchor.constraint(equalTo: amountsStackView.leadingAnchor),
            returnButton.trailingAnchor.constraint(equalTo: amountsStackView.trailingAnchor),
            returnButton.heightAnchor.constraint(equalToConstant: 58),

            goalCardView.topAnchor.constraint(equalTo: returnButton.bottomAnchor, constant: 24),
            goalCardView.leadingAnchor.constraint(equalTo: amountsStackView.leadingAnchor),
            goalCardView.trailingAnchor.constraint(equalTo: amountsStackView.trailingAnchor),
            goalCardView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -24),

            goalIconContainerView.topAnchor.constraint(equalTo: goalCardView.topAnchor, constant: 20),
            goalIconContainerView.leadingAnchor.constraint(equalTo: goalCardView.leadingAnchor, constant: 20),
            goalIconContainerView.widthAnchor.constraint(equalToConstant: 54),
            goalIconContainerView.heightAnchor.constraint(equalToConstant: 54),

            goalIconView.centerXAnchor.constraint(equalTo: goalIconContainerView.centerXAnchor),
            goalIconView.centerYAnchor.constraint(equalTo: goalIconContainerView.centerYAnchor),
            goalIconView.widthAnchor.constraint(equalToConstant: 28),
            goalIconView.heightAnchor.constraint(equalToConstant: 28),

            goalTitleLabel.topAnchor.constraint(equalTo: goalIconContainerView.topAnchor, constant: 4),
            goalTitleLabel.leadingAnchor.constraint(equalTo: goalIconContainerView.trailingAnchor, constant: 14),
            goalTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: badgeLabel.leadingAnchor, constant: -12),

            badgeLabel.centerYAnchor.constraint(equalTo: goalTitleLabel.centerYAnchor),
            badgeLabel.trailingAnchor.constraint(equalTo: goalCardView.trailingAnchor, constant: -20),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 38),
            badgeLabel.heightAnchor.constraint(equalToConstant: 24),

            deadlineLabel.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 4),
            deadlineLabel.leadingAnchor.constraint(equalTo: goalTitleLabel.leadingAnchor),
            deadlineLabel.trailingAnchor.constraint(equalTo: goalCardView.trailingAnchor, constant: -20),

            progressTrackView.topAnchor.constraint(equalTo: goalIconContainerView.bottomAnchor, constant: 22),
            progressTrackView.leadingAnchor.constraint(equalTo: goalIconContainerView.leadingAnchor),
            progressTrackView.trailingAnchor.constraint(equalTo: goalCardView.trailingAnchor, constant: -20),
            progressTrackView.heightAnchor.constraint(equalToConstant: 10),

            progressFillView.topAnchor.constraint(equalTo: progressTrackView.topAnchor),
            progressFillView.leadingAnchor.constraint(equalTo: progressTrackView.leadingAnchor),
            progressFillView.bottomAnchor.constraint(equalTo: progressTrackView.bottomAnchor),

            progressTextLabel.topAnchor.constraint(equalTo: progressTrackView.bottomAnchor, constant: 12),
            progressTextLabel.leadingAnchor.constraint(equalTo: progressTrackView.leadingAnchor),
            progressTextLabel.trailingAnchor.constraint(equalTo: progressTrackView.trailingAnchor),

            progressAmountLabel.topAnchor.constraint(equalTo: progressTextLabel.bottomAnchor, constant: 12),
            progressAmountLabel.leadingAnchor.constraint(equalTo: progressTrackView.leadingAnchor),
            progressAmountLabel.bottomAnchor.constraint(equalTo: goalCardView.bottomAnchor, constant: -22),

            remainingAmountLabel.centerYAnchor.constraint(equalTo: progressAmountLabel.centerYAnchor),
            remainingAmountLabel.trailingAnchor.constraint(equalTo: progressTrackView.trailingAnchor),
            remainingAmountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: progressAmountLabel.trailingAnchor, constant: 12)
        ])

        progressWidthConstraint = progressFillView.widthAnchor.constraint(equalToConstant: 28)
        progressWidthConstraint?.isActive = true
    }

    func makeAmountCard(title: String, value: String, isHighlighted: Bool) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = isHighlighted ? AppColor.surfaceWarmSoft : AppColor.surfaceMuted
        cardView.layer.cornerRadius = 20

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 11, weight: .bold)
        titleLabel.textColor = AppColor.secondaryText
        titleLabel.text = title

        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = isHighlighted ? AppColor.accentOlive : AppColor.primaryText
        valueLabel.text = value

        [titleLabel, valueLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 84),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])

        return cardView
    }
}
