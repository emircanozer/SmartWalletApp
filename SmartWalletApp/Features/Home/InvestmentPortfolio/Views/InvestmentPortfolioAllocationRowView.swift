import UIKit

// tek bir dağılım bar satırı
// contentView çok şişmesin diye
final class InvestmentPortfolioAllocationRowView: UIView {
    private let titleLabel = UILabel()
    private let percentageLabel = UILabel()
    private let trackView = UIView()
    private let fillView = UIView()
    private var fillWidthConstraint: NSLayoutConstraint?
    private var progress: CGFloat = 0

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
        updateFillWidth()
    }
}

extension InvestmentPortfolioAllocationRowView {
    func configure(with item: InvestmentPortfolioAllocationItem) {
        titleLabel.text = item.title
        percentageLabel.text = item.percentageText
        fillView.backgroundColor = item.color
        progress = max(0, min(item.progress, 1))
        setNeedsLayout()
    }

    private func configureView() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = AppColor.primaryText

        percentageLabel.font = .systemFont(ofSize: 15, weight: .bold)
        percentageLabel.textColor = AppColor.accentOlive
        percentageLabel.textAlignment = .right

        trackView.backgroundColor = AppColor.divider
        trackView.layer.cornerRadius = 3.5

        fillView.layer.cornerRadius = 3.5
    }

    private func buildHierarchy() {
        [titleLabel, percentageLabel, trackView].forEach(addSubview)
        trackView.addSubview(fillView)
    }

    private func setupLayout() {
        [titleLabel, percentageLabel, trackView, fillView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        fillWidthConstraint = fillView.widthAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            percentageLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            percentageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            percentageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),

            trackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            trackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trackView.heightAnchor.constraint(equalToConstant: 7),
            trackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            fillView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            fillView.topAnchor.constraint(equalTo: trackView.topAnchor),
            fillView.bottomAnchor.constraint(equalTo: trackView.bottomAnchor),
            fillWidthConstraint!
        ])
    }

    private func updateFillWidth() {
        let width = trackView.bounds.width * progress
        fillWidthConstraint?.constant = width
    }
}
