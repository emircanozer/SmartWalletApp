import UIKit

final class ChangePasswordContentView: UIView {
    let backButton = UIButton(type: .system)
    let currentPasswordField = ChangePasswordSecureFieldView()
    let newPasswordField = ChangePasswordSecureFieldView()
    let confirmPasswordField = ChangePasswordSecureFieldView()
    let updateButton = UIButton(type: .system)
    let forgotPasswordButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let headlineLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var isUpdateButtonEnabled = false

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
        updateButton.layer.cornerRadius = 14
    }
}

extension ChangePasswordContentView {
    func apply(_ data: ChangePasswordViewData) {
        titleLabel.text = data.titleText
        headlineLabel.text = data.headlineText
        descriptionLabel.text = data.descriptionText
        currentPasswordField.configure(
            title: data.currentPasswordTitleText,
            placeholder: data.currentPasswordPlaceholderText
        )
        newPasswordField.configure(
            title: data.newPasswordTitleText,
            placeholder: data.newPasswordPlaceholderText,
            helperText: data.newPasswordHelperText
        )
        confirmPasswordField.configure(
            title: data.confirmPasswordTitleText,
            placeholder: data.confirmPasswordPlaceholderText
        )
        updateButton.setTitle(data.updateButtonTitleText, for: .normal)
        forgotPasswordButton.setTitle(data.forgotPasswordTitleText, for: .normal)
        setUpdateEnabled(false)
    }

    func applyFormState(_ state: ChangePasswordFormState) {
        confirmPasswordField.setErrorText(state.confirmPasswordErrorText)
        setUpdateEnabled(state.isUpdateEnabled)
    }

    func setLoading(_ isLoading: Bool) {
        updateButton.isEnabled = !isLoading && isUpdateButtonEnabled
        updateButton.alpha = isLoading ? 0.85 : (isUpdateButtonEnabled ? 1 : 0.55)
        currentPasswordField.setEnabled(!isLoading)
        newPasswordField.setEnabled(!isLoading)
        confirmPasswordField.setEnabled(!isLoading)
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

    private func setUpdateEnabled(_ isEnabled: Bool) {
        isUpdateButtonEnabled = isEnabled
        updateButton.isEnabled = isEnabled
        updateButton.alpha = isEnabled ? 1 : 0.55
    }
}

 extension ChangePasswordContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.accentOlive

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        headlineLabel.font = .systemFont(ofSize: 24, weight: .bold)
        headlineLabel.textColor = AppColor.primaryText

        descriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textColor = AppColor.bodyText
        descriptionLabel.numberOfLines = 0

        updateButton.backgroundColor = AppColor.primaryYellow
        updateButton.setTitleColor(AppColor.primaryText, for: .normal)
        updateButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)

        forgotPasswordButton.setTitleColor(AppColor.accentOlive, for: .normal)
        forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            titleLabel,
            headlineLabel,
            descriptionLabel,
            currentPasswordField,
            newPasswordField,
            confirmPasswordField,
            updateButton,
            forgotPasswordButton
        ].forEach(contentContainer.addSubview)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            titleLabel,
            headlineLabel,
            descriptionLabel,
            currentPasswordField,
            newPasswordField,
            confirmPasswordField,
            updateButton,
            forgotPasswordButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let bottomSpacer = contentContainer.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, constant: -safeAreaInsets.top)
        bottomSpacer.priority = .defaultLow

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
            bottomSpacer,

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            headlineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48),
            headlineLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 26),
            headlineLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -26),

            descriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),

            currentPasswordField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 44),
            currentPasswordField.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            currentPasswordField.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),

            newPasswordField.topAnchor.constraint(equalTo: currentPasswordField.bottomAnchor, constant: 22),
            newPasswordField.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            newPasswordField.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),

            confirmPasswordField.topAnchor.constraint(equalTo: newPasswordField.bottomAnchor, constant: 22),
            confirmPasswordField.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            confirmPasswordField.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),

            updateButton.topAnchor.constraint(greaterThanOrEqualTo: confirmPasswordField.bottomAnchor, constant: 28),
            updateButton.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            updateButton.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),
            updateButton.heightAnchor.constraint(equalToConstant: 56),

            forgotPasswordButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 14),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            forgotPasswordButton.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -96)
        ])
    }
}

final class ChangePasswordSecureFieldView: UIView {
    private let titleLabel = UILabel()
    private let containerView = UIView()
    private let textField = UITextField()
    private let visibilityButton = UIButton(type: .system)
    private let helperLabel = UILabel()

    var trimmedText: String {
        (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

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
        containerView.layer.cornerRadius = 12
    }

    func configure(title: String, placeholder: String, helperText: String? = nil) {
        titleLabel.text = title
        setPlaceholder(placeholder)
        helperLabel.text = helperText
        helperLabel.isHidden = helperText == nil
        titleLabel.textColor = AppColor.fieldTitleText
        containerView.layer.borderColor = AppColor.borderSoft.cgColor
    }

    func addEditingChangedTarget(_ target: Any?, action: Selector) {
        textField.addTarget(target, action: action, for: .editingChanged)
    }

    func addEditingDidBeginTarget(_ target: Any?, action: Selector) {
        textField.addTarget(target, action: action, for: .editingDidBegin)
    }

    func addVisibilityTarget(_ target: Any?, action: Selector) {
        visibilityButton.addTarget(target, action: action, for: .touchUpInside)
    }

    func toggleSecureEntry() {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "eye" : "eye.slash"
        visibilityButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    func setErrorText(_ errorText: String?) {
        helperLabel.text = errorText
        helperLabel.isHidden = errorText == nil
        helperLabel.textColor = errorText == nil ? AppColor.helperText : AppColor.dangerStrong
        titleLabel.textColor = errorText == nil ? AppColor.fieldTitleText : AppColor.dangerStrong
        containerView.layer.borderColor = (errorText == nil ? AppColor.borderSoft : AppColor.dangerStrong).cgColor
        visibilityButton.tintColor = errorText == nil ? AppColor.iconMuted : AppColor.dangerStrong
    }

    func setEnabled(_ isEnabled: Bool) {
        textField.isEnabled = isEnabled
        visibilityButton.isEnabled = isEnabled
        alpha = isEnabled ? 1 : 0.75
    }

    private func configureView() {
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = AppColor.fieldTitleText
        titleLabel.letterSpacing = 1.2

        containerView.backgroundColor = AppColor.surfaceMuted
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = AppColor.borderSoft.cgColor

        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 18, weight: .semibold)
        textField.textColor = AppColor.inputText
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no

        visibilityButton.setImage(UIImage(systemName: "eye"), for: .normal)
        visibilityButton.tintColor = AppColor.iconMuted

        helperLabel.font = .systemFont(ofSize: 12, weight: .medium)
        helperLabel.textColor = AppColor.helperText
        helperLabel.numberOfLines = 0
        helperLabel.isHidden = true
    }

    private func buildHierarchy() {
        [titleLabel, containerView, helperLabel].forEach(addSubview)
        [textField, visibilityButton].forEach(containerView.addSubview)
    }

    private func setupLayout() {
        [titleLabel, containerView, textField, visibilityButton, helperLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 58),

            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: visibilityButton.leadingAnchor, constant: -12),

            visibilityButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            visibilityButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            visibilityButton.widthAnchor.constraint(equalToConstant: 24),
            visibilityButton.heightAnchor.constraint(equalToConstant: 24),

            helperLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            helperLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            helperLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            helperLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setPlaceholder(_ placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: AppColor.placeholderText,
                .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ]
        )
    }
}
