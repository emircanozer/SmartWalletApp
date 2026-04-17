import UIKit

class LoginContentView: UIView {
    let backButton = UIButton(type: .system)
    let emailField: AuthInputFieldView
    let passwordField: AuthInputFieldView
    let loginButton = UIButton(type: .system)
    let registerButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let headerStack = UIStackView()
    private let brandStack = UIStackView()
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
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        contentContainer.backgroundColor = .white

        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 14

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint

        brandStack.axis = .horizontal
        brandStack.alignment = .center
        brandStack.spacing = 10

        brandLabel.font = .systemFont(ofSize: 20, weight: .bold)
        brandLabel.textColor = AppColor.brandTextStrong

        heroWrapper.backgroundColor = AppColor.surfaceWarm
        heroWrapper.layer.cornerRadius = 34

        heroIconWrapper.backgroundColor = AppColor.surfaceWarmSoft
        heroIconWrapper.layer.borderWidth = 1
        heroIconWrapper.layer.borderColor = AppColor.borderWarm.cgColor

        heroIconView.image = UIImage(systemName: "creditcard.fill")
        heroIconView.tintColor = AppColor.primaryYellow
        heroIconView.contentMode = .scaleAspectFit

        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.numberOfLines = 0

        cardView.backgroundColor = .white
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = AppColor.borderWarm.cgColor
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowRadius = 20
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)

        loginButton.backgroundColor = AppColor.primaryYellow
        loginButton.setTitleColor(AppColor.authHeadingText, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.distribution = .equalCentering

        footerLabel.font = .systemFont(ofSize: 15, weight: .medium)
        footerLabel.textColor = AppColor.secondaryText

        registerButton.setTitleColor(AppColor.primaryYellow, for: .normal)
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
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        contentContainer.addSubview(headerStack)
        contentContainer.addSubview(heroWrapper)
        contentContainer.addSubview(subtitleLabel)
        contentContainer.addSubview(cardView)

        headerStack.addArrangedSubview(backButton)
        headerStack.addArrangedSubview(brandStack)
        brandStack.addArrangedSubview(brandLabel)

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
            scrollView,
            contentContainer,
            headerStack,
            backButton,
            brandStack,
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
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            contentContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentContainer.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            headerStack.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 12),
            headerStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(lessThanOrEqualTo: contentContainer.trailingAnchor, constant: -20),

            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
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

            cardView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -24)
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
        heroIconWrapper.layer.cornerRadius = 16
        cardView.layer.cornerRadius = 18
        loginButton.layer.cornerRadius = 12
    }

    @objc func handleBackgroundTap() {
        endEditing(true)
    }

    func setKeyboardBottomInset(_ inset: CGFloat) {
        scrollView.contentInset.bottom = inset
        scrollView.verticalScrollIndicatorInsets.bottom = inset
    }

    func scrollToVisible(_ view: UIView) {
        let rect = view.convert(view.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -24), animated: true)
    }
}
