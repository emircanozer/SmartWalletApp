import UIKit

final class ResetPasswordContentView: UIView {
    let backButton = UIButton(type: .system)
    let passwordField = AuthInputFieldView(
        title: "YENİ ŞİFRE",
        placeholder: "Yeni şifrenizi girin",
        iconName: "key",
        trailingIconName: "eye",
        isSecure: true
    )
    let confirmPasswordField = AuthInputFieldView(
        title: "YENİ ŞİFRE (TEKRAR)",
        placeholder: "Yeni şifrenizi tekrar girin",
        iconName: "key",
        trailingIconName: "eye",
        isSecure: true
    )
    let updateButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let brandLabel = UILabel()
    private let heroImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

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
        updateButton.layer.cornerRadius = updateButton.bounds.height / 2
    }
}

extension ResetPasswordContentView {
    func dismissKeyboard() {
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

extension ResetPasswordContentView {
    func configureView() {
        backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag

        contentContainer.backgroundColor = .white

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint

        brandLabel.font = .systemFont(ofSize: 20, weight: .bold)
        brandLabel.textColor = AppColor.brandTextSoft
        brandLabel.textAlignment = .center

        heroImageView.image = UIImage(named: "passwordPage")
        heroImageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.textAlignment = .center

        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.textAlignment = .center

        updateButton.backgroundColor = AppColor.primaryYellow
        updateButton.setTitleColor(AppColor.authHeadingText, for: .normal)
        updateButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        passwordField.setTextContentType(.newPassword)
        confirmPasswordField.setTextContentType(.newPassword)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [backButton, brandLabel, heroImageView, titleLabel, subtitleLabel, passwordField, confirmPasswordField, updateButton].forEach {
            contentContainer.addSubview($0)
        }
    }

    func setupLayout() {
        [scrollView, contentContainer, backButton, brandLabel, heroImageView, titleLabel, subtitleLabel, passwordField, confirmPasswordField, updateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            contentContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            brandLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            brandLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),

            heroImageView.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 40),
            heroImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            heroImageView.widthAnchor.constraint(equalToConstant: 330),
            heroImageView.heightAnchor.constraint(equalToConstant: 192),

            titleLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            passwordField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 36),
            passwordField.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            passwordField.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            confirmPasswordField.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            confirmPasswordField.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),

            updateButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 42),
            updateButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            updateButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            updateButton.heightAnchor.constraint(equalToConstant: 54),
            updateButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -30)
        ])
    }

    func applyContent() {
        brandLabel.text = "SmartWallet AI"
        titleLabel.text = "Yeni Şifre Oluştur"
        subtitleLabel.text = "Yeni şifrenizi belirleyin."
        updateButton.setTitle("Şifreyi Güncelle", for: .normal)
    }
}
