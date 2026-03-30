import UIKit

class DashboardTransactionCell: UITableViewCell {
    static let reuseIdentifier = "DashboardTransactionCell"

    private let cardView = UIView()
    private let iconWrapper = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
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
        titleLabel.text = item.category.title
        dateLabel.text = item.dateText
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

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.18, green: 0.19, blue: 0.25, alpha: 1.0)

        dateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dateLabel.textColor = UIColor(red: 0.41, green: 0.42, blue: 0.47, alpha: 1.0)

        amountLabel.font = .systemFont(ofSize: 20, weight: .bold)
        amountLabel.textAlignment = .right
    }

    func buildHierarchy() {
        contentView.addSubview(cardView)
        cardView.addSubview(iconWrapper)
        iconWrapper.addSubview(iconView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(amountLabel)
    }

    func setupLayout() {
        [cardView, iconWrapper, iconView, titleLabel, dateLabel, amountLabel].forEach {
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

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: iconWrapper.trailingAnchor, constant: 14),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            amountLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12)
        ])
    }
}
