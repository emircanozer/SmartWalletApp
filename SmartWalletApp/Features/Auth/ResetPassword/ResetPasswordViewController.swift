import UIKit

class ResetPasswordViewController: UIViewController {
    var onBack: (() -> Void)?

    private let viewModel: ResetPasswordViewModel

    private let contentView = UIView()
    private let headerStack = UIStackView()
    private let backButton = UIButton(type: .system)
    private let brandStack = UIStackView()
    private let logoWrapper = UIView()
    private let logoImageView = UIImageView()
    private let brandLabel = UILabel()
    private let heroCard = UIView()
    private let heroIconView = UIImageView()
    private let titleLabel = UILabel()
    private let emailField: AuthInputFieldView
    private let sendButton = UIButton(type: .system)
    private let backgroundTapGesture = UITapGestureRecognizer()

    init(viewModel: ResetPasswordViewModel) {
        self.viewModel = viewModel
        self.emailField = AuthInputFieldView(
            title: viewModel.emailTitle,
            placeholder: viewModel.emailPlaceholder,
            iconName: "envelope"
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
        logoWrapper.layer.cornerRadius = 9
        heroCard.layer.cornerRadius = 18
        sendButton.layer.cornerRadius = 12
    }
}

private extension ResetPasswordViewController {
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
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit

        brandLabel.font = .systemFont(ofSize: 20, weight: .bold)
        brandLabel.textColor = UIColor(red: 0.23, green: 0.25, blue: 0.32, alpha: 1.0)

        heroCard.backgroundColor = UIColor(red: 0.99, green: 0.96, blue: 0.92, alpha: 1.0)

        heroIconView.image = UIImage(systemName: "arrow.counterclockwise.circle.fill")
        heroIconView.tintColor = UIColor(red: 0.9, green: 0.49, blue: 0.24, alpha: 1.0)
        heroIconView.contentMode = .scaleAspectFit

        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0)

        sendButton.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        sendButton.setTitleColor(UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0), for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)

        backgroundTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        backgroundTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(backgroundTapGesture)
    }

    func buildHierarchy() {
        view.addSubview(contentView)

        contentView.addSubview(headerStack)
        contentView.addSubview(heroCard)
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailField)
        contentView.addSubview(sendButton)

        headerStack.addArrangedSubview(backButton)
        headerStack.addArrangedSubview(brandStack)

        brandStack.addArrangedSubview(logoWrapper)
        brandStack.addArrangedSubview(brandLabel)

        logoWrapper.addSubview(logoImageView)
        heroCard.addSubview(heroIconView)
    }
}

private extension ResetPasswordViewController {
    func setupLayout() {
        [
            contentView,
            headerStack,
            backButton,
            brandStack,
            logoWrapper,
            logoImageView,
            heroCard,
            heroIconView,
            titleLabel,
            emailField,
            sendButton
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
            logoImageView.widthAnchor.constraint(equalToConstant: 14),
            logoImageView.heightAnchor.constraint(equalToConstant: 14),

            heroCard.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 112),
            heroCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            heroCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            heroCard.heightAnchor.constraint(equalToConstant: 164),

            heroIconView.centerXAnchor.constraint(equalTo: heroCard.centerXAnchor),
            heroIconView.centerYAnchor.constraint(equalTo: heroCard.centerYAnchor),
            heroIconView.widthAnchor.constraint(equalToConstant: 58),
            heroIconView.heightAnchor.constraint(equalToConstant: 58),

            titleLabel.topAnchor.constraint(equalTo: heroCard.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            sendButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            sendButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            sendButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}

private extension ResetPasswordViewController {
    func applyContent() {
        brandLabel.text = "SmartWallet AI"
        titleLabel.text = viewModel.title
        sendButton.setTitle(viewModel.buttonTitle, for: .normal)
    }

    func bindActions() {
        backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
    }

    @objc func handleBackgroundTap() {
        view.endEditing(true)
    }

    @objc func handleBackTap() {
        onBack?()
    }
}
