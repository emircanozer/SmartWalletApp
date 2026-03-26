import UIKit

class LoginViewController: UIViewController {
    var onBack: (() -> Void)? // bu propun içi dışarıda doldurulur genelde kordinatör. welcome kordinatörün içinde kullanıdık yani içini orada doldurduk sonra bu sayfada handle tap ile kullandık
    var onRegister: (() -> Void)?
    var onForgotPassword: (() -> Void)?

    private let viewModel: LoginViewModel

    private let contentView = UIView()
    private let headerStack = UIStackView()
    private let backButton = UIButton(type: .system)
    private let brandStack = UIStackView()
    private let logoWrapper = UIView()
    private let logoImageView = UIImageView()
    private let brandLabel = UILabel()
    private let heroWrapper = UIView()
    private let heroIconWrapper = UIView()
    private let heroIconView = UIImageView()
    private let subtitleLabel = UILabel()
    private let cardView = UIView()
    private let emailField: AuthInputFieldView
    private let passwordField: AuthInputFieldView
    private let loginButton = UIButton(type: .system)
    private let footerStack = UIStackView()
    private let footerLabel = UILabel()
    private let registerButton = UIButton(type: .system)
    private let backgroundTapGesture = UITapGestureRecognizer()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        self.emailField = AuthInputFieldView(
            title: viewModel.emailTitle,
            placeholder: viewModel.emailPlaceholder,
            iconName: "envelope"
        )
        
        // customfieldviewimden passwordField oluşturdum özelliklerini viewmodelekinden aldım
        self.passwordField = AuthInputFieldView(
            title: viewModel.passwordTitle,
            placeholder: viewModel.passwordPlaceholder,
            iconName: "lock",
            topActionTitle: viewModel.forgotPasswordTitle,
            trailingIconName: "eye",
            isSecure: true
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        buildHierarchy()
        setupLayout()
        applyContent()
        bindActions()
    }

    // cornerradiıuslar burada 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton.layer.cornerRadius = 12
        cardView.layer.cornerRadius = 18
        logoWrapper.layer.cornerRadius = 9
        heroIconWrapper.layer.cornerRadius = 16
    }
}

private extension LoginViewController {
    func configureView() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        contentView.backgroundColor = .white

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
        view.addGestureRecognizer(backgroundTapGesture)

    }

    func buildHierarchy() {
        view.addSubview(contentView)

        contentView.addSubview(headerStack)
        contentView.addSubview(heroWrapper)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(cardView)

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
}

private extension LoginViewController {
    func setupLayout() {
        [
            contentView,
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
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),

            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            logoWrapper.widthAnchor.constraint(equalToConstant: 28),
            logoWrapper.heightAnchor.constraint(equalToConstant: 28),

            logoImageView.centerXAnchor.constraint(equalTo: logoWrapper.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoWrapper.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 16),
            logoImageView.heightAnchor.constraint(equalToConstant: 16),

            heroWrapper.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 40),
            heroWrapper.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
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
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44),

            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 34),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

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

            cardView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
    }
}

private extension LoginViewController {
    func applyContent() {
        brandLabel.text = "SmartWallet AI"
        subtitleLabel.text = viewModel.subtitle
        loginButton.setTitle(viewModel.buttonTitle, for: .normal)
        footerLabel.text = viewModel.registerPrompt
        registerButton.setTitle(viewModel.registerActionTitle, for: .normal)
    }

    func bindActions() {
        backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(handleRegisterTap), for: .touchUpInside)
        passwordField.setTrailingTarget(self, action: #selector(handlePasswordVisibilityTap))
        passwordField.setTopActionTarget(self, action: #selector(handleForgotPasswordTap))
    }

    @objc func handleBackgroundTap() {
        view.endEditing(true)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleRegisterTap() {
        onRegister?()
    }

    @objc func handlePasswordVisibilityTap() {
        passwordField.toggleSecureEntry()
    }

    @objc func handleForgotPasswordTap() {
        onForgotPassword?()
    }
}
