import UIKit

class RegisterViewController: UIViewController {
    var onLogin: (() -> Void)?

    private let viewModel: RegisterViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let iconWrapper = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let fullNameField: AuthInputFieldView
    private let emailField: AuthInputFieldView
    private let passwordField: AuthInputFieldView
    private let confirmPasswordField: AuthInputFieldView
    private let termsRow = UIStackView()
    private let checkboxButton = UIButton(type: .system)
    private let termsLabel = UILabel()
    private let registerButton = UIButton(type: .system)
    private let footerStack = UIStackView()
    private let footerLabel = UILabel()
    private let loginButton = UIButton(type: .system)

    private var isTermsAccepted = false

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        self.fullNameField = AuthInputFieldView(
            title: viewModel.fullNameTitle,
            placeholder: viewModel.fullNamePlaceholder,
            iconName: "person"
        )
        self.emailField = AuthInputFieldView(
            title: viewModel.emailTitle,
            placeholder: viewModel.emailPlaceholder,
            iconName: "envelope"
        )
        self.passwordField = AuthInputFieldView(
            title: viewModel.passwordTitle,
            placeholder: viewModel.passwordPlaceholder,
            iconName: "lock",
            trailingIconName: "eye",
            helperText: viewModel.passwordHelper,
            isSecure: true
        )
        self.confirmPasswordField = AuthInputFieldView(
            title: viewModel.confirmPasswordTitle,
            placeholder: viewModel.confirmPasswordPlaceholder,
            iconName: "checkmark.shield",
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        iconWrapper.layer.cornerRadius = 15
        registerButton.layer.cornerRadius = 12
    }
}

private extension RegisterViewController {
    func configureView() {
        view.backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        contentView.backgroundColor = .white

        iconWrapper.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        iconWrapper.layer.shadowColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0).cgColor
        iconWrapper.layer.shadowOpacity = 0.18
        iconWrapper.layer.shadowRadius = 16
        iconWrapper.layer.shadowOffset = CGSize(width: 0, height: 10)

        iconView.image = UIImage(systemName: "globe")
        iconView.tintColor = UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit

        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0)

        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.55, green: 0.58, blue: 0.64, alpha: 1.0)

        termsRow.axis = .horizontal
        termsRow.alignment = .top
        termsRow.spacing = 10

        checkboxButton.layer.cornerRadius = 6
        checkboxButton.layer.borderWidth = 1
        checkboxButton.layer.borderColor = UIColor(red: 0.87, green: 0.89, blue: 0.93, alpha: 1.0).cgColor
        checkboxButton.tintColor = UIColor(red: 1.0, green: 0.78, blue: 0.0, alpha: 1.0)

        termsLabel.numberOfLines = 0
        termsLabel.font = .systemFont(ofSize: 14, weight: .medium)
        termsLabel.textColor = UIColor(red: 0.34, green: 0.37, blue: 0.44, alpha: 1.0)

        registerButton.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        registerButton.setTitleColor(UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0), for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.spacing = 6
        footerStack.distribution = .equalCentering

        footerLabel.font = .systemFont(ofSize: 15, weight: .medium)
        footerLabel.textColor = UIColor(red: 0.55, green: 0.58, blue: 0.64, alpha: 1.0)

        loginButton.setTitleColor(UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0), for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    }

    func buildHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(iconWrapper)
        iconWrapper.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(fullNameField)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(confirmPasswordField)
        contentView.addSubview(termsRow)
        contentView.addSubview(registerButton)
        contentView.addSubview(footerStack)

        termsRow.addArrangedSubview(checkboxButton)
        termsRow.addArrangedSubview(termsLabel)

        footerStack.addArrangedSubview(footerLabel)
        footerStack.addArrangedSubview(loginButton)
    }
}

private extension RegisterViewController {
    func setupLayout() {
        [
            scrollView,
            contentView,
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
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            iconWrapper.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 34),
            iconWrapper.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconWrapper.widthAnchor.constraint(equalToConstant: 54),
            iconWrapper.heightAnchor.constraint(equalToConstant: 54),

            iconView.centerXAnchor.constraint(equalTo: iconWrapper.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconWrapper.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),

            titleLabel.topAnchor.constraint(equalTo: iconWrapper.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            fullNameField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 34),
            fullNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            fullNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),

            emailField.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),

            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            confirmPasswordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            confirmPasswordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),

            termsRow.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 20),
            termsRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            termsRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),

            checkboxButton.widthAnchor.constraint(equalToConstant: 18),
            checkboxButton.heightAnchor.constraint(equalToConstant: 18),

            registerButton.topAnchor.constraint(equalTo: termsRow.bottomAnchor, constant: 28),
            registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            registerButton.heightAnchor.constraint(equalToConstant: 52),

            footerStack.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 28),
            footerStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            footerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26)
        ])
    }
}

private extension RegisterViewController {
    func applyContent() {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        registerButton.setTitle(viewModel.buttonTitle, for: .normal)
        footerLabel.text = viewModel.loginPrompt
        loginButton.setTitle(viewModel.loginActionTitle, for: .normal)

        let baseText = viewModel.termsTitle
        let attributedText = NSMutableAttributedString(
            string: baseText,
            attributes: [
                .foregroundColor: UIColor(red: 0.34, green: 0.37, blue: 0.44, alpha: 1.0),
                .font: UIFont.systemFont(ofSize: 14, weight: .medium)
            ]
        )

        if let range = baseText.range(of: "Gizlilik Politikası") {
            let nsRange = NSRange(range, in: baseText)
            attributedText.addAttributes([
                .foregroundColor: UIColor(red: 1.0, green: 0.78, blue: 0.0, alpha: 1.0),
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ], range: nsRange)
        }

        termsLabel.attributedText = attributedText
        updateCheckboxAppearance()
    }

    func bindActions() {
        checkboxButton.addTarget(self, action: #selector(handleCheckboxTap), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(handleLoginTap), for: .touchUpInside)
        passwordField.setTrailingTarget(self, action: #selector(handlePasswordVisibilityTap))
    }

    func updateCheckboxAppearance() {
        let imageName = isTermsAccepted ? "checkmark" : nil
        checkboxButton.setImage(imageName == nil ? nil : UIImage(systemName: imageName!), for: .normal)
    }

    @objc func handleCheckboxTap() {
        isTermsAccepted.toggle()
        updateCheckboxAppearance()
    }

    @objc func handleLoginTap() {
        onLogin?()
    }

    @objc func handlePasswordVisibilityTap() {
        passwordField.toggleSecureEntry()
    }
}
