import UIKit

class VerificationCodeContentView: UIView {
    let codeInputView = VerificationCodeInputView()
    let verifyButton = UIButton(type: .system)
    let resendButton = UIButton(type: .system)
    let timerStack = UIStackView()
    let timerLabel = UILabel()
    let backToLoginButton = UIButton(type: .system)

    private let contentContainer = UIView()
    private let keyboardTapGesture = UITapGestureRecognizer()
    private let logoWrapper = UIView()
    private let logoImageView = UIImageView()
    private let brandLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let timerIconView = UIImageView()

    private let titleText = "Doğrulama Kodu"
    private let subtitleText = "E-postanıza gönderilen 6 haneli kodu girin"
    private let buttonTitleText = "Doğrula"
    private let resendTitleText = "Kodu tekrar gönder"
    private let backTitleText = "Giriş ekranına geri dön"

    override init(frame: CGRect) {
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

extension VerificationCodeContentView {
    func configureView() {
        backgroundColor = .white
        contentContainer.backgroundColor = .white

        logoWrapper.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        logoWrapper.layer.shadowColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0).cgColor
        logoWrapper.layer.shadowOpacity = 0.18
        logoWrapper.layer.shadowRadius = 18
        logoWrapper.layer.shadowOffset = CGSize(width: 0, height: 10)

        logoImageView.image = UIImage(systemName: "wallet.pass.fill")
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit

        brandLabel.textAlignment = .center
        brandLabel.font = .systemFont(ofSize: 18, weight: .bold)
        brandLabel.textColor = UIColor(red: 0.2, green: 0.22, blue: 0.28, alpha: 1.0)

        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0)

        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.55, green: 0.58, blue: 0.64, alpha: 1.0)
        subtitleLabel.numberOfLines = 0

        verifyButton.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        verifyButton.setTitleColor(UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0), for: .normal)
        verifyButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        verifyButton.layer.shadowColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0).cgColor
        verifyButton.layer.shadowOpacity = 0.18
        verifyButton.layer.shadowRadius = 18
        verifyButton.layer.shadowOffset = CGSize(width: 0, height: 10)

        resendButton.setTitleColor(UIColor(red: 0.47, green: 0.49, blue: 0.56, alpha: 1.0), for: .normal)
        resendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        resendButton.isHidden = true

        timerStack.axis = .horizontal
        timerStack.alignment = .center
        timerStack.spacing = 4

        timerIconView.image = UIImage(systemName: "clock")
        timerIconView.tintColor = UIColor(red: 0.63, green: 0.65, blue: 0.71, alpha: 1.0)
        timerIconView.contentMode = .scaleAspectFit

        timerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        timerLabel.textColor = UIColor(red: 0.63, green: 0.65, blue: 0.71, alpha: 1.0)

        backToLoginButton.setTitleColor(UIColor(red: 0.42, green: 0.44, blue: 0.5, alpha: 1.0), for: .normal)
        backToLoginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        keyboardTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        keyboardTapGesture.cancelsTouchesInView = false
        addGestureRecognizer(keyboardTapGesture)
    }

    func buildHierarchy() {
        addSubview(contentContainer)

        contentContainer.addSubview(logoWrapper)
        logoWrapper.addSubview(logoImageView)
        contentContainer.addSubview(brandLabel)
        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(subtitleLabel)
        contentContainer.addSubview(codeInputView)
        contentContainer.addSubview(verifyButton)
        contentContainer.addSubview(resendButton)
        contentContainer.addSubview(timerStack)
        contentContainer.addSubview(backToLoginButton)

        timerStack.addArrangedSubview(timerIconView)
        timerStack.addArrangedSubview(timerLabel)
    }

    func setupLayout() {
        [
            contentContainer,
            logoWrapper,
            logoImageView,
            brandLabel,
            titleLabel,
            subtitleLabel,
            codeInputView,
            verifyButton,
            resendButton,
            timerStack,
            timerIconView,
            backToLoginButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            logoWrapper.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 84),
            logoWrapper.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            logoWrapper.widthAnchor.constraint(equalToConstant: 56),
            logoWrapper.heightAnchor.constraint(equalToConstant: 56),

            logoImageView.centerXAnchor.constraint(equalTo: logoWrapper.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoWrapper.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 22),
            logoImageView.heightAnchor.constraint(equalToConstant: 22),

            brandLabel.topAnchor.constraint(equalTo: logoWrapper.bottomAnchor, constant: 14),
            brandLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            brandLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            titleLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 56),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 48),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -48),

            codeInputView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 34),
            codeInputView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            codeInputView.heightAnchor.constraint(equalToConstant: 44),

            verifyButton.topAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: 36),
            verifyButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            verifyButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            verifyButton.heightAnchor.constraint(equalToConstant: 46),

            resendButton.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 22),
            resendButton.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),

            timerStack.topAnchor.constraint(equalTo: resendButton.bottomAnchor, constant: 8),
            timerStack.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),

            timerIconView.widthAnchor.constraint(equalToConstant: 14),
            timerIconView.heightAnchor.constraint(equalToConstant: 14),

            backToLoginButton.topAnchor.constraint(equalTo: timerStack.bottomAnchor, constant: 54),
            backToLoginButton.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor)
        ])
    }

    func applyContent() {
        brandLabel.text = "SmartWallet AI"
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        verifyButton.setTitle(buttonTitleText, for: .normal)
        resendButton.setTitle(resendTitleText, for: .normal)
        backToLoginButton.setTitle("←  \(backTitleText)", for: .normal)
    }

    func applyCornerRadius() {
        logoWrapper.layer.cornerRadius = 18
        verifyButton.layer.cornerRadius = verifyButton.bounds.height / 2
    }

    func moveForKeyboard(y: CGFloat) {
        contentContainer.transform = CGAffineTransform(translationX: 0, y: y)
    }

    @objc func handleBackgroundTap() {
        endEditing(true)
    }
}
