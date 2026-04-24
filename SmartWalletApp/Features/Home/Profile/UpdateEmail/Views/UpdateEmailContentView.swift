import UIKit

final class UpdateEmailContentView: UIView {
    let backButton = UIButton(type: .system)
    let newEmailField = AuthInputFieldView(title: "", placeholder: "", iconName: "envelope")
    let confirmEmailField = AuthInputFieldView(title: "", placeholder: "", iconName: "envelope")
    let sendButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let currentEmailCardView = UIView()
    private let currentEmailIconContainer = UIView()
    private let currentEmailIconView = UIImageView()
    private let currentEmailTitleLabel = UILabel()
    private let currentEmailValueLabel = UILabel()
    private let newEmailTitleLabel = UILabel()
    private let confirmEmailTitleLabel = UILabel()
    private let confirmEmailErrorLabel = UILabel()
    private let infoImageView = UIImageView()
    private var isSendButtonEnabled = false

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
        currentEmailCardView.layer.cornerRadius = 22
        currentEmailIconContainer.layer.cornerRadius = 12
        sendButton.layer.cornerRadius = 16
    }
}

extension UpdateEmailContentView {
    func apply(_ data: UpdateEmailViewData) {
        titleLabel.text = data.titleText
        descriptionLabel.text = data.descriptionText
        currentEmailTitleLabel.text = data.currentEmailTitleText
        currentEmailValueLabel.text = data.currentEmailText
        newEmailTitleLabel.text = data.newEmailTitleText
        newEmailField.setPlaceholder(data.newEmailPlaceholderText)
        confirmEmailTitleLabel.text = data.confirmEmailTitleText
        confirmEmailField.setPlaceholder(data.confirmEmailPlaceholderText)
        sendButton.setTitle(data.sendButtonTitleText, for: .normal)
        cancelButton.setTitle(data.cancelButtonTitleText, for: .normal)
        setSendEnabled(false)
    }

    func applyFormState(_ state: UpdateEmailFormState) {
        confirmEmailErrorLabel.text = state.confirmEmailErrorText
        confirmEmailErrorLabel.isHidden = state.confirmEmailErrorText == nil
        confirmEmailTitleLabel.textColor = state.confirmEmailErrorText == nil ? AppColor.primaryText : AppColor.dangerStrong
        setSendEnabled(state.isSendEnabled)
    }

    func setLoading(_ isLoading: Bool) {
        sendButton.isEnabled = !isLoading && isSendButtonEnabled
        sendButton.alpha = isLoading ? 0.85 : (isSendButtonEnabled ? 1 : 0.55)
        newEmailField.alpha = isLoading ? 0.75 : 1
        confirmEmailField.alpha = isLoading ? 0.75 : 1
    }

    func setKeyboardBottomInset(_ inset: CGFloat) {
        scrollView.contentInset.bottom = inset
        scrollView.verticalScrollIndicatorInsets.bottom = inset
    }

