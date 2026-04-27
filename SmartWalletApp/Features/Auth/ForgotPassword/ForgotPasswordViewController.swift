import UIKit

class ForgotPasswordViewController: UIViewController {
    var onBack: (() -> Void)?
    var onCodeVerificationRequired: ((String) -> Void)?

    private let viewModel: ForgotPasswordViewModel
    private let contentView = UIView()
    private let headerStack = UIStackView()
    private let backButton = UIButton(type: .system)
    private let brandStack = UIStackView()
    private let brandLabel = UILabel()
    private let heroCard = UIView()
    private let heroIconView = UIImageView()
    private let titleLabel = UILabel()
    private let emailField: AuthInputFieldView
    private let sendButton = UIButton(type: .system)
    private let backgroundTapGesture = UITapGestureRecognizer()
    private let titleText = "Şifreni Unuttun"
    private let emailTitleText = "E-posta"
    private let emailPlaceholderText = "e-posta@adresiniz.com"
    private let buttonTitleText = "Sıfırlama Linki Gönder  >"

    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
        self.emailField = AuthInputFieldView(
            title: emailTitleText,
            placeholder: emailPlaceholderText,
            iconName: "envelope"
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        enableInteractivePopGesture()
        configureView()
        buildHierarchy()
        setupLayout()
        applyContent()
        bindActions()
        bindViewModel()
        observeKeyboard()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        heroCard.layer.cornerRadius = 18
        sendButton.layer.cornerRadius = 12
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ForgotPasswordViewController {
    func configureView() {
        view.backgroundColor = AppColor.appBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        contentView.backgroundColor = AppColor.appBackground

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

        heroCard.backgroundColor = AppColor.surfaceWarmMuted

        heroIconView.image = UIImage(systemName: "arrow.counterclockwise.circle.fill")
        heroIconView.tintColor = AppColor.heroOrange
        heroIconView.contentMode = .scaleAspectFit

        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.authHeadingText

        sendButton.backgroundColor = AppColor.primaryYellow
        sendButton.setTitleColor(AppColor.authHeadingText, for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)

        backgroundTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        backgroundTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(backgroundTapGesture)

        emailField.setKeyboardType(.emailAddress)
        emailField.setTextContentType(.emailAddress)
        emailField.setAutocapitalizationType(.none)
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

    
        brandStack.addArrangedSubview(brandLabel)

     
        heroCard.addSubview(heroIconView)
    }
}

extension ForgotPasswordViewController {
    func setupLayout() {
        [
            contentView,
            headerStack,
            backButton,
            brandStack,
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

extension ForgotPasswordViewController {
    func applyContent() {
        brandLabel.text = "SmartWallet AI"
        titleLabel.text = titleText
        sendButton.setTitle(buttonTitleText, for: .normal)
    }

    func bindActions() {
        backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(handleSendTap), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            switch state {
            case .idle:
                self.setLoading(false)
            case .loading:
                self.setLoading(true)
            case .success(let email, let response):
                self.setLoading(false)
                if response.success {
                    self.onCodeVerificationRequired?(email)
                } else {
                    self.showAlert(message: response.message)
                }
            case .failure(let message):
                self.setLoading(false)
                self.showAlert(message: message)
            }
        }
    }

    func setLoading(_ isLoading: Bool) {
        sendButton.alpha = isLoading ? 0.85 : 1
        sendButton.isEnabled = !isLoading
        setCenteredLoading(isLoading)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleBackgroundTap() {
        view.endEditing(true)
    }

    @objc func handleBackTap() {
        onBack?()
    }

    @objc func handleSendTap() {
        Task {
            await viewModel.sendResetLink(email: emailField.trimmedText)
        }
    }

    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let translation = min(max(0, keyboardFrame.height - view.safeAreaInsets.bottom) * 0.32, 110)
        UIView.animate(withDuration: duration) {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -translation)
        }
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        UIView.animate(withDuration: duration) {
            self.contentView.transform = .identity
        }
    }
}
