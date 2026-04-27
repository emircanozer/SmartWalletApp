import UIKit

final class ProfileContentView: UIView {
    let logoutButton = UIButton(type: .system)
    let darkModeButton = UIButton(type: .system)
    var onRowSelected: ((ProfileRowAction) -> Void)?
    var onEmailSelected: ((String) -> Void)?

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let headerContainerView = UIView()
    private let avatarRingView = UIView()
    private let avatarInnerView = UIView()
    private let avatarLabel = UILabel()
    private let statusDotView = UIView()
    private let nameLabel = UILabel()
    private let emailCardView = UIView()
    private let emailIconView = UIImageView()
    private let emailTitleLabel = UILabel()
    private let emailValueLabel = UILabel()
    private let emailEditIconView = UIImageView()
    private var currentEmailText = ""
    private let accountCardView = UIView()
    private let accountStackView = UIStackView()
    private let lastLoginCardView = UIView()
    private let lastLoginTitleLabel = UILabel()
    private let lastLoginValueLabel = UILabel()
    private let lastLoginAccentLabel = UILabel()
    private let historyCardView = UIView()
    private let historyStackView = UIStackView()
    private let supportCardView = UIView()
    private let supportStackView = UIStackView()

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
        [emailCardView, accountCardView, lastLoginCardView, historyCardView, supportCardView].forEach {
            $0.layer.cornerRadius = 22
        }
        headerContainerView.layer.cornerRadius = 24
        avatarRingView.layer.cornerRadius = 26
        avatarInnerView.layer.cornerRadius = 22
        statusDotView.layer.cornerRadius = 8
        darkModeButton.layer.cornerRadius = 16
        logoutButton.layer.cornerRadius = logoutButton.bounds.height / 2
    }
}

extension ProfileContentView {
    func setRefreshControl(_ refreshControl: UIRefreshControl) {
        scrollView.refreshControl = refreshControl
    }

    func apply(_ data: ProfileViewData) {
        titleLabel.text = data.titleText
        updateDarkModeButton(isEnabled: data.isDarkModeEnabled)
        avatarLabel.text = data.header.initialText
        nameLabel.text = data.header.nameText
        emailTitleLabel.text = data.email.titleText
        emailValueLabel.text = data.email.valueText
        currentEmailText = data.email.valueText

        lastLoginTitleLabel.text = data.lastFailedLoginCard.titleText
        lastLoginValueLabel.text = data.lastFailedLoginCard.valueText
        lastLoginAccentLabel.text = data.lastFailedLoginCard.accentText

        configureSection(accountStackView, items: data.accountSection.items)
        configureSection(historyStackView, items: data.historySection.items)
        configureSection(supportStackView, items: data.supportSection.items)

        logoutButton.setTitle(data.logoutTitleText, for: .normal)
    }

