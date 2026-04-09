import UIKit

// tek bir varlık kartı
final class InvestmentPortfolioAssetRowView: UIView {
    private let containerView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let valueLabel = UILabel()
    private let profitLossLabel = UILabel()

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
        containerView.layer.cornerRadius = 20
        iconContainerView.layer.cornerRadius = 25
    }
}

extension InvestmentPortfolioAssetRowView {
    func configure(with item: InvestmentPortfolioAssetItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        valueLabel.text = item.totalValueText
        profitLossLabel.text = item.profitLossText
        profitLossLabel.textColor = item.isProfit ? AppColor.successStrong : AppColor.dangerStrong
        iconImageView.image = UIImage(systemName: item.iconName)
        iconImageView.tintColor = item.accentColor
        iconContainerView.backgroundColor = item.iconSurfaceColor
    }

    private func configureView() {
        backgroundColor = .clear

        containerView.backgroundColor = AppColor.surfaceMuted

        iconImageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.numberOfLines = 2

        valueLabel.font = .systemFont(ofSize: 22, weight: .bold)
        valueLabel.textColor = AppColor.primaryText
        valueLabel.textAlignment = .right

        profitLossLabel.font = .systemFont(ofSize: 14, weight: .bold)
        profitLossLabel.textAlignment = .right
    }

    private func buildHierarchy() {
        addSubview(containerView)
        [iconContainerView, titleLabel, subtitleLabel, valueLabel, profitLossLabel].forEach(containerView.addSubview)
        iconContainerView.addSubview(iconImageView)
    }

    private func setupLayout() {
        [containerView, iconContainerView, iconImageView, titleLabel, subtitleLabel, valueLabel, profitLossLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 50),
            iconContainerView.heightAnchor.constraint(equalToConstant: 50),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -12),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: profitLossLabel.leadingAnchor, constant: -12),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),

            valueLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            profitLossLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 6),
            profitLossLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            profitLossLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }
}
