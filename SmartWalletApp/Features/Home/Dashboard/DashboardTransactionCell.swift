import UIKit

class DashboardTransactionCell: UITableViewCell {
    static let reuseIdentifier = "DashboardTransactionCell"

    private let cardView = UIView()
    private let iconWrapper = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let badgeLabel = PaddingLabel()
    private let amountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.cornerRadius = 24
        iconWrapper.layer.cornerRadius = iconWrapper.bounds.width / 2
    }
}

extension DashboardTransactionCell {
    // tanımladığım dosyadaki struct modeli item ile. ulaşıp özelliklerini table da aktarıyorum
    func configure(with item: DashboardTransaction) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        dateLabel.text = item.dateText
        badgeLabel.text = item.categoryBadgeText
        amountLabel.text = item.amountText
        amountLabel.textColor = item.isIncome
            ? UIColor(red: 0.33, green: 0.73, blue: 0.4, alpha: 1.0)
            : UIColor(red: 0.87, green: 0.27, blue: 0.23, alpha: 1.0)

        iconWrapper.backgroundColor = item.category.iconBackgroundColor
        iconView.image = UIImage(systemName: item.category.iconName)
        iconView.tintColor = item.category.iconTintColor
    }

    func configureView() {
        backgroundColor = .white
        selectionStyle = .none

        cardView.backgroundColor = .white
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 16
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)

        iconView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.18, green: 0.19, blue: 0.25, alpha: 1.0)
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.4, green: 0.42, blue: 0.48, alpha: 1.0)
        subtitleLabel.numberOfLines = 1

        dateLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        dateLabel.textColor = UIColor(red: 0.48, green: 0.5, blue: 0.56, alpha: 1.0)

        badgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        badgeLabel.textColor = UIColor(red: 0.34, green: 0.36, blue: 0.41, alpha: 1.0)
        badgeLabel.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.97, alpha: 1.0)
        badgeLabel.clipsToBounds = true

        amountLabel.font = .systemFont(ofSize: 20, weight: .bold)
        amountLabel.textAlignment = .right
    }

    func buildHierarchy() {
        contentView.addSubview(cardView)
        cardView.addSubview(iconWrapper)
        iconWrapper.addSubview(iconView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(badgeLabel)
        cardView.addSubview(amountLabel)
    }

    func setupLayout() {
        [cardView, iconWrapper, iconView, titleLabel, subtitleLabel, dateLabel, badgeLabel, amountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            iconWrapper.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            iconWrapper.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconWrapper.widthAnchor.constraint(equalToConstant: 44),
            iconWrapper.heightAnchor.constraint(equalToConstant: 44),

            iconView.centerXAnchor.constraint(equalTo: iconWrapper.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconWrapper.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: iconWrapper.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -12),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -12),

            dateLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),

            badgeLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            badgeLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),

            amountLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            amountLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12)
        ])
    }
}

private final class PaddingLabel: UILabel {
    private let contentInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + contentInsets.left + contentInsets.right,
            height: size.height + contentInsets.top + contentInsets.bottom
        )
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
