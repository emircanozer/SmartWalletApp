import UIKit

// alt kısımdaki kategoriler için 
final class ExpenseAnalysisCategoryRowView: UIView {
    private let colorDot = UIView()
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    private let percentageLabel = UILabel()
    private let progressTrack = UIView()
    private let progressFill = UIView()
    private var progressWidthConstraint: NSLayoutConstraint?
    private var currentProgress: CGFloat = 0

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
        colorDot.layer.cornerRadius = colorDot.bounds.height / 2
        progressTrack.layer.cornerRadius = progressTrack.bounds.height / 2
        progressFill.layer.cornerRadius = progressFill.bounds.height / 2
        let trackWidth = progressTrack.bounds.width
        let visibleProgress = max(currentProgress, 0)
        progressWidthConstraint?.constant = max(trackWidth * visibleProgress, visibleProgress > 0 ? 12 : 0)
    }
}

extension ExpenseAnalysisCategoryRowView {
    func configure(with item: ExpenseAnalysisCategoryItem) {
        colorDot.backgroundColor = item.color
        titleLabel.text = item.name
        amountLabel.text = item.amountText
        percentageLabel.text = item.percentageText
        progressFill.backgroundColor = item.color
        currentProgress = item.progress
        setNeedsLayout()
    }
}

 extension ExpenseAnalysisCategoryRowView {
    func configureView() {
        backgroundColor = .clear

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = AppColor.primaryText

        amountLabel.font = .systemFont(ofSize: 16, weight: .bold)
        amountLabel.textColor = AppColor.primaryText
        amountLabel.textAlignment = .right

        percentageLabel.font = .systemFont(ofSize: 15, weight: .medium)
        percentageLabel.textColor = AppColor.secondaryText
        percentageLabel.textAlignment = .right

        progressTrack.backgroundColor = AppColor.borderSoft
        progressFill.backgroundColor = AppColor.accentBlue
    }

    func buildHierarchy() {
        [colorDot, titleLabel, amountLabel, percentageLabel, progressTrack].forEach(addSubview)
        progressTrack.addSubview(progressFill)
    }

    func setupLayout() {
        [colorDot, titleLabel, amountLabel, percentageLabel, progressTrack, progressFill].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        progressWidthConstraint = progressFill.widthAnchor.constraint(equalToConstant: 24)

        NSLayoutConstraint.activate([
            colorDot.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            colorDot.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorDot.widthAnchor.constraint(equalToConstant: 8),
            colorDot.heightAnchor.constraint(equalToConstant: 8),

            titleLabel.centerYAnchor.constraint(equalTo: colorDot.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: colorDot.trailingAnchor, constant: 10),

            percentageLabel.centerYAnchor.constraint(equalTo: colorDot.centerYAnchor),
            percentageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            amountLabel.centerYAnchor.constraint(equalTo: colorDot.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: percentageLabel.leadingAnchor, constant: -12),

            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -12),

            progressTrack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            progressTrack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressTrack.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressTrack.heightAnchor.constraint(equalToConstant: 10),
            progressTrack.bottomAnchor.constraint(equalTo: bottomAnchor),

            progressFill.leadingAnchor.constraint(equalTo: progressTrack.leadingAnchor),
            progressFill.topAnchor.constraint(equalTo: progressTrack.topAnchor),
            progressFill.bottomAnchor.constraint(equalTo: progressTrack.bottomAnchor),
            progressWidthConstraint!
        ])
    }
}
