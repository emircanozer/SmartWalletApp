import UIKit

final class DeleteAccountContentView: UIView {
    let backButton = UIButton(type: .system)
    let passwordField = AuthInputFieldView(
        title: "",
        placeholder: "Mevcut şifrenizi girin",
        iconName: "lock",
        trailingIconName: "lock",
        isSecure: true
    )
    let checkboxButton = UIButton(type: .system)
    let deleteButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let warningImageView = UIImageView()
    private let deletedItemsTitleLabel = UILabel()
    private let deletedItemsGrid = UIStackView()
    private let securityTitleLabel = UILabel()
    private let confirmationLabel = UILabel()

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
        checkboxButton.layer.cornerRadius = 6
        deleteButton.layer.cornerRadius = 14
        cancelButton.layer.cornerRadius = 14
    }
}

extension DeleteAccountContentView {
    func apply(_ data: DeleteAccountViewData) {
        titleLabel.text = data.titleText
        deletedItemsTitleLabel.text = data.deletedItemsTitleText
        deletedItemsTitleLabel.letterSpacing = 3
        securityTitleLabel.text = data.securityTitleText
        confirmationLabel.text = data.confirmationText
        deleteButton.setTitle(data.deleteButtonTitleText, for: .normal)
        cancelButton.setTitle(data.cancelButtonTitleText, for: .normal)
        configureDeletedItems(data.deletedItems)
    }

    func setKeyboardBottomInset(_ inset: CGFloat) {
        scrollView.contentInset.bottom = inset
        scrollView.verticalScrollIndicatorInsets.bottom = inset
    }

    func scrollToVisible(_ view: UIView) {
        let rect = view.convert(view.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -24), animated: true)
    }

    func setConfirmationChecked(_ isChecked: Bool) {
        let image = isChecked ? UIImage(systemName: "checkmark") : nil
        checkboxButton.setImage(image, for: .normal)
        checkboxButton.backgroundColor = isChecked ? AppColor.primaryYellow : .white
        checkboxButton.layer.borderColor = (isChecked ? AppColor.primaryYellow : AppColor.chipBorder).cgColor
    }

    func updateDeleteButton(isEnabled: Bool) {
        deleteButton.isEnabled = isEnabled
        deleteButton.alpha = isEnabled ? 1.0 : 0.55
    }
}

 extension DeleteAccountContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.accentOlive

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        warningImageView.image = UIImage(named: "warning")
        warningImageView.contentMode = .scaleAspectFit

        deletedItemsTitleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        deletedItemsTitleLabel.textColor = AppColor.secondaryText

        deletedItemsGrid.axis = .vertical
        deletedItemsGrid.spacing = 12
        deletedItemsGrid.distribution = .fillEqually

        securityTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        securityTitleLabel.textColor = AppColor.primaryText

        passwordField.setTextContentType(.password)

        checkboxButton.layer.borderWidth = 1
        checkboxButton.tintColor = AppColor.primaryText
        checkboxButton.setContentHuggingPriority(.required, for: .horizontal)

        confirmationLabel.font = .systemFont(ofSize: 15, weight: .medium)
        confirmationLabel.textColor = AppColor.bodyText
        confirmationLabel.numberOfLines = 0

        deleteButton.backgroundColor = AppColor.dangerStrong
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)

        cancelButton.backgroundColor = AppColor.chipSurface
        cancelButton.setTitleColor(AppColor.primaryText, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)

        setConfirmationChecked(false)
        updateDeleteButton(isEnabled: false)
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            titleLabel,
            warningImageView,
            deletedItemsTitleLabel,
            deletedItemsGrid,
            securityTitleLabel,
            passwordField,
            checkboxButton,
            confirmationLabel,
            deleteButton,
            cancelButton
        ].forEach(contentContainer.addSubview)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            titleLabel,
            warningImageView,
            deletedItemsTitleLabel,
            deletedItemsGrid,
            securityTitleLabel,
            passwordField,
            checkboxButton,
            confirmationLabel,
            deleteButton,
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

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 14),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            warningImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            warningImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            warningImageView.widthAnchor.constraint(lessThanOrEqualTo: contentContainer.widthAnchor, constant: -48),
            warningImageView.heightAnchor.constraint(equalToConstant: 300),

            deletedItemsTitleLabel.topAnchor.constraint(equalTo: warningImageView.bottomAnchor, constant: -8),
            deletedItemsTitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 28),
            deletedItemsTitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -28),

            deletedItemsGrid.topAnchor.constraint(equalTo: deletedItemsTitleLabel.bottomAnchor, constant: 8),
            deletedItemsGrid.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            deletedItemsGrid.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            deletedItemsGrid.heightAnchor.constraint(equalToConstant: 164),

            securityTitleLabel.topAnchor.constraint(equalTo: deletedItemsGrid.bottomAnchor, constant: 14),
            securityTitleLabel.leadingAnchor.constraint(equalTo: deletedItemsGrid.leadingAnchor),
            securityTitleLabel.trailingAnchor.constraint(equalTo: deletedItemsGrid.trailingAnchor),

            passwordField.topAnchor.constraint(equalTo: securityTitleLabel.bottomAnchor, constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: deletedItemsGrid.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: deletedItemsGrid.trailingAnchor),

            checkboxButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 12),
            checkboxButton.leadingAnchor.constraint(equalTo: deletedItemsGrid.leadingAnchor, constant: 10),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),

            confirmationLabel.topAnchor.constraint(equalTo: checkboxButton.topAnchor, constant: -2),
            confirmationLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 10),
            confirmationLabel.trailingAnchor.constraint(equalTo: deletedItemsGrid.trailingAnchor),

            deleteButton.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor, constant: 18),
            deleteButton.leadingAnchor.constraint(equalTo: deletedItemsGrid.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: deletedItemsGrid.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 58),

            cancelButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 14),
            cancelButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 58),
            cancelButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -36)
        ])
    }

    func configureDeletedItems(_ items: [DeleteAccountDeletedItem]) {
        deletedItemsGrid.arrangedSubviews.forEach {
            deletedItemsGrid.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        stride(from: 0, to: items.count, by: 2).forEach { index in
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 12
            row.distribution = .fillEqually

            row.addArrangedSubview(DeleteAccountDataTileView(item: items[index]))
            if index + 1 < items.count {
                row.addArrangedSubview(DeleteAccountDataTileView(item: items[index + 1]))
            } else {
                row.addArrangedSubview(UIView())
            }

            deletedItemsGrid.addArrangedSubview(row)
        }
    }
}

private final class DeleteAccountDataTileView: UIView {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()

    init(item: DeleteAccountDeletedItem) {
        super.init(frame: .zero)
        configureView()
        buildHierarchy()
        setupLayout()
        iconView.image = UIImage(systemName: item.iconName)
        titleLabel.text = item.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 14
    }

    private func configureView() {
        backgroundColor = AppColor.surfaceMuted

        iconView.tintColor = AppColor.navigationTint
        iconView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.numberOfLines = 2
    }

    private func buildHierarchy() {
        [iconView, titleLabel].forEach(addSubview)
    }

    private func setupLayout() {
        [iconView, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

 extension UILabel {
    func setLineSpacing(_ spacing: CGFloat) {
        guard let text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.lineBreakMode = .byWordWrapping
        attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: font as Any,
                .foregroundColor: textColor as Any
            ]
        )
    }

    var letterSpacing: CGFloat {
        get { 0 }
        set {
            guard let text else { return }
            attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .kern: newValue,
                    .font: font as Any,
                    .foregroundColor: textColor as Any
                ]
            )
        }
    }
}
