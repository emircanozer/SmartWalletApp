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
        backgroundColor = AppColor.appBackground
        contentContainer.backgroundColor = AppColor.appBackground

        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit

        brandLabel.textAlignment = .center
        brandLabel.font = .systemFont(ofSize: 18, weight: .bold)
        brandLabel.textColor = AppColor.brandTextSoft

        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.authHeadingText

        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.numberOfLines = 0

        verifyButton.backgroundColor = AppColor.primaryYellow
        verifyButton.setTitleColor(AppColor.authHeadingText, for: .normal)
        verifyButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        verifyButton.layer.shadowColor = AppColor.primaryYellow.cgColor
        verifyButton.layer.shadowOpacity = 0.18
        verifyButton.layer.shadowRadius = 18
        verifyButton.layer.shadowOffset = CGSize(width: 0, height: 10)

        resendButton.setTitleColor(AppColor.actionMutedText, for: .normal)
        resendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        resendButton.isHidden = true

        timerStack.axis = .horizontal
        timerStack.alignment = .center
        timerStack.spacing = 4

        timerIconView.image = UIImage(systemName: "clock")
        timerIconView.tintColor = AppColor.placeholderText
        timerIconView.contentMode = .scaleAspectFit

        timerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        timerLabel.textColor = AppColor.placeholderText

        backToLoginButton.setTitleColor(AppColor.actionMutedText, for: .normal)
        backToLoginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        keyboardTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        keyboardTapGesture.cancelsTouchesInView = false
        addGestureRecognizer(keyboardTapGesture)
    }

    func buildHierarchy() {
        addSubview(contentContainer)

        contentContainer.addSubview(logoImageView)
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

            logoImageView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 84),
            logoImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 72),
            logoImageView.heightAnchor.constraint(equalToConstant: 72),

            brandLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 14),
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
        verifyButton.layer.cornerRadius = verifyButton.bounds.height / 2
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = 15
        
    }

    func moveForKeyboard(y: CGFloat) {
        contentContainer.transform = CGAffineTransform(translationX: 0, y: y)
    }

    @objc func handleBackgroundTap() {
        endEditing(true)
    }
}
