import UIKit

final class UpdateEmailCodeContentView: UIView {
    let codeInputView = VerificationCodeInputView()
    let verifyButton = UIButton(type: .system)
    let resendButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let backgroundTapGesture = UITapGestureRecognizer()

    private let contentContainer = UIView()
    private let brandLabel = UILabel()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let footerLabel = UILabel()
    private let footerStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        verifyButton.layer.cornerRadius = verifyButton.bounds.height / 2
    }
}

extension UpdateEmailCodeContentView {
    func apply(_ data: UpdateEmailCodeViewData) {
        brandLabel.text = data.brandText
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText
        verifyButton.setTitle(data.verifyButtonTitleText, for: .normal)
        footerLabel.text = data.footerText
        resendButton.setTitle(data.resendButtonTitleText, for: .normal)
    }

    func moveForKeyboard(y: CGFloat) {
        contentContainer.transform = CGAffineTransform(translationX: 0, y: y)
    }

    func setVerifyEnabled(_ isEnabled: Bool) {
        verifyButton.isEnabled = isEnabled
        verifyButton.alpha = isEnabled ? 1 : 0.65
    }

    func setLoading(_ isLoading: Bool) {
        setVerifyEnabled(!isLoading && codeInputView.code.count == 6)
        resendButton.isEnabled = !isLoading
        resendButton.alpha = isLoading ? 0.7 : 1
    }
}

 extension UpdateEmailCodeContentView {
    func configureView() {
        backgroundColor = .white
        contentContainer.backgroundColor = .white

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint

        brandLabel.font = .systemFont(ofSize: 20, weight: .bold)
        brandLabel.textColor = AppColor.brandTextSoft
        brandLabel.textAlignment = .center

        logoImageView.image = UIImage(named: "lock")
        logoImageView.contentMode = .scaleAspectFit

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

        footerStackView.axis = .horizontal
        footerStackView.alignment = .center
        footerStackView.spacing = 6

        backgroundTapGesture.cancelsTouchesInView = false
        addGestureRecognizer(backgroundTapGesture)
    }

    func buildHierarchy() {
        addSubview(contentContainer)
        [backButton, brandLabel, logoImageView, titleLabel, subtitleLabel, codeInputView, verifyButton, footerStackView].forEach {
            contentContainer.addSubview($0)
        }
        [footerLabel, resendButton].forEach {
            footerStackView.addArrangedSubview($0)
        }
    }

    func setupLayout() {
        [contentContainer, backButton, brandLabel, logoImageView, titleLabel, subtitleLabel, codeInputView, verifyButton, footerStackView, footerLabel, resendButton].forEach {
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

            logoImageView.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 28),
            logoImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 180),
            logoImageView.heightAnchor.constraint(equalToConstant: 180),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -40),

            codeInputView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 38),
            codeInputView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            codeInputView.heightAnchor.constraint(equalToConstant: 44),

            verifyButton.topAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: 38),
            verifyButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            verifyButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            verifyButton.heightAnchor.constraint(equalToConstant: 56),

            footerStackView.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 28),
            footerStackView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor)
        ])
    }
}
