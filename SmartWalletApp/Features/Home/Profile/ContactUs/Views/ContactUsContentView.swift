import UIKit

final class ContactUsContentView: UIView {
    let backButton = UIButton(type: .system)
    let nameField = AuthInputFieldView(title: "", placeholder: "", iconName: "person")
    let emailField = AuthInputFieldView(title: "", placeholder: "", iconName: "envelope")
    let messageTextView = UITextView()
    let sendButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let formCardView = UIView()
    private let nameTitleLabel = UILabel()
    private let emailTitleLabel = UILabel()
    private let messageTitleLabel = UILabel()
    private let messageContainerView = UIView()
    private let messagePlaceholderLabel = UILabel()

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
        formCardView.layer.cornerRadius = 24
        messageContainerView.layer.cornerRadius = 14
        sendButton.layer.cornerRadius = 16
    }
}

extension ContactUsContentView {
    var messageText: String {
        messageTextView.text ?? ""
    }

    func apply(_ data: ContactUsViewData) {
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText
        nameTitleLabel.text = data.nameTitleText
        nameField.setPlaceholder(data.namePlaceholderText)
        emailTitleLabel.text = data.emailTitleText
        emailField.setPlaceholder(data.emailPlaceholderText)
        messageTitleLabel.text = data.messageTitleText
        messagePlaceholderLabel.text = data.messagePlaceholderText
        sendButton.setTitle(data.sendButtonTitleText, for: .normal)

        nameField.setText("")
        emailField.setText("")
    }

    func setSendEnabled(_ isEnabled: Bool) {
        sendButton.isEnabled = isEnabled
        sendButton.alpha = isEnabled ? 1.0 : 0.55
    }

    func updateMessagePlaceholderVisibility() {
        messagePlaceholderLabel.isHidden = !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func setKeyboardBottomInset(_ inset: CGFloat) {
        scrollView.contentInset.bottom = inset
        scrollView.verticalScrollIndicatorInsets.bottom = inset
    }

    func scrollToVisible(_ view: UIView) {
        let rect = view.convert(view.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -20), animated: true)
    }
}

extension ContactUsContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.accentOlive

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.numberOfLines = 2

        formCardView.backgroundColor = .white
        formCardView.layer.shadowColor = UIColor.black.cgColor
        formCardView.layer.shadowOpacity = 0.04
        formCardView.layer.shadowRadius = 16
        formCardView.layer.shadowOffset = CGSize(width: 0, height: 8)

        nameField.setAutocapitalizationType(.words)
        emailField.setKeyboardType(.emailAddress)
        emailField.setTextContentType(.emailAddress)

        [nameTitleLabel, emailTitleLabel, messageTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 13, weight: .bold)
            $0.textColor = AppColor.fieldTitleText
        }

        messageContainerView.backgroundColor = .white
        messageContainerView.layer.borderWidth = 1
        messageContainerView.layer.borderColor = AppColor.borderSoft.cgColor

        messageTextView.backgroundColor = .clear
        messageTextView.font = .systemFont(ofSize: 16, weight: .medium)
        messageTextView.textColor = AppColor.inputText
        messageTextView.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10)
        messageTextView.autocapitalizationType = .sentences
        messageTextView.autocorrectionType = .yes

        messagePlaceholderLabel.font = .systemFont(ofSize: 16, weight: .medium)
        messagePlaceholderLabel.textColor = AppColor.placeholderText
        messagePlaceholderLabel.numberOfLines = 2

        sendButton.backgroundColor = AppColor.primaryYellow
        sendButton.setTitleColor(AppColor.primaryText, for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        setSendEnabled(false)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [backButton, titleLabel, subtitleLabel, formCardView, sendButton].forEach(contentContainer.addSubview)

        [
            nameTitleLabel,
            nameField,
            emailTitleLabel,
            emailField,
            messageTitleLabel,
            messageContainerView
        ].forEach(formCardView.addSubview)

        [messageTextView, messagePlaceholderLabel].forEach(messageContainerView.addSubview)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            titleLabel,
            subtitleLabel,
            formCardView,
            nameTitleLabel,
            nameField,
            emailTitleLabel,
            emailField,
            messageTitleLabel,
            messageContainerView,
            messageTextView,
            messagePlaceholderLabel,
            sendButton
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

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            formCardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 18),
            formCardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            formCardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            nameTitleLabel.topAnchor.constraint(equalTo: formCardView.topAnchor, constant: 20),
            nameTitleLabel.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor, constant: 18),
            nameTitleLabel.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor, constant: -18),

            nameField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            nameField.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            emailTitleLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 14),
            emailTitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            emailTitleLabel.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            emailField.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 8),
            emailField.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            messageTitleLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 14),
            messageTitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            messageTitleLabel.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            messageContainerView.topAnchor.constraint(equalTo: messageTitleLabel.bottomAnchor, constant: 8),
            messageContainerView.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            messageContainerView.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),
            messageContainerView.heightAnchor.constraint(equalToConstant: 150),
            messageContainerView.bottomAnchor.constraint(equalTo: formCardView.bottomAnchor, constant: -18),

            messageTextView.topAnchor.constraint(equalTo: messageContainerView.topAnchor),
            messageTextView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor),
            messageTextView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor),
            messageTextView.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor),

            messagePlaceholderLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 14),
            messagePlaceholderLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 14),
            messagePlaceholderLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -14),

            sendButton.topAnchor.constraint(equalTo: formCardView.bottomAnchor, constant: 18),
            sendButton.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 56),
            sendButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -28)
        ])
    }
}
