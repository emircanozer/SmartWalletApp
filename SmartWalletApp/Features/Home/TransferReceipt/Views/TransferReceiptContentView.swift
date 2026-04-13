import UIKit

final class TransferReceiptContentView: UIView {
    let downloadButton = UIButton(type: .system)
    let shareButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let logoImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let detailCard = UIView()
    private let senderTitleLabel = UILabel()
    private let senderValueLabel = UILabel()
    private let receiverTitleLabel = UILabel()
    private let receiverValueLabel = UILabel()
    private let ibanTitleLabel = UILabel()
    private let ibanValueLabel = UILabel()
    private let amountTitleLabel = UILabel()
    private let amountValueLabel = UILabel()
    private let dateTitleLabel = UILabel()
    private let dateValueLabel = UILabel()
    private let referenceTitleLabel = UILabel()
    private let referenceValueLabel = UILabel()
    private let categoryTitleLabel = UILabel()
    private let categoryValueLabel = UILabel()
    private let noteContainerView = UIView()
    private let noteAccentView = UIView()
    private let noteTitleLabel = UILabel()
    private let noteValueLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

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
        detailCard.layer.cornerRadius = 28
        noteContainerView.layer.cornerRadius = 18
        downloadButton.layer.cornerRadius = downloadButton.bounds.height / 2
        logoImageView.layer.cornerRadius = 14
    }
}
// case'Den aldığımız veriyi ekrana basıyoruz
extension TransferReceiptContentView {
    func applyData(_ data: TransferReceiptViewData) {
        senderValueLabel.text = data.senderNameText
        receiverValueLabel.text = data.receiverNameText
        ibanValueLabel.text = data.ibanText
        amountValueLabel.text = data.amountText
        dateValueLabel.text = data.transactionDateText
        referenceValueLabel.text = data.referenceNumberText
        categoryValueLabel.text = data.categoryTitleText
        noteValueLabel.text = data.noteText
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }

