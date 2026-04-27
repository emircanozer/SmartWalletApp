import UIKit

final class ContactUsSuccessContentView: UIView {
    let backButton = UIButton(type: .system)
    let homeButton = UIButton(type: .system)
    let newMessageButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    private let headlineLabel = UILabel()
    private let bodyLabel = UILabel()
    private let infoCardView = UIView()
    private let infoIconView = UIImageView()
    private let infoLabel = UILabel()
    private let footerIconView = UIImageView()
    private let footerTitleLabel = UILabel()
    private let emailIconView = UIImageView()
    private let supportEmailTitleLabel = UILabel()
    private let supportEmailLabel = UILabel()

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
        infoCardView.layer.cornerRadius = 24
        homeButton.layer.cornerRadius = 18
        newMessageButton.layer.cornerRadius = 18
    }
}

extension ContactUsSuccessContentView {
    func apply(_ data: ContactUsSuccessViewData) {
        titleLabel.text = data.titleText
        headlineLabel.text = data.headlineText
        bodyLabel.text = data.bodyText
        infoLabel.text = data.infoText
        footerTitleLabel.text = data.footerTitleText
        footerTitleLabel.letterSpacing = 3
        supportEmailTitleLabel.text = data.supportEmailTitleText
        supportEmailLabel.text = data.supportEmailText
        homeButton.setTitle(data.homeButtonTitleText, for: .normal)
        newMessageButton.setTitle(data.newMessageButtonTitleText, for: .normal)
    }
}

 extension ContactUsSuccessContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.accentOlive

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        iconImageView.image = UIImage(named: "success3")
        iconImageView.contentMode = .scaleAspectFit

        headlineLabel.font = .systemFont(ofSize: 28, weight: .bold)
        headlineLabel.textColor = AppColor.primaryText
        headlineLabel.textAlignment = .center
        headlineLabel.numberOfLines = 2

        bodyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        bodyLabel.textColor = AppColor.bodyText
        bodyLabel.textAlignment = .center
        bodyLabel.numberOfLines = 0
        bodyLabel.setLineSpacing(6)

        infoCardView.backgroundColor = AppColor.whitePrimary
        infoCardView.layer.shadowColor = UIColor.black.cgColor
        infoCardView.layer.shadowOpacity = 0.04
        infoCardView.layer.shadowRadius = 18
        infoCardView.layer.shadowOffset = CGSize(width: 0, height: 10)

        infoIconView.image = UIImage(systemName: "info.circle")
        infoIconView.tintColor = AppColor.accentOlive
        infoIconView.contentMode = .scaleAspectFit

        infoLabel.font = .systemFont(ofSize: 15, weight: .medium)
        infoLabel.textColor = AppColor.bodyText
        infoLabel.numberOfLines = 0
        infoLabel.setLineSpacing(4)

        footerIconView.image = UIImage(systemName: "gearshape")
        footerIconView.tintColor = AppColor.secondaryText
        footerIconView.contentMode = .scaleAspectFit

        footerTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        footerTitleLabel.textColor = AppColor.secondaryText
        footerTitleLabel.numberOfLines = 2

        emailIconView.image = UIImage(systemName: "envelope")
        emailIconView.tintColor = AppColor.secondaryText
        emailIconView.contentMode = .scaleAspectFit

        supportEmailTitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        supportEmailTitleLabel.textColor = AppColor.bodyText

        supportEmailLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        supportEmailLabel.textColor = AppColor.accentOlive
        supportEmailLabel.numberOfLines = 1
        supportEmailLabel.adjustsFontSizeToFitWidth = true
        supportEmailLabel.minimumScaleFactor = 0.8

        homeButton.backgroundColor = AppColor.primaryYellow
        homeButton.setTitleColor(AppColor.primaryText, for: .normal)
        homeButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        newMessageButton.backgroundColor = AppColor.chipSurface
        newMessageButton.setTitleColor(AppColor.primaryText, for: .normal)
        newMessageButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            titleLabel,
            iconImageView,
            headlineLabel,
            bodyLabel,
            infoCardView,
            footerIconView,
            footerTitleLabel,
            emailIconView,
            supportEmailTitleLabel,
            supportEmailLabel,
            homeButton,
            newMessageButton
        ].forEach(contentContainer.addSubview)

        [infoIconView, infoLabel].forEach(infoCardView.addSubview)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            titleLabel,
            iconImageView,
            headlineLabel,
            bodyLabel,
            infoCardView,
            infoIconView,
            infoLabel,
            footerIconView,
            footerTitleLabel,
            emailIconView,
            supportEmailTitleLabel,
            supportEmailLabel,
            homeButton,
            newMessageButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            contentContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            iconImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 150),
            iconImageView.heightAnchor.constraint(equalToConstant: 150),

            headlineLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            headlineLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 28),
            headlineLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -28),

            bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 14),
            bodyLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 32),
            bodyLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -32),

            infoCardView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 18),
            infoCardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 32),
            infoCardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -32),

            infoIconView.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 22),
            infoIconView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 22),
            infoIconView.widthAnchor.constraint(equalToConstant: 20),
            infoIconView.heightAnchor.constraint(equalToConstant: 20),

            infoLabel.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: infoIconView.trailingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -22),
            infoLabel.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -20),

            footerIconView.topAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: 22),
            footerIconView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 36),
            footerIconView.widthAnchor.constraint(equalToConstant: 18),
            footerIconView.heightAnchor.constraint(equalToConstant: 18),

            footerTitleLabel.centerYAnchor.constraint(equalTo: footerIconView.centerYAnchor),
            footerTitleLabel.leadingAnchor.constraint(equalTo: footerIconView.trailingAnchor, constant: 12),
            footerTitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -36),

            emailIconView.topAnchor.constraint(equalTo: footerTitleLabel.bottomAnchor, constant: 10),
            emailIconView.leadingAnchor.constraint(equalTo: footerIconView.leadingAnchor),
            emailIconView.widthAnchor.constraint(equalToConstant: 18),
            emailIconView.heightAnchor.constraint(equalToConstant: 18),

            supportEmailTitleLabel.topAnchor.constraint(equalTo: emailIconView.topAnchor, constant: -2),
            supportEmailTitleLabel.leadingAnchor.constraint(equalTo: footerTitleLabel.leadingAnchor),
            supportEmailTitleLabel.trailingAnchor.constraint(equalTo: footerTitleLabel.trailingAnchor),

            supportEmailLabel.topAnchor.constraint(equalTo: supportEmailTitleLabel.bottomAnchor, constant: 4),
            supportEmailLabel.leadingAnchor.constraint(equalTo: supportEmailTitleLabel.leadingAnchor),
            supportEmailLabel.trailingAnchor.constraint(equalTo: supportEmailTitleLabel.trailingAnchor),

            homeButton.topAnchor.constraint(equalTo: supportEmailLabel.bottomAnchor, constant: 30),
            homeButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 32),
            homeButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -32),
            homeButton.heightAnchor.constraint(equalToConstant: 62),

            newMessageButton.topAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: 14),
            newMessageButton.leadingAnchor.constraint(equalTo: homeButton.leadingAnchor),
            newMessageButton.trailingAnchor.constraint(equalTo: homeButton.trailingAnchor),
            newMessageButton.heightAnchor.constraint(equalToConstant: 58),
            newMessageButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -34)
        ])
    }
}
