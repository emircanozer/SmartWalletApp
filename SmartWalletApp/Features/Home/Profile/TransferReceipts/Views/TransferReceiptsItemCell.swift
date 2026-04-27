import UIKit

final class TransferReceiptsItemCell: UITableViewCell {
    static let reuseIdentifier = "TransferReceiptsItemCell"

    var onDetailTap: (() -> Void)?

    private let cardView = UIView()
    private let iconWrapper = UIView()
    private let iconView = UIImageView()
    private let typeLabel = UILabel()
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()
    private let detailButton = UIButton(type: .system)

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

extension TransferReceiptsItemCell {
    func configure(with item: TransferReceiptsItemViewData) {
        iconWrapper.backgroundColor = item.iconBackgroundColor
        iconView.image = UIImage(systemName: item.iconName)
        iconView.tintColor = item.iconTintColor
        typeLabel.text = item.typeText
        titleLabel.text = item.titleText
        amountLabel.text = item.amountText
        amountLabel.textColor = item.amountColor
        dateLabel.text = item.dateText
        detailButton.setTitle(item.detailButtonTitleText, for: .normal)
    }

    private func configureView() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = AppColor.whitePrimary
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowRadius = 16
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)

        iconView.contentMode = .scaleAspectFit

        typeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        typeLabel.textColor = AppColor.accentOlive

        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.numberOfLines = 2

        amountLabel.font = .systemFont(ofSize: 17, weight: .bold)
        amountLabel.textAlignment = .right
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)

        dateLabel.font = .systemFont(ofSize: 14, weight: .medium)
        dateLabel.textColor = AppColor.secondaryText

        detailButton.setTitleColor(AppColor.accentOlive, for: .normal)
        detailButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        detailButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        detailButton.setContentHuggingPriority(.required, for: .horizontal)
        detailButton.addTarget(self, action: #selector(handleDetailTap), for: .touchUpInside)
    }

    private func buildHierarchy() {
        contentView.addSubview(cardView)
        [iconWrapper, typeLabel, titleLabel, amountLabel, dateLabel, detailButton].forEach(cardView.addSubview)
        iconWrapper.addSubview(iconView)
    }

    private func setupLayout() {
        [cardView, iconWrapper, iconView, typeLabel, titleLabel, amountLabel, dateLabel, detailButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            iconWrapper.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            iconWrapper.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            iconWrapper.widthAnchor.constraint(equalToConstant: 48),
            iconWrapper.heightAnchor.constraint(equalToConstant: 48),

            iconView.centerXAnchor.constraint(equalTo: iconWrapper.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconWrapper.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),

            typeLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            typeLabel.leadingAnchor.constraint(equalTo: iconWrapper.trailingAnchor, constant: 14),
            typeLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -12),

            titleLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -12),

            amountLabel.topAnchor.constraint(equalTo: typeLabel.topAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            dateLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: detailButton.leadingAnchor, constant: -18),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),

            detailButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            detailButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18)
        ])
    }

    @objc private func handleDetailTap() {
        onDetailTap?()
    }
}