        downloadButton.isEnabled = !isLoading
        shareButton.isEnabled = !isLoading
        detailCard.alpha = isLoading ? 0.75 : 1
    }
}

 extension TransferReceiptContentView {
    func configureView() {
        backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false

        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true

        appNameLabel.font = .systemFont(ofSize: 27, weight: .bold)
        appNameLabel.textAlignment = .left
        appNameLabel.numberOfLines = 1

        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.textAlignment = .center

        subtitleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        subtitleLabel.textColor = AppColor.receiptSubtitle
        subtitleLabel.textAlignment = .center

        detailCard.backgroundColor = .white
        detailCard.layer.shadowColor = UIColor.black.cgColor
        detailCard.layer.shadowOpacity = 0.06
        detailCard.layer.shadowRadius = 22
        detailCard.layer.shadowOffset = CGSize(width: 0, height: 10)

        [senderTitleLabel, receiverTitleLabel, ibanTitleLabel, amountTitleLabel, dateTitleLabel, referenceTitleLabel, categoryTitleLabel, noteTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 11, weight: .bold)
            $0.textColor = AppColor.receiptLabel
        }

        [senderValueLabel, receiverValueLabel, amountValueLabel, dateValueLabel, categoryValueLabel].forEach {
            $0.font = .systemFont(ofSize: 16, weight: .bold)
            $0.textColor = AppColor.primaryText
            $0.textAlignment = .right
            $0.numberOfLines = 1
        }

        amountValueLabel.font = .systemFont(ofSize: 24, weight: .bold)

        referenceValueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        referenceValueLabel.textColor = AppColor.accentOlive
        referenceValueLabel.textAlignment = .right

        ibanValueLabel.font = .monospacedSystemFont(ofSize: 14, weight: .medium)
        ibanValueLabel.textColor = AppColor.bodyText
        ibanValueLabel.numberOfLines = 0

        noteContainerView.backgroundColor = AppColor.surfaceMuted
        noteAccentView.backgroundColor = AppColor.noteAccent
        noteValueLabel.font = .systemFont(ofSize: 15, weight: .medium)
        noteValueLabel.textColor = AppColor.verificationFilledText
        noteValueLabel.numberOfLines = 0

        downloadButton.backgroundColor = AppColor.buttonGray
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        shareButton.setTitleColor(AppColor.accentOlive, for: .normal)
        shareButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)

        activityIndicator.hidesWhenStopped = true
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)

        [logoImageView, appNameLabel, titleLabel, subtitleLabel, detailCard, downloadButton, shareButton, activityIndicator].forEach {
            containerView.addSubview($0)
        }

        [
            senderTitleLabel,
            senderValueLabel,
            receiverTitleLabel,
            receiverValueLabel,
            ibanTitleLabel,
            ibanValueLabel,
            amountTitleLabel,
            amountValueLabel,
            dateTitleLabel,
            dateValueLabel,
            referenceTitleLabel,
            referenceValueLabel,
            categoryTitleLabel,
            categoryValueLabel,
            noteContainerView
        ].forEach {
            detailCard.addSubview($0)
        }

        [noteAccentView, noteTitleLabel, noteValueLabel].forEach {
            noteContainerView.addSubview($0)
        }
    }

    func setupLayout() {
        [
            scrollView, containerView, logoImageView, appNameLabel, titleLabel, subtitleLabel, detailCard, senderTitleLabel,
            senderValueLabel, receiverTitleLabel, receiverValueLabel, ibanTitleLabel, ibanValueLabel,
            amountTitleLabel, amountValueLabel, dateTitleLabel, dateValueLabel, referenceTitleLabel,
            referenceValueLabel, categoryTitleLabel, categoryValueLabel, noteContainerView, noteAccentView,
            noteTitleLabel, noteValueLabel, downloadButton, shareButton, activityIndicator
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

            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            logoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            logoImageView.widthAnchor.constraint(equalToConstant: 52),
            logoImageView.heightAnchor.constraint(equalToConstant: 52),

            appNameLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            appNameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 14),
            appNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -24),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            detailCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            detailCard.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            detailCard.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            senderTitleLabel.topAnchor.constraint(equalTo: detailCard.topAnchor, constant: 20),
            senderTitleLabel.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor, constant: 18),
            senderValueLabel.centerYAnchor.constraint(equalTo: senderTitleLabel.centerYAnchor),
            senderValueLabel.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor, constant: -18),
            senderValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: senderTitleLabel.trailingAnchor, constant: 12),

            receiverTitleLabel.topAnchor.constraint(equalTo: senderTitleLabel.bottomAnchor, constant: 24),
            receiverTitleLabel.leadingAnchor.constraint(equalTo: senderTitleLabel.leadingAnchor),
            receiverValueLabel.centerYAnchor.constraint(equalTo: receiverTitleLabel.centerYAnchor),
            receiverValueLabel.trailingAnchor.constraint(equalTo: senderValueLabel.trailingAnchor),
            receiverValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: receiverTitleLabel.trailingAnchor, constant: 12),

            ibanTitleLabel.topAnchor.constraint(equalTo: receiverTitleLabel.bottomAnchor, constant: 24),
            ibanTitleLabel.leadingAnchor.constraint(equalTo: senderTitleLabel.leadingAnchor),
            ibanValueLabel.topAnchor.constraint(equalTo: ibanTitleLabel.bottomAnchor, constant: 10),
            ibanValueLabel.leadingAnchor.constraint(equalTo: ibanTitleLabel.leadingAnchor),
            ibanValueLabel.trailingAnchor.constraint(equalTo: senderValueLabel.trailingAnchor),

            amountTitleLabel.topAnchor.constraint(equalTo: ibanValueLabel.bottomAnchor, constant: 24),
            amountTitleLabel.leadingAnchor.constraint(equalTo: senderTitleLabel.leadingAnchor),
            amountValueLabel.centerYAnchor.constraint(equalTo: amountTitleLabel.centerYAnchor),
            amountValueLabel.trailingAnchor.constraint(equalTo: senderValueLabel.trailingAnchor),

            dateTitleLabel.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor, constant: 28),
            dateTitleLabel.leadingAnchor.constraint(equalTo: senderTitleLabel.leadingAnchor),
            dateValueLabel.centerYAnchor.constraint(equalTo: dateTitleLabel.centerYAnchor),
            dateValueLabel.trailingAnchor.constraint(equalTo: senderValueLabel.trailingAnchor),

            referenceTitleLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 24),
            referenceTitleLabel.leadingAnchor.constraint(equalTo: senderTitleLabel.leadingAnchor),
            referenceValueLabel.centerYAnchor.constraint(equalTo: referenceTitleLabel.centerYAnchor),
            referenceValueLabel.trailingAnchor.constraint(equalTo: senderValueLabel.trailingAnchor),

            categoryTitleLabel.topAnchor.constraint(equalTo: referenceTitleLabel.bottomAnchor, constant: 24),
            categoryTitleLabel.leadingAnchor.constraint(equalTo: senderTitleLabel.leadingAnchor),
            categoryValueLabel.centerYAnchor.constraint(equalTo: categoryTitleLabel.centerYAnchor),
            categoryValueLabel.trailingAnchor.constraint(equalTo: senderValueLabel.trailingAnchor),

            noteContainerView.topAnchor.constraint(equalTo: categoryTitleLabel.bottomAnchor, constant: 24),
            noteContainerView.leadingAnchor.constraint(equalTo: senderTitleLabel.leadingAnchor),
            noteContainerView.trailingAnchor.constraint(equalTo: senderValueLabel.trailingAnchor),
            noteContainerView.bottomAnchor.constraint(equalTo: detailCard.bottomAnchor, constant: -18),
            noteContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 88),

            noteAccentView.leadingAnchor.constraint(equalTo: noteContainerView.leadingAnchor),
            noteAccentView.topAnchor.constraint(equalTo: noteContainerView.topAnchor),
            noteAccentView.bottomAnchor.constraint(equalTo: noteContainerView.bottomAnchor),
            noteAccentView.widthAnchor.constraint(equalToConstant: 3),

            noteTitleLabel.topAnchor.constraint(equalTo: noteContainerView.topAnchor, constant: 12),
            noteTitleLabel.leadingAnchor.constraint(equalTo: noteContainerView.leadingAnchor, constant: 14),
            noteTitleLabel.trailingAnchor.constraint(equalTo: noteContainerView.trailingAnchor, constant: -14),

            noteValueLabel.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 8),
            noteValueLabel.leadingAnchor.constraint(equalTo: noteTitleLabel.leadingAnchor),
            noteValueLabel.trailingAnchor.constraint(equalTo: noteTitleLabel.trailingAnchor),
            noteValueLabel.bottomAnchor.constraint(equalTo: noteContainerView.bottomAnchor, constant: -14),

            downloadButton.topAnchor.constraint(equalTo: detailCard.bottomAnchor, constant: 28),
            downloadButton.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor),
            downloadButton.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 56),

            shareButton.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 16),
            shareButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -28),

            activityIndicator.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor)
        ])
    }

    func applyStaticContent() {
        let fullText = "SmartWallet AI"
        let attributed = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 27, weight: .bold),
                .foregroundColor: AppColor.primaryText
            ]
        )
        if let aiRange = fullText.range(of: "AI") {
            attributed.addAttributes([
                .foregroundColor: AppColor.accentGold
            ], range: NSRange(aiRange, in: fullText))
        }
        appNameLabel.attributedText = attributed
        titleLabel.text = "İşlem Detayı"
        subtitleLabel.text = "İŞLEM BAŞARIYLA GERÇEKLEŞTİ"
        senderTitleLabel.text = "GÖNDEREN"
        receiverTitleLabel.text = "ALICI"
        ibanTitleLabel.text = "IBAN"
        amountTitleLabel.text = "TUTAR"
        dateTitleLabel.text = "İŞLEM TARİHİ"
        referenceTitleLabel.text = "REFERANS NO"
        categoryTitleLabel.text = "İŞLEM TÜRÜ"
        noteTitleLabel.text = "İŞLEM NOTU"
        downloadButton.setTitle("PDF Olarak İndir", for: .normal)
        shareButton.setTitle("PAYLAŞ", for: .normal)
    }
}
