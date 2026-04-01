import UIKit

class LoginContentView: UIView {
    let backButton = UIButton(type: .system)
    let emailField: AuthInputFieldView
    let passwordField: AuthInputFieldView
    let loginButton = UIButton(type: .system)
    let registerButton = UIButton(type: .system)

    private let contentContainer = UIView()
    private let headerStack = UIStackView()
    private let brandStack = UIStackView()
    private let logoWrapper = UIView()
    private let logoImageView = UIImageView()
    private let brandLabel = UILabel()
    private let heroWrapper = UIView()
    private let heroIconWrapper = UIView()
    private let heroIconView = UIImageView()
    private let subtitleLabel = UILabel()
    private let cardView = UIView()
    private let footerStack = UIStackView()
    private let footerLabel = UILabel()
    private let backgroundTapGesture = UITapGestureRecognizer()

    private let subtitleText = "Finansal geleceğinizi AI ile yönetin"
    private let emailTitleText = "E-POSTA"
    private let emailPlaceholderText = "e-posta@adresiniz.com"
    private let passwordTitleText = "ŞİFRE"
    private let passwordPlaceholderText = "........"
    private let forgotPasswordTitleText = "Şifremi Unuttum"
    private let buttonTitleText = "Giriş Yap  →"
    private let registerPromptText = "Hesabınız yok mu?"
    private let registerActionTitleText = "Hemen Kayıt Ol"

