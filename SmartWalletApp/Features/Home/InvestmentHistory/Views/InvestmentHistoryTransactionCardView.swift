import UIKit

final class InvestmentHistoryTransactionCardView: UIView {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let amountLabel = UILabel()
    private let totalPriceLabel = UILabel()
    private let transactionTypeLabel = UILabel()
    private let leftStack = UIStackView()
    private let rightStack = UIStackView()

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
        layer.cornerRadius = 24
    }
}

extension InvestmentHistoryTransactionCardView {
    func configure(with item: InvestmentHistoryTransactionItem) {
        titleLabel.text = item.assetName
        dateLabel.text = item.dateText
        amountLabel.text = item.amountText
        totalPriceLabel.text = item.totalPriceText
        transactionTypeLabel.text = item.transactionTypeText
        transactionTypeLabel.textColor = item.transactionTypeColor
    }
}

extension InvestmentHistoryTransactionCardView {
    func configureView() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 18
        layer.shadowOffset = CGSize(width: 0, height: 8)

        titleLabel.font = .systemFont(ofSize: 21, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.82
        titleLabel.numberOfLines = 1

        dateLabel.font = .systemFont(ofSize: 12, weight: .medium)
        dateLabel.textColor = AppColor.secondaryText

        amountLabel.font = .systemFont(ofSize: 18, weight: .bold)
        amountLabel.textColor = AppColor.primaryText
        amountLabel.textAlignment = .right
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.minimumScaleFactor = 0.8

        totalPriceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        totalPriceLabel.textColor = AppColor.primaryText
        totalPriceLabel.textAlignment = .right
        totalPriceLabel.adjustsFontSizeToFitWidth = true
        totalPriceLabel.minimumScaleFactor = 0.8

        transactionTypeLabel.font = .systemFont(ofSize: 17, weight: .bold)
        transactionTypeLabel.textAlignment = .left

        leftStack.axis = .vertical
        leftStack.spacing = 8
        leftStack.alignment = .leading

        rightStack.axis = .vertical
        rightStack.spacing = 8
        rightStack.alignment = .trailing

        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        totalPriceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func buildHierarchy() {
        [leftStack, rightStack, transactionTypeLabel].forEach(addSubview)
        [titleLabel, dateLabel].forEach(leftStack.addArrangedSubview)
        [amountLabel, totalPriceLabel].forEach(rightStack.addArrangedSubview)
    }

    func setupLayout() {
        [leftStack, rightStack, transactionTypeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            leftStack.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            leftStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            rightStack.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            rightStack.leadingAnchor.constraint(greaterThanOrEqualTo: leftStack.trailingAnchor, constant: 16),
            rightStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            rightStack.widthAnchor.constraint(greaterThanOrEqualToConstant: 96),

            transactionTypeLabel.topAnchor.constraint(equalTo: leftStack.bottomAnchor, constant: 18),
            transactionTypeLabel.leadingAnchor.constraint(equalTo: leftStack.leadingAnchor),
            transactionTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            transactionTypeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22)
        ])
    }
}
