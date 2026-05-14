import UIKit

final class InvestmentTradeConfirmationContentView: UIView {
    let backButton = UIButton(type: .system)
    let confirmButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let cardView = UIView()
    private let highlightStack = UIStackView()
    private let detailsStack = UIStackView()
    private let noticeView = UIView()
    private let noticeIconView = UIImageView()
    private let noticeLabel = UILabel()

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
        [cardView, noticeView].forEach { $0.layer.cornerRadius = 24 }
        confirmButton.layer.cornerRadius = 20
    }
}

extension InvestmentTradeConfirmationContentView {
    func apply(_ data: InvestmentTradeConfirmationViewData) {
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText
        noticeLabel.text = data.noticeText
        confirmButton.setTitle(data.confirmButtonTitle, for: .normal)

        highlightStack.arrangedSubviews.forEach {
            highlightStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        data.highlightItems.forEach { item in
            let row = HighlightRowView()
            row.configure(with: item)
            highlightStack.addArrangedSubview(row)
        }

        detailsStack.arrangedSubviews.forEach {
            detailsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        data.detailItems.enumerated().forEach { index, item in
            let row = DetailRowView()
            row.configure(with: item, showsDivider: index < data.detailItems.count - 1)
            detailsStack.addArrangedSubview(row)
        }
    }
}

 extension InvestmentTradeConfirmationContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText

        cardView.backgroundColor = AppColor.whitePrimary
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 18
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)

        highlightStack.axis = .vertical
        highlightStack.spacing = 12

        detailsStack.axis = .vertical
        detailsStack.spacing = 0

        noticeView.backgroundColor = AppColor.surfaceMuted
        noticeIconView.image = UIImage(systemName: "info.circle")
        noticeIconView.tintColor = AppColor.accentOlive
        noticeIconView.contentMode = .scaleAspectFit

        noticeLabel.font = .systemFont(ofSize: 13, weight: .medium)
        noticeLabel.textColor = AppColor.secondaryText
        noticeLabel.numberOfLines = 0

        var confirmConfiguration = UIButton.Configuration.filled()
        confirmConfiguration.baseBackgroundColor = AppColor.primaryYellow
        confirmConfiguration.baseForegroundColor = AppColor.primaryText
        confirmConfiguration.cornerStyle = .capsule
        confirmConfiguration.image = UIImage(systemName: "checkmark.circle.fill")
        confirmConfiguration.imagePadding = 10
        confirmConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 24, bottom: 17, trailing: 24)
        confirmButton.configuration = confirmConfiguration
        confirmButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [backButton, titleLabel, subtitleLabel, cardView, noticeView, confirmButton].forEach(contentContainer.addSubview)
        [highlightStack, detailsStack].forEach(cardView.addSubview)
        [noticeIconView, noticeLabel].forEach(noticeView.addSubview)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            titleLabel,
            subtitleLabel,
            cardView,
            highlightStack,
            detailsStack,
            noticeView,
            noticeIconView,
            noticeLabel,
            confirmButton
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

            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            cardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),

            highlightStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            highlightStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            highlightStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),

            detailsStack.topAnchor.constraint(equalTo: highlightStack.bottomAnchor, constant: 18),
            detailsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            detailsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            detailsStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),

            noticeView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 18),
            noticeView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            noticeView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),

            noticeIconView.leadingAnchor.constraint(equalTo: noticeView.leadingAnchor, constant: 16),
            noticeIconView.centerYAnchor.constraint(equalTo: noticeView.centerYAnchor),
            noticeIconView.widthAnchor.constraint(equalToConstant: 18),
            noticeIconView.heightAnchor.constraint(equalToConstant: 18),

            noticeLabel.topAnchor.constraint(equalTo: noticeView.topAnchor, constant: 14),
            noticeLabel.leadingAnchor.constraint(equalTo: noticeIconView.trailingAnchor, constant: 10),
            noticeLabel.trailingAnchor.constraint(equalTo: noticeView.trailingAnchor, constant: -16),
            noticeLabel.bottomAnchor.constraint(equalTo: noticeView.bottomAnchor, constant: -14),

            confirmButton.topAnchor.constraint(equalTo: noticeView.bottomAnchor, constant: 34),
            confirmButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            confirmButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),
            confirmButton.heightAnchor.constraint(equalToConstant: 56),
            confirmButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -28)
        ])
    }
}

private final class HighlightRowView: UIView {
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let iconView = UIImageView()
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

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.cornerRadius = 18
    }

    func configure(with item: InvestmentTradeConfirmationHighlightItem) {
        titleLabel.text = item.title
        valueLabel.text = item.value
        iconView.image = item.iconName.flatMap { UIImage(systemName: $0) }
        iconView.isHidden = item.iconName == nil
    }

    private func configureView() {
        cardView.backgroundColor = AppColor.surfaceWarm

        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = AppColor.secondaryText

        iconView.tintColor = AppColor.accentOlive
        iconView.contentMode = .scaleAspectFit

        valueLabel.font = .systemFont(ofSize: 22, weight: .bold)
        valueLabel.textColor = AppColor.accentOlive
    }

    private func buildHierarchy() {
        addSubview(cardView)
        [titleLabel, iconView, valueLabel].forEach(cardView.addSubview)
    }

    private func setupLayout() {
        [cardView, titleLabel, iconView, valueLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),

            iconView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconView.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -8),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),

            valueLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            valueLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 14)
        ])
    }
}

private final class DetailRowView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let dividerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: InvestmentTradeConfirmationDetailItem, showsDivider: Bool) {
        titleLabel.text = item.title
        valueLabel.text = item.value
        valueLabel.textColor = item.valueColor
        dividerView.isHidden = !showsDivider
    }

    private func configureView() {
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = AppColor.secondaryText
        titleLabel.numberOfLines = 2

        valueLabel.font = .systemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = AppColor.primaryText
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 2

        dividerView.backgroundColor = AppColor.divider
    }

    private func buildHierarchy() {
        [titleLabel, valueLabel, dividerView].forEach(addSubview)
    }

    private func setupLayout() {
        [titleLabel, valueLabel, dividerView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant: -14),
            titleLabel.widthAnchor.constraint(equalToConstant: 108),

            valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
