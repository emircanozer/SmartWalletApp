import UIKit

// shared view'Den alındı 

final class ForgotPasswordCodeContentView: UIView {
    let codeInputView = VerificationCodeInputView()
    let verifyButton = UIButton(type: .system)
    let resendButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)

    private let contentContainer = UIView()
    private let brandLabel = UILabel()
    private let iconWrapper = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let footerLabel = UILabel()
    private let footerStackView = UIStackView()

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

    override func layoutSubviews() {
        super.layoutSubviews()
        iconWrapper.layer.cornerRadius = 18
        verifyButton.layer.cornerRadius = verifyButton.bounds.height / 2
    }
}

extension ForgotPasswordCodeContentView {
    func moveForKeyboard(y: CGFloat) {
        contentContainer.transform = CGAffineTransform(translationX: 0, y: y)
    }
}

private extension ForgotPasswordCodeContentView {
    func configureView() {
        backgroundColor = .white
        contentContainer.backgroundColor = .white

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint

        brandLabel.font = .systemFont(ofSize: 20, weight: .bold)
        brandLabel.textColor = AppColor.brandTextSoft
        brandLabel.textAlignment = .center

        iconWrapper.backgroundColor = .white
        iconWrapper.layer.shadowColor = AppColor.primaryYellow.cgColor
        iconWrapper.layer.shadowOpacity = 0.12
        iconWrapper.layer.shadowRadius = 20
        iconWrapper.layer.shadowOffset = CGSize(width: 0, height: 10)

        iconImageView.image = UIImage(systemName: "lock.fill")
        iconImageView.tintColor = AppColor.warmActionText
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.textAlignment = .center

        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center

        verifyButton.backgroundColor = AppColor.primaryYellow
        verifyButton.setTitleColor(AppColor.primaryText, for: .normal)
        verifyButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        footerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        footerLabel.textColor = AppColor.actionMutedText
        footerLabel.textAlignment = .center

        resendButton.setTitleColor(AppColor.warmActionText, for: .normal)
        resendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }

    func buildHierarchy() {
        addSubview(contentContainer)
        [backButton, brandLabel, iconWrapper, titleLabel, subtitleLabel, codeInputView, verifyButton, footerStackView].forEach {
            contentContainer.addSubview($0)
        }
        iconWrapper.addSubview(iconImageView)
        [footerLabel, resendButton].forEach {
            footerStackView.addArrangedSubview($0)
        }
    }

    func setupLayout() {
        [contentContainer, backButton, brandLabel, iconWrapper, iconImageView, titleLabel, subtitleLabel, codeInputView, verifyButton, footerStackView, footerLabel, resendButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            brandLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            brandLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),

            iconWrapper.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 72),
            iconWrapper.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            iconWrapper.widthAnchor.constraint(equalToConstant: 68),
            iconWrapper.heightAnchor.constraint(equalToConstant: 68),

            iconImageView.centerXAnchor.constraint(equalTo: iconWrapper.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconWrapper.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 26),
            iconImageView.heightAnchor.constraint(equalToConstant: 26),

            titleLabel.topAnchor.constraint(equalTo: iconWrapper.bottomAnchor, constant: 36),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -40),

            codeInputView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 36),
            codeInputView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            codeInputView.heightAnchor.constraint(equalToConstant: 44),

            verifyButton.topAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: 32),
            verifyButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            verifyButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            verifyButton.heightAnchor.constraint(equalToConstant: 50),

            footerStackView.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 28),
            footerStackView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor)
        ])
    }

    func applyContent() {
        brandLabel.text = "SmartWallet AI"
        titleLabel.text = "Doğrulama Kodunu Girin"
        subtitleLabel.text = "E-posta adresinize gönderilen 6 haneli doğrulama kodunu girin."
        verifyButton.setTitle("Kodu Doğrula", for: .normal)
        footerLabel.text = "Kod gelmedi mi?"
        resendButton.setTitle("Tekrar gönder", for: .normal)
        footerStackView.axis = .horizontal
        footerStackView.alignment = .center
        footerStackView.spacing = 6
    }
}