    override init(frame: CGRect) {
        self.emailField = AuthInputFieldView(
            title: emailTitleText,
            placeholder: emailPlaceholderText,
            iconName: "envelope"
        )
        self.passwordField = AuthInputFieldView(
            title: passwordTitleText,
            placeholder: passwordPlaceholderText,
            iconName: "lock",
            topActionTitle: forgotPasswordTitleText,
            trailingIconName: "eye",
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

extension LoginContentView {
    func configureView() {
        backgroundColor = .white
        contentContainer.backgroundColor = .white

        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 14

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor(red: 0.35, green: 0.38, blue: 0.46, alpha: 1.0)

        brandStack.axis = .horizontal
        brandStack.alignment = .center
        brandStack.spacing = 10

        logoWrapper.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        logoImageView.image = UIImage(systemName: "wallet.pass.fill")
        logoImageView.tintColor = .black
        logoImageView.contentMode = .scaleAspectFit

        brandLabel.font = .systemFont(ofSize: 20, weight: .bold)
        brandLabel.textColor = UIColor(red: 0.23, green: 0.25, blue: 0.32, alpha: 1.0)

        heroWrapper.backgroundColor = UIColor(red: 1.0, green: 0.99, blue: 0.96, alpha: 1.0)
        heroWrapper.layer.cornerRadius = 34

        heroIconWrapper.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.93, alpha: 1.0)
        heroIconWrapper.layer.borderWidth = 1
        heroIconWrapper.layer.borderColor = UIColor(red: 0.98, green: 0.92, blue: 0.76, alpha: 1.0).cgColor

        heroIconView.image = UIImage(systemName: "creditcard.fill")
        heroIconView.tintColor = UIColor(red: 0.98, green: 0.78, blue: 0.0, alpha: 1.0)
        heroIconView.contentMode = .scaleAspectFit

        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor(red: 0.55, green: 0.58, blue: 0.64, alpha: 1.0)
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.numberOfLines = 0

        cardView.backgroundColor = .white
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(red: 0.98, green: 0.92, blue: 0.76, alpha: 1.0).cgColor
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowRadius = 20
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)

        loginButton.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        loginButton.setTitleColor(UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0), for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.distribution = .equalCentering

        footerLabel.font = .systemFont(ofSize: 15, weight: .medium)
        footerLabel.textColor = UIColor(red: 0.55, green: 0.58, blue: 0.64, alpha: 1.0)

        registerButton.setTitleColor(UIColor(red: 0.98, green: 0.78, blue: 0.0, alpha: 1.0), for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)

        backgroundTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        backgroundTapGesture.cancelsTouchesInView = false
        addGestureRecognizer(backgroundTapGesture)

        emailField.setKeyboardType(.emailAddress)
        emailField.setTextContentType(.emailAddress)
        emailField.setAutocapitalizationType(.none)
        passwordField.setTextContentType(.password)
    }

    func buildHierarchy() {
        addSubview(contentContainer)

        contentContainer.addSubview(headerStack)
        contentContainer.addSubview(heroWrapper)
        contentContainer.addSubview(subtitleLabel)
        contentContainer.addSubview(cardView)

        headerStack.addArrangedSubview(backButton)
        headerStack.addArrangedSubview(brandStack)

        brandStack.addArrangedSubview(logoWrapper)
        brandStack.addArrangedSubview(brandLabel)

        logoWrapper.addSubview(logoImageView)

        heroWrapper.addSubview(heroIconWrapper)
        heroIconWrapper.addSubview(heroIconView)

        cardView.addSubview(emailField)
        cardView.addSubview(passwordField)
        cardView.addSubview(loginButton)
        cardView.addSubview(footerStack)

        footerStack.addArrangedSubview(footerLabel)
        footerStack.addArrangedSubview(registerButton)
    }

    func setupLayout() {
        [
            contentContainer,
            headerStack,
            backButton,
            brandStack,
            logoWrapper,
            logoImageView,
            brandLabel,
            heroWrapper,
            heroIconWrapper,
            heroIconView,
            subtitleLabel,
            cardView,
            emailField,
            passwordField,
            loginButton,
            footerStack
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            headerStack.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 12),
            headerStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(lessThanOrEqualTo: contentContainer.trailingAnchor, constant: -20),

            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            logoWrapper.widthAnchor.constraint(equalToConstant: 28),
            logoWrapper.heightAnchor.constraint(equalToConstant: 28),

            logoImageView.centerXAnchor.constraint(equalTo: logoWrapper.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoWrapper.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 16),
            logoImageView.heightAnchor.constraint(equalToConstant: 16),

            heroWrapper.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 40),
            heroWrapper.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            heroWrapper.widthAnchor.constraint(equalToConstant: 180),
            heroWrapper.heightAnchor.constraint(equalToConstant: 132),

            heroIconWrapper.centerXAnchor.constraint(equalTo: heroWrapper.centerXAnchor),
            heroIconWrapper.centerYAnchor.constraint(equalTo: heroWrapper.centerYAnchor),
            heroIconWrapper.widthAnchor.constraint(equalToConstant: 50),
            heroIconWrapper.heightAnchor.constraint(equalToConstant: 50),

            heroIconView.centerXAnchor.constraint(equalTo: heroIconWrapper.centerXAnchor),
            heroIconView.centerYAnchor.constraint(equalTo: heroIconWrapper.centerYAnchor),
            heroIconView.widthAnchor.constraint(equalToConstant: 22),
            heroIconView.heightAnchor.constraint(equalToConstant: 22),

            subtitleLabel.topAnchor.constraint(equalTo: heroWrapper.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 44),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -44),

            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 34),
            cardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            emailField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            emailField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 22),
            emailField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            passwordField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 22),
            passwordField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),

            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 22),
            loginButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),
            loginButton.heightAnchor.constraint(equalToConstant: 52),

            footerStack.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 24),
            footerStack.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            footerStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),

            cardView.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -24)
        ])
    }

    func applyContent() {
        brandLabel.text = "SmartWallet AI"
        subtitleLabel.text = subtitleText
        loginButton.setTitle(buttonTitleText, for: .normal)
        footerLabel.text = registerPromptText
        registerButton.setTitle(registerActionTitleText, for: .normal)
    }

    func applyCornerRadius() {
        logoWrapper.layer.cornerRadius = 9
        heroIconWrapper.layer.cornerRadius = 16
        cardView.layer.cornerRadius = 18
        loginButton.layer.cornerRadius = 12
    }

    @objc func handleBackgroundTap() {
        endEditing(true)
    }
}
