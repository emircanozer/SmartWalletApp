import UIKit

class RegisterContentView: UIView {
    let fullNameField: AuthInputFieldView
    let emailField: AuthInputFieldView
    let passwordField: AuthInputFieldView
    let confirmPasswordField: AuthInputFieldView
    let checkboxButton = UIButton(type: .system)
    let registerButton = UIButton(type: .system)
    let loginButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let iconWrapper = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let termsRow = UIStackView()
    private let termsLabel = UILabel()
    private let footerStack = UIStackView()
    private let footerLabel = UILabel()
    private let backgroundTapGesture = UITapGestureRecognizer()

    private let titleText = "Hesap Oluştur"
    private let subtitleText = "SmartWallet AI"
    private let fullNameTitleText = "Ad Soyad"
    private let fullNamePlaceholderText = "Adınız Soyadınız"
    private let emailTitleText = "E-posta"
    private let emailPlaceholderText = "ornek@mail.com"
    private let passwordTitleText = "Şifre"
    private let passwordPlaceholderText = "........"
    private let passwordHelperText = "Şifreniz en az 8 karakter olmalıdır."
    private let confirmPasswordTitleText = "Şifre Tekrar"
    private let confirmPasswordPlaceholderText = "........"
    private let termsTitleText = "Kullanım şartlarını kabul ediyorum ve Gizlilik Politikası'nı okudum."
    private let buttonTitleText = "Kayıt Ol"
    private let loginPromptText = "Zaten hesabın var mı?"
    private let loginActionTitleText = "Giriş Yap"

    override init(frame: CGRect) {
        self.fullNameField = AuthInputFieldView(
            title: fullNameTitleText,
            placeholder: fullNamePlaceholderText,
            iconName: "person"
        )
        self.emailField = AuthInputFieldView(
            title: emailTitleText,
            placeholder: emailPlaceholderText,
            iconName: "envelope"
        )
        self.passwordField = AuthInputFieldView(
            title: passwordTitleText,
            placeholder: passwordPlaceholderText,
            iconName: "lock",
            trailingIconName: "eye",
            helperText: passwordHelperText,
            isSecure: true
        )
        self.confirmPasswordField = AuthInputFieldView(
            title: confirmPasswordTitleText,
            placeholder: confirmPasswordPlaceholderText,
            iconName: "checkmark.shield",
            isSecure: true
        )
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
        applyContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RegisterContentView {
    func configureView() {
        backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        contentContainer.backgroundColor = .white

        iconWrapper.backgroundColor = AppColor.primaryYellow
        iconWrapper.layer.shadowColor = AppColor.primaryYellow.cgColor
        iconWrapper.layer.shadowOpacity = 0.18
        iconWrapper.layer.shadowRadius = 16
        iconWrapper.layer.shadowOffset = CGSize(width: 0, height: 10)

        iconView.image = UIImage(systemName: "globe")
        iconView.tintColor = AppColor.authHeadingText
        iconView.contentMode = .scaleAspectFit

        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = AppColor.authHeadingText

        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText

        termsRow.axis = .horizontal
        termsRow.alignment = .top
        termsRow.spacing = 10

        checkboxButton.layer.cornerRadius = 6
        checkboxButton.layer.borderWidth = 1
        checkboxButton.layer.borderColor = AppColor.filledBorder.cgColor
        checkboxButton.tintColor = AppColor.accentYellow

        termsLabel.numberOfLines = 0
        termsLabel.font = .systemFont(ofSize: 14, weight: .medium)
        termsLabel.textColor = AppColor.mutedText

        registerButton.backgroundColor = AppColor.primaryYellow
        registerButton.setTitleColor(AppColor.authHeadingText, for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.spacing = 6
        footerStack.distribution = .equalCentering

        footerLabel.font = .systemFont(ofSize: 15, weight: .medium)
        footerLabel.textColor = AppColor.secondaryText

        loginButton.setTitleColor(AppColor.authHeadingText, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)

        backgroundTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        backgroundTapGesture.cancelsTouchesInView = false
        addGestureRecognizer(backgroundTapGesture)

        fullNameField.setTextContentType(.name)
        fullNameField.setAutocapitalizationType(.words)
        emailField.setKeyboardType(.emailAddress)
        emailField.setTextContentType(.emailAddress)
        emailField.setAutocapitalizationType(.none)
        passwordField.setTextContentType(.newPassword)
        confirmPasswordField.setTextContentType(.newPassword)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        contentContainer.addSubview(iconWrapper)
        iconWrapper.addSubview(iconView)
        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(subtitleLabel)
        contentContainer.addSubview(fullNameField)
        contentContainer.addSubview(emailField)
        contentContainer.addSubview(passwordField)
        contentContainer.addSubview(confirmPasswordField)
        contentContainer.addSubview(termsRow)
        contentContainer.addSubview(registerButton)
        contentContainer.addSubview(footerStack)

        termsRow.addArrangedSubview(checkboxButton)
        termsRow.addArrangedSubview(termsLabel)

        footerStack.addArrangedSubview(footerLabel)
        footerStack.addArrangedSubview(loginButton)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            iconWrapper,
            iconView,
            titleLabel,
            subtitleLabel,
            fullNameField,
            emailField,
            passwordField,
            confirmPasswordField,
            termsRow,
            checkboxButton,
            termsLabel,
            registerButton,
            footerStack
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentContainer.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            iconWrapper.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 34),
            iconWrapper.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            iconWrapper.widthAnchor.constraint(equalToConstant: 54),
            iconWrapper.heightAnchor.constraint(equalToConstant: 54),

            iconView.centerXAnchor.constraint(equalTo: iconWrapper.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconWrapper.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),

            titleLabel.topAnchor.constraint(equalTo: iconWrapper.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            fullNameField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 34),
            fullNameField.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 22),
            fullNameField.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -22),

            emailField.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 22),
            emailField.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -22),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 22),
            passwordField.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -22),

            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            confirmPasswordField.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 22),
            confirmPasswordField.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -22),

            termsRow.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 20),
            termsRow.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 22),
            termsRow.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -22),

            checkboxButton.widthAnchor.constraint(equalToConstant: 18),
            checkboxButton.heightAnchor.constraint(equalToConstant: 18),

            registerButton.topAnchor.constraint(equalTo: termsRow.bottomAnchor, constant: 28),
            registerButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 22),
            registerButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -22),
            registerButton.heightAnchor.constraint(equalToConstant: 52),

            footerStack.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 28),
            footerStack.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            footerStack.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -26)
        ])
    }

    func applyContent() {
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        registerButton.setTitle(buttonTitleText, for: .normal)
        footerLabel.text = loginPromptText
        loginButton.setTitle(loginActionTitleText, for: .normal)

        let attributedText = NSMutableAttributedString(
            string: termsTitleText,
            attributes: [
                .foregroundColor: AppColor.mutedText,
                .font: UIFont.systemFont(ofSize: 14, weight: .medium)
            ]
        )

        if let range = termsTitleText.range(of: "Gizlilik Politikası") {
            let nsRange = NSRange(range, in: termsTitleText)
            attributedText.addAttributes([
                .foregroundColor: AppColor.accentYellow,
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ], range: nsRange)
        }

        termsLabel.attributedText = attributedText
    }

    func applyCornerRadius() {
        iconWrapper.layer.cornerRadius = 15
        registerButton.layer.cornerRadius = 12
    }

    @objc func handleBackgroundTap() {
        endEditing(true)
    }
}
