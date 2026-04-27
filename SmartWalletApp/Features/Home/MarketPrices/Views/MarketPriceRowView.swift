import UIKit


// piyasa satırının tasarımı burada
final class MarketPriceRowView: UIView {
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let assetTitleLabel = UILabel()
    private let assetSubtitleLabel = UILabel()
    private let assetStack = UIStackView()
    private let buyPriceLabel = UILabel()
    private let sellPriceLabel = UILabel()
    private let changeBadgeView = UIView()
    private let changeLabel = UILabel()
    private let separatorView = UIView()

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
        iconContainerView.layer.cornerRadius = iconContainerView.bounds.height / 2
        changeBadgeView.layer.cornerRadius = changeBadgeView.bounds.height / 2
    }
}

extension MarketPriceRowView {
    func configure(with item: MarketPriceItem, showsSeparator: Bool) {
        iconImageView.image = UIImage(systemName: item.iconName)
        iconImageView.tintColor = item.accentColor
        iconContainerView.backgroundColor = item.iconSurfaceColor
        assetTitleLabel.text = item.title
        assetSubtitleLabel.text = item.subtitle
        buyPriceLabel.text = item.buyPriceText
        sellPriceLabel.text = item.sellPriceText
        changeLabel.text = item.dailyChangeText
        changeLabel.textColor = item.isPositiveChange ? AppColor.successStrong : AppColor.dangerStrong
        changeBadgeView.backgroundColor = item.isPositiveChange ? AppColor.successSurface : AppColor.dangerSurface
        separatorView.isHidden = !showsSeparator
    }
}

extension MarketPriceRowView {
    func configureView() {
        backgroundColor = .clear

        assetStack.axis = .vertical
        assetStack.spacing = 4

        iconImageView.contentMode = .scaleAspectFit

        assetTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        assetTitleLabel.textColor = AppColor.primaryText

        assetSubtitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        assetSubtitleLabel.textColor = AppColor.secondaryText

        [buyPriceLabel, sellPriceLabel].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.textColor = AppColor.primaryText
            $0.textAlignment = .right
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
        }

        changeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        changeLabel.textAlignment = .center
        changeLabel.adjustsFontSizeToFitWidth = true
        changeLabel.minimumScaleFactor = 0.75

        changeBadgeView.clipsToBounds = true
        separatorView.backgroundColor = AppColor.divider
    }

    func buildHierarchy() {
        [assetTitleLabel, assetSubtitleLabel].forEach(assetStack.addArrangedSubview)
        iconContainerView.addSubview(iconImageView)
        changeBadgeView.addSubview(changeLabel)
        [iconContainerView, assetStack, buyPriceLabel, sellPriceLabel, changeBadgeView, separatorView].forEach(addSubview)
    }

    func setupLayout() {
        [iconContainerView, iconImageView, assetStack, buyPriceLabel, sellPriceLabel, changeBadgeView, changeLabel, separatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 68),

            iconContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            iconContainerView.widthAnchor.constraint(equalToConstant: 36),
            iconContainerView.heightAnchor.constraint(equalToConstant: 36),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),

            assetStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            assetStack.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 10),
            assetStack.widthAnchor.constraint(equalToConstant: 56),

            buyPriceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            buyPriceLabel.leadingAnchor.constraint(equalTo: assetStack.trailingAnchor, constant: 10),
            buyPriceLabel.widthAnchor.constraint(equalToConstant: 68),

            sellPriceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sellPriceLabel.leadingAnchor.constraint(equalTo: buyPriceLabel.trailingAnchor, constant: 10),
            sellPriceLabel.widthAnchor.constraint(equalToConstant: 68),

            changeBadgeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            changeBadgeView.leadingAnchor.constraint(equalTo: sellPriceLabel.trailingAnchor, constant: 10),
            changeBadgeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            changeBadgeView.heightAnchor.constraint(equalToConstant: 28),

            changeLabel.topAnchor.constraint(equalTo: changeBadgeView.topAnchor),
            changeLabel.leadingAnchor.constraint(equalTo: changeBadgeView.leadingAnchor, constant: 6),
            changeLabel.trailingAnchor.constraint(equalTo: changeBadgeView.trailingAnchor, constant: -6),
            changeLabel.bottomAnchor.constraint(equalTo: changeBadgeView.bottomAnchor),

            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