    func updateDarkModeButton(isEnabled: Bool) {
        let imageName = isEnabled ? "moon.fill" : "moon"
        darkModeButton.setImage(UIImage(systemName: imageName), for: .normal)
        darkModeButton.tintColor = isEnabled ? AppColor.primaryYellow : AppColor.navigationTint
        darkModeButton.backgroundColor = isEnabled ? AppColor.darkSurfaceAlt : AppColor.whitePrimary
        darkModeButton.layer.borderWidth = 1
        darkModeButton.layer.borderColor = (isEnabled ? AppColor.darkSurfaceAlt : AppColor.borderSoft).cgColor
    }
}

 extension ProfileContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        darkModeButton.contentMode = .scaleAspectFit

        headerContainerView.backgroundColor = AppColor.whitePrimary

        avatarRingView.backgroundColor = AppColor.primaryYellow
        avatarInnerView.backgroundColor = AppColor.whitePrimary

        avatarLabel.font = .systemFont(ofSize: 24, weight: .bold)
        avatarLabel.textColor = AppColor.secondaryText
        avatarLabel.textAlignment = .center

        statusDotView.backgroundColor = AppColor.primaryYellow
        statusDotView.layer.borderWidth = 2
        statusDotView.layer.borderColor = AppColor.whitePrimary.cgColor

        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textColor = AppColor.primaryText
        nameLabel.numberOfLines = 2

        [emailCardView, accountCardView, lastLoginCardView, historyCardView, supportCardView].forEach {
            $0.backgroundColor = AppColor.whitePrimary
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.04
            $0.layer.shadowRadius = 16
            $0.layer.shadowOffset = CGSize(width: 0, height: 8)
        }

        emailIconView.image = UIImage(systemName: "envelope")
        emailIconView.tintColor = AppColor.navigationTint
        emailIconView.contentMode = .scaleAspectFit

        emailTitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        emailTitleLabel.textColor = AppColor.primaryText

        emailValueLabel.font = .systemFont(ofSize: 13, weight: .medium)
        emailValueLabel.textColor = AppColor.secondaryText
        emailValueLabel.adjustsFontSizeToFitWidth = true
        emailValueLabel.minimumScaleFactor = 0.75
        emailValueLabel.lineBreakMode = .byClipping

        emailEditIconView.image = UIImage(systemName: "pencil")
        emailEditIconView.tintColor = AppColor.accentOlive
        emailEditIconView.contentMode = .scaleAspectFit

        emailCardView.isUserInteractionEnabled = true
        let emailTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEmailCardTap))
        emailCardView.addGestureRecognizer(emailTapGesture)

        [accountStackView, historyStackView, supportStackView].forEach {
            $0.axis = .vertical
            $0.spacing = 0
        }

        lastLoginTitleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        lastLoginTitleLabel.textColor = AppColor.primaryText

        lastLoginValueLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        lastLoginValueLabel.textColor = AppColor.secondaryText

        lastLoginAccentLabel.font = .systemFont(ofSize: 13, weight: .bold)
        lastLoginAccentLabel.textColor = AppColor.dangerStrong

        logoutButton.setTitleColor(AppColor.dangerStrong, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        logoutButton.backgroundColor = AppColor.whitePrimary
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor(red: 0.99, green: 0.86, blue: 0.86, alpha: 1.0).cgColor
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            titleLabel,
            darkModeButton,
            headerContainerView,
            emailCardView,
            accountCardView,
            lastLoginCardView,
            historyCardView,
            supportCardView,
            logoutButton
        ].forEach(contentContainer.addSubview)

        [avatarRingView, nameLabel].forEach(headerContainerView.addSubview)
        [avatarInnerView, statusDotView].forEach(avatarRingView.addSubview)
        avatarInnerView.addSubview(avatarLabel)

        [emailIconView, emailTitleLabel, emailValueLabel, emailEditIconView].forEach(emailCardView.addSubview)
        accountCardView.addSubview(accountStackView)
        historyCardView.addSubview(historyStackView)
        supportCardView.addSubview(supportStackView)
        [lastLoginTitleLabel, lastLoginValueLabel, lastLoginAccentLabel].forEach(lastLoginCardView.addSubview)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            titleLabel,
            darkModeButton,
            headerContainerView,
            avatarRingView,
            avatarInnerView,
            avatarLabel,
            statusDotView,
            nameLabel,
            emailCardView,
            emailIconView,
            emailTitleLabel,
            emailValueLabel,
            emailEditIconView,
            accountCardView,
            accountStackView,
            lastLoginCardView,
            lastLoginTitleLabel,
            lastLoginValueLabel,
            lastLoginAccentLabel,
            historyCardView,
            historyStackView,
            supportCardView,
            supportStackView,
            logoutButton
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

            titleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),

            darkModeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            darkModeButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            darkModeButton.widthAnchor.constraint(equalToConstant: 32),
            darkModeButton.heightAnchor.constraint(equalToConstant: 32),

            headerContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            headerContainerView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            headerContainerView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),

            avatarRingView.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 18),
            avatarRingView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 18),
            avatarRingView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -18),
            avatarRingView.widthAnchor.constraint(equalToConstant: 52),
            avatarRingView.heightAnchor.constraint(equalToConstant: 52),

            avatarInnerView.centerXAnchor.constraint(equalTo: avatarRingView.centerXAnchor),
            avatarInnerView.centerYAnchor.constraint(equalTo: avatarRingView.centerYAnchor),
            avatarInnerView.widthAnchor.constraint(equalToConstant: 44),
            avatarInnerView.heightAnchor.constraint(equalToConstant: 44),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarInnerView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarInnerView.centerYAnchor),

            statusDotView.trailingAnchor.constraint(equalTo: avatarRingView.trailingAnchor, constant: 2),
            statusDotView.bottomAnchor.constraint(equalTo: avatarRingView.bottomAnchor, constant: 2),
            statusDotView.widthAnchor.constraint(equalToConstant: 16),
            statusDotView.heightAnchor.constraint(equalToConstant: 16),

            nameLabel.leadingAnchor.constraint(equalTo: avatarRingView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarRingView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -18),

            emailCardView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 14),
            emailCardView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            emailCardView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),

            emailIconView.leadingAnchor.constraint(equalTo: emailCardView.leadingAnchor, constant: 18),
            emailIconView.centerYAnchor.constraint(equalTo: emailCardView.centerYAnchor),
            emailIconView.widthAnchor.constraint(equalToConstant: 18),
            emailIconView.heightAnchor.constraint(equalToConstant: 18),

            emailTitleLabel.topAnchor.constraint(equalTo: emailCardView.topAnchor, constant: 16),
            emailTitleLabel.leadingAnchor.constraint(equalTo: emailIconView.trailingAnchor, constant: 14),
            emailTitleLabel.trailingAnchor.constraint(equalTo: emailEditIconView.leadingAnchor, constant: -12),

            emailValueLabel.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 4),
            emailValueLabel.leadingAnchor.constraint(equalTo: emailTitleLabel.leadingAnchor),
            emailValueLabel.trailingAnchor.constraint(equalTo: emailTitleLabel.trailingAnchor),
            emailValueLabel.bottomAnchor.constraint(equalTo: emailCardView.bottomAnchor, constant: -16),

            emailEditIconView.centerYAnchor.constraint(equalTo: emailCardView.centerYAnchor),
            emailEditIconView.trailingAnchor.constraint(equalTo: emailCardView.trailingAnchor, constant: -18),
            emailEditIconView.widthAnchor.constraint(equalToConstant: 14),
            emailEditIconView.heightAnchor.constraint(equalToConstant: 14),

            accountCardView.topAnchor.constraint(equalTo: emailCardView.bottomAnchor, constant: 18),
            accountCardView.leadingAnchor.constraint(equalTo: emailCardView.leadingAnchor),
            accountCardView.trailingAnchor.constraint(equalTo: emailCardView.trailingAnchor),

            accountStackView.topAnchor.constraint(equalTo: accountCardView.topAnchor, constant: 8),
            accountStackView.leadingAnchor.constraint(equalTo: accountCardView.leadingAnchor),
            accountStackView.trailingAnchor.constraint(equalTo: accountCardView.trailingAnchor),
            accountStackView.bottomAnchor.constraint(equalTo: accountCardView.bottomAnchor, constant: -8),

            lastLoginCardView.topAnchor.constraint(equalTo: accountCardView.bottomAnchor, constant: 16),
            lastLoginCardView.leadingAnchor.constraint(equalTo: accountCardView.leadingAnchor),
            lastLoginCardView.trailingAnchor.constraint(equalTo: accountCardView.trailingAnchor),

            lastLoginTitleLabel.topAnchor.constraint(equalTo: lastLoginCardView.topAnchor, constant: 16),
            lastLoginTitleLabel.leadingAnchor.constraint(equalTo: lastLoginCardView.leadingAnchor, constant: 18),
            lastLoginTitleLabel.trailingAnchor.constraint(equalTo: lastLoginCardView.trailingAnchor, constant: -18),

            lastLoginValueLabel.topAnchor.constraint(equalTo: lastLoginTitleLabel.bottomAnchor, constant: 6),
            lastLoginValueLabel.leadingAnchor.constraint(equalTo: lastLoginTitleLabel.leadingAnchor),

            lastLoginAccentLabel.centerYAnchor.constraint(equalTo: lastLoginValueLabel.centerYAnchor),
            lastLoginAccentLabel.leadingAnchor.constraint(equalTo: lastLoginValueLabel.trailingAnchor, constant: 8),
            lastLoginAccentLabel.trailingAnchor.constraint(lessThanOrEqualTo: lastLoginCardView.trailingAnchor, constant: -18),
            lastLoginAccentLabel.bottomAnchor.constraint(equalTo: lastLoginCardView.bottomAnchor, constant: -16),

            historyCardView.topAnchor.constraint(equalTo: lastLoginCardView.bottomAnchor, constant: 16),
            historyCardView.leadingAnchor.constraint(equalTo: accountCardView.leadingAnchor),
            historyCardView.trailingAnchor.constraint(equalTo: accountCardView.trailingAnchor),

            historyStackView.topAnchor.constraint(equalTo: historyCardView.topAnchor, constant: 8),
            historyStackView.leadingAnchor.constraint(equalTo: historyCardView.leadingAnchor),
            historyStackView.trailingAnchor.constraint(equalTo: historyCardView.trailingAnchor),
            historyStackView.bottomAnchor.constraint(equalTo: historyCardView.bottomAnchor, constant: -8),

            supportCardView.topAnchor.constraint(equalTo: historyCardView.bottomAnchor, constant: 16),
            supportCardView.leadingAnchor.constraint(equalTo: accountCardView.leadingAnchor),
            supportCardView.trailingAnchor.constraint(equalTo: accountCardView.trailingAnchor),

            supportStackView.topAnchor.constraint(equalTo: supportCardView.topAnchor, constant: 8),
            supportStackView.leadingAnchor.constraint(equalTo: supportCardView.leadingAnchor),
            supportStackView.trailingAnchor.constraint(equalTo: supportCardView.trailingAnchor),
            supportStackView.bottomAnchor.constraint(equalTo: supportCardView.bottomAnchor, constant: -8),

            logoutButton.topAnchor.constraint(equalTo: supportCardView.bottomAnchor, constant: 24),
            logoutButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            logoutButton.heightAnchor.constraint(equalToConstant: 54),
            logoutButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -28)
        ])
    }

    func configureSection(_ stackView: UIStackView, items: [ProfileRowItem]) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for (index, item) in items.enumerated() {
            let row = ProfileMenuRowView()
            row.configure(with: item, showsSeparator: index < items.count - 1)
            if let action = item.action {
                row.addAction(UIAction { [weak self] _ in
                    self?.onRowSelected?(action)
                }, for: .touchUpInside)
            }
            stackView.addArrangedSubview(row)
        }
    }

    @objc func handleEmailCardTap() {
        onEmailSelected?(currentEmailText)
    }
}
