import UIKit

final class ResetPasswordSuccessContentView: UIView {
    let loginButton = UIButton(type: .system)
    let homeButton = UIButton(type: .system)

    private let backButton = UIButton(type: .system)
    private let brandLabel = UILabel()
    private let iconWrapper = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let countdownLabel = UILabel()
    private let contentStack = UIStackView()

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
        loginButton.layer.cornerRadius = loginButton.bounds.height / 2
    }
}

extension ResetPasswordSuccessContentView {
    func apply(data: ResetPasswordSuccessViewData) {
        brandLabel.text = "SmartWallet AI"
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText
        loginButton.setTitle(data.loginButtonTitle, for: .normal)
        homeButton.setTitle(data.homeButtonTitle, for: .normal)
    }

    func updateCountdown(seconds: Int) {
        countdownLabel.text = "\(seconds) saniye içinde giriş ekranına yönlendirileceksiniz"
    }
}

 extension ResetPasswordSuccessContentView {
    func configureView() {
        backgroundColor = .white

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint
        backButton.isHidden = true

        brandLabel.font = .systemFont(ofSize: 20, weight: .bold)
        brandLabel.textColor = AppColor.brandTextSoft
        brandLabel.textAlignment = .center

        iconWrapper.backgroundColor = .clear
        iconWrapper.layer.shadowColor = UIColor.clear.cgColor
        iconWrapper.layer.shadowOpacity = 0
        iconWrapper.layer.shadowRadius = 0
        iconWrapper.layer.shadowOffset = .zero

        iconImageView.image = UIImage(named: "checkMarkicon")?.withRenderingMode(.alwaysOriginal)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center

        var loginConfiguration = UIButton.Configuration.filled()
        loginConfiguration.baseBackgroundColor = AppColor.primaryYellow
        loginConfiguration.baseForegroundColor = AppColor.authHeadingText
        loginConfiguration.image = UIImage(systemName: "arrow.right")
        loginConfiguration.imagePlacement = .trailing
        loginConfiguration.imagePadding = 18
        loginConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        loginButton.configuration = loginConfiguration
        loginButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)

        countdownLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        countdownLabel.textColor = AppColor.helperText
        countdownLabel.textAlignment = .center
        countdownLabel.numberOfLines = 0

        homeButton.setTitleColor(AppColor.mutedText, for: .normal)
        homeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)

        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.spacing = 24
    }

    func buildHierarchy() {
        [backButton, brandLabel, contentStack].forEach(addSubview)

        [iconWrapper, titleLabel, subtitleLabel, loginButton, countdownLabel, homeButton].forEach {
            contentStack.addArrangedSubview($0)
        }
        iconWrapper.addSubview(iconImageView)
    }

    func setupLayout() {
        [backButton, brandLabel, contentStack, iconWrapper, iconImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            brandLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            brandLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            contentStack.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 72),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            iconWrapper.widthAnchor.constraint(equalToConstant: 120),
            iconWrapper.heightAnchor.constraint(equalToConstant: 120),
            iconWrapper.centerXAnchor.constraint(equalTo: centerXAnchor),

            iconImageView.centerXAnchor.constraint(equalTo: iconWrapper.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconWrapper.centerYAnchor),
            // 120 ye 120
            iconImageView.widthAnchor.constraint(equalToConstant: 120),
            iconImageView.heightAnchor.constraint(equalToConstant: 120),

            loginButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
}