    func scrollToVisible(_ view: UIView) {
        let rect = view.convert(view.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -24), animated: true)
    }

    func dismissKeyboard() {
        endEditing(true)
    }

    private func setSendEnabled(_ isEnabled: Bool) {
        isSendButtonEnabled = isEnabled
        sendButton.isEnabled = isEnabled
        sendButton.alpha = isEnabled ? 1 : 0.55
    }
}

 extension UpdateEmailContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.accentOlive

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        descriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textColor = AppColor.bodyText
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setLineSpacing(5)

        currentEmailCardView.backgroundColor = .white
        currentEmailCardView.layer.shadowColor = UIColor.black.cgColor
        currentEmailCardView.layer.shadowOpacity = 0.04
        currentEmailCardView.layer.shadowRadius = 16
        currentEmailCardView.layer.shadowOffset = CGSize(width: 0, height: 8)

        currentEmailIconContainer.backgroundColor = AppColor.surfaceMuted

        currentEmailIconView.image = UIImage(systemName: "envelope")
        currentEmailIconView.tintColor = AppColor.accentOlive
        currentEmailIconView.contentMode = .scaleAspectFit

        currentEmailTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        currentEmailTitleLabel.textColor = AppColor.secondaryText
        currentEmailTitleLabel.letterSpacing = 1.5

        currentEmailValueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        currentEmailValueLabel.textColor = AppColor.primaryText
        currentEmailValueLabel.adjustsFontSizeToFitWidth = true
        currentEmailValueLabel.minimumScaleFactor = 0.75

        [newEmailTitleLabel, confirmEmailTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .bold)
            $0.textColor = AppColor.primaryText
        }

        newEmailField.setKeyboardType(.emailAddress)
        newEmailField.setTextContentType(.emailAddress)
        confirmEmailField.setKeyboardType(.emailAddress)
        confirmEmailField.setTextContentType(.emailAddress)

        confirmEmailErrorLabel.font = .systemFont(ofSize: 12, weight: .medium)
        confirmEmailErrorLabel.textColor = AppColor.dangerStrong
        confirmEmailErrorLabel.isHidden = true

        infoImageView.image = UIImage(named: "info")
        infoImageView.contentMode = .scaleAspectFit

        sendButton.backgroundColor = AppColor.primaryYellow
        sendButton.setTitleColor(AppColor.primaryText, for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)

        cancelButton.setTitleColor(AppColor.primaryText, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            titleLabel,
            descriptionLabel,
            currentEmailCardView,
            newEmailTitleLabel,
            newEmailField,
            confirmEmailTitleLabel,
            confirmEmailField,
            confirmEmailErrorLabel,
            infoImageView,
            sendButton,
            cancelButton
        ].forEach(contentContainer.addSubview)

        [currentEmailIconContainer, currentEmailTitleLabel, currentEmailValueLabel].forEach(currentEmailCardView.addSubview)
        currentEmailIconContainer.addSubview(currentEmailIconView)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            titleLabel,
            descriptionLabel,
            currentEmailCardView,
            currentEmailIconContainer,
            currentEmailIconView,
            currentEmailTitleLabel,
            currentEmailValueLabel,
            newEmailTitleLabel,
            newEmailField,
            confirmEmailTitleLabel,
            confirmEmailField,
            confirmEmailErrorLabel,
            infoImageView,
            sendButton,
            cancelButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

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

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 26),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -26),

            currentEmailCardView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            currentEmailCardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 28),
            currentEmailCardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -28),
            currentEmailCardView.heightAnchor.constraint(equalToConstant: 96),

            currentEmailIconContainer.leadingAnchor.constraint(equalTo: currentEmailCardView.leadingAnchor, constant: 22),
            currentEmailIconContainer.centerYAnchor.constraint(equalTo: currentEmailCardView.centerYAnchor),
            currentEmailIconContainer.widthAnchor.constraint(equalToConstant: 46),
            currentEmailIconContainer.heightAnchor.constraint(equalToConstant: 46),

            currentEmailIconView.centerXAnchor.constraint(equalTo: currentEmailIconContainer.centerXAnchor),
            currentEmailIconView.centerYAnchor.constraint(equalTo: currentEmailIconContainer.centerYAnchor),
            currentEmailIconView.widthAnchor.constraint(equalToConstant: 22),
            currentEmailIconView.heightAnchor.constraint(equalToConstant: 22),

            currentEmailTitleLabel.topAnchor.constraint(equalTo: currentEmailCardView.topAnchor, constant: 26),
            currentEmailTitleLabel.leadingAnchor.constraint(equalTo: currentEmailIconContainer.trailingAnchor, constant: 18),
            currentEmailTitleLabel.trailingAnchor.constraint(equalTo: currentEmailCardView.trailingAnchor, constant: -18),

            currentEmailValueLabel.topAnchor.constraint(equalTo: currentEmailTitleLabel.bottomAnchor, constant: 6),
            currentEmailValueLabel.leadingAnchor.constraint(equalTo: currentEmailTitleLabel.leadingAnchor),
            currentEmailValueLabel.trailingAnchor.constraint(equalTo: currentEmailTitleLabel.trailingAnchor),

            newEmailTitleLabel.topAnchor.constraint(equalTo: currentEmailCardView.bottomAnchor, constant: 34),
            newEmailTitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 32),
            newEmailTitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -32),

            newEmailField.topAnchor.constraint(equalTo: newEmailTitleLabel.bottomAnchor, constant: 8),
            newEmailField.leadingAnchor.constraint(equalTo: newEmailTitleLabel.leadingAnchor),
            newEmailField.trailingAnchor.constraint(equalTo: newEmailTitleLabel.trailingAnchor),

            confirmEmailTitleLabel.topAnchor.constraint(equalTo: newEmailField.bottomAnchor, constant: 22),
            confirmEmailTitleLabel.leadingAnchor.constraint(equalTo: newEmailTitleLabel.leadingAnchor),
            confirmEmailTitleLabel.trailingAnchor.constraint(equalTo: newEmailTitleLabel.trailingAnchor),

            confirmEmailField.topAnchor.constraint(equalTo: confirmEmailTitleLabel.bottomAnchor, constant: 8),
            confirmEmailField.leadingAnchor.constraint(equalTo: newEmailTitleLabel.leadingAnchor),
            confirmEmailField.trailingAnchor.constraint(equalTo: newEmailTitleLabel.trailingAnchor),

            confirmEmailErrorLabel.topAnchor.constraint(equalTo: confirmEmailField.bottomAnchor, constant: 4),
            confirmEmailErrorLabel.leadingAnchor.constraint(equalTo: newEmailTitleLabel.leadingAnchor),
            confirmEmailErrorLabel.trailingAnchor.constraint(equalTo: newEmailTitleLabel.trailingAnchor),

            infoImageView.topAnchor.constraint(equalTo: confirmEmailErrorLabel.bottomAnchor, constant: 18),
            infoImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            infoImageView.widthAnchor.constraint(equalToConstant: 330),
            infoImageView.heightAnchor.constraint(equalToConstant: 75),

            sendButton.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 46),
            sendButton.leadingAnchor.constraint(equalTo: newEmailTitleLabel.leadingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: newEmailTitleLabel.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 58),

            cancelButton.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 18),
            cancelButton.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            cancelButton.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -30)
        ])
    }
}
