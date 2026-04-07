import UIKit

final class TransferSuccessContentView: UIView {
    let returnHomeButton = UIButton(type: .system)
    let receiptButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let statusView = TransferSuccessIndicatorView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let detailCard = UIView()
    private let dateTitleLabel = UILabel()
    private let dateValueLabel = UILabel()
    private let dateDivider = UIView()
    private let referenceTitleLabel = UILabel()
    private let referenceValueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
        applyStaticContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        detailCard.layer.cornerRadius = 24
        returnHomeButton.layer.cornerRadius = returnHomeButton.bounds.height / 2
    }
}

extension TransferSuccessContentView {
    func applyData(_ data: TransferSuccessViewData) {
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText
        dateValueLabel.text = data.transactionDateText
        referenceValueLabel.text = data.referenceNumberText
    }
}

 extension TransferSuccessContentView {
    func configureView() {
        backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.textAlignment = .center

        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = AppColor.bodyText
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        detailCard.backgroundColor = .white
        detailCard.layer.shadowColor = UIColor.black.cgColor
        detailCard.layer.shadowOpacity = 0.05
        detailCard.layer.shadowRadius = 18
        detailCard.layer.shadowOffset = CGSize(width: 0, height: 10)

        [dateTitleLabel, referenceTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 11, weight: .bold)
            $0.textColor = AppColor.placeholderText
        }

        [dateValueLabel, referenceValueLabel].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .bold)
            $0.textColor = AppColor.primaryText
            $0.textAlignment = .right
        }

        dateDivider.backgroundColor = AppColor.divider

        returnHomeButton.backgroundColor = AppColor.darkSurface
        returnHomeButton.setTitleColor(.white, for: .normal)
        returnHomeButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        receiptButton.setTitleColor(AppColor.accentOlive, for: .normal)
        receiptButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)

        [statusView, titleLabel, subtitleLabel, detailCard, returnHomeButton, receiptButton].forEach {
            containerView.addSubview($0)
        }

        [dateTitleLabel, dateValueLabel, dateDivider, referenceTitleLabel, referenceValueLabel].forEach {
            detailCard.addSubview($0)
        }
    }

    func setupLayout() {
        [
            scrollView,
            containerView,
            statusView,
            titleLabel,
            subtitleLabel,
            detailCard,
            dateTitleLabel,
            dateValueLabel,
            dateDivider,
            referenceTitleLabel,
            referenceValueLabel,
            returnHomeButton,
            receiptButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            statusView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 36),
            statusView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            statusView.widthAnchor.constraint(equalToConstant: 132),
            statusView.heightAnchor.constraint(equalToConstant: 132),

            titleLabel.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 36),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -36),

            detailCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28),
            detailCard.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            detailCard.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            dateTitleLabel.topAnchor.constraint(equalTo: detailCard.topAnchor, constant: 20),
            dateTitleLabel.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor, constant: 20),

            dateValueLabel.centerYAnchor.constraint(equalTo: dateTitleLabel.centerYAnchor),
            dateValueLabel.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor, constant: -20),
            dateValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: dateTitleLabel.trailingAnchor, constant: 12),

            dateDivider.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 18),
            dateDivider.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor, constant: 20),
            dateDivider.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor, constant: -20),
            dateDivider.heightAnchor.constraint(equalToConstant: 1),

            referenceTitleLabel.topAnchor.constraint(equalTo: dateDivider.bottomAnchor, constant: 18),
            referenceTitleLabel.leadingAnchor.constraint(equalTo: dateTitleLabel.leadingAnchor),
            referenceTitleLabel.bottomAnchor.constraint(equalTo: detailCard.bottomAnchor, constant: -20),

            referenceValueLabel.centerYAnchor.constraint(equalTo: referenceTitleLabel.centerYAnchor),
            referenceValueLabel.trailingAnchor.constraint(equalTo: dateValueLabel.trailingAnchor),
            referenceValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: referenceTitleLabel.trailingAnchor, constant: 12),

            returnHomeButton.topAnchor.constraint(equalTo: detailCard.bottomAnchor, constant: 36),
            returnHomeButton.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor),
            returnHomeButton.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor),
            returnHomeButton.heightAnchor.constraint(equalToConstant: 56),

            receiptButton.topAnchor.constraint(equalTo: returnHomeButton.bottomAnchor, constant: 18),
            receiptButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            receiptButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -28)
        ])
    }

    func applyStaticContent() {
        dateTitleLabel.text = "İŞLEM TARİHİ"
        referenceTitleLabel.text = "REFERANS NO"
        returnHomeButton.setTitle("Ana Sayfaya Dön", for: .normal)
        receiptButton.setTitle("DEKONTU GÖRÜNTÜLE", for: .normal)
    }
}
