import UIKit

final class SendMoneyContentView: UIView {
    let ibanTextField = UITextField()
    let amountTextField = UITextField()
    let noteTextView = UITextView()
    let confirmButton = UIButton(type: .system)
    let lookupView = SendMoneyLookupView()
    let categoryButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let amountSectionLabel = UILabel()
    private let balanceInfoLabel = UILabel()
    private let amountCard = UIView()
    private let amountTitleLabel = UILabel()
    private let amountInputStack = UIStackView()
    private let amountCurrencyLabel = UILabel()
    private let amountErrorLabel = UILabel()
    private let amountChipsStack = UIStackView()
    private let recipientsTitleLabel = UILabel()
    private let allRecipientsButton = UIButton(type: .system)
    private let recipientsStack = UIStackView()
    private let ibanSectionLabel = UILabel()
    private let ibanFieldContainer = UIView()
    private let ibanIconView = UIImageView()
    private let categorySectionLabel = UILabel()
    private let categoryFieldContainer = UIView()
    private let categoryChevronView = UIImageView()
    private let noteSectionLabel = UILabel()
    private let noteContainer = UIView()
    private let notePlaceholderLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    private var amountChipButtons: [SendMoneyAmountChipButton] = []
    private var recipientViews: [SendMoneyRecipientRowView] = []
    private var lookupHeightConstraint: NSLayoutConstraint?

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
        [amountCard, ibanFieldContainer, categoryFieldContainer, noteContainer, confirmButton].forEach {
            $0.layer.cornerRadius = 20
        }
    }
}

extension SendMoneyContentView {
    func setRefreshControl(_ refreshControl: UIRefreshControl) {
        scrollView.refreshControl = refreshControl
    }

    func configureView() {
        backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = AppColor.mutedText
        subtitleLabel.numberOfLines = 0

        amountSectionLabel.font = .systemFont(ofSize: 12, weight: .bold)
        amountSectionLabel.textColor = AppColor.secondaryText

        balanceInfoLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        balanceInfoLabel.textColor = AppColor.secondaryText

        amountCard.backgroundColor = AppColor.darkSurfaceSoft

        amountTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        amountTitleLabel.textColor = AppColor.amountLabelMuted
        amountTitleLabel.textAlignment = .center

        amountInputStack.axis = .horizontal
        amountInputStack.alignment = .center
        amountInputStack.spacing = 6
        amountInputStack.distribution = .fill

        amountCurrencyLabel.font = .systemFont(ofSize: 34, weight: .bold)
        amountCurrencyLabel.textColor = .white

        amountTextField.font = .systemFont(ofSize: 36, weight: .bold)
        amountTextField.textColor = .white
        amountTextField.keyboardType = .decimalPad
        amountTextField.textAlignment = .left

        amountErrorLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        amountErrorLabel.textColor = AppColor.dangerStrong
        amountErrorLabel.numberOfLines = 0
        amountErrorLabel.isHidden = true

        amountChipsStack.axis = .horizontal
        amountChipsStack.alignment = .fill
        amountChipsStack.distribution = .fillEqually
        amountChipsStack.spacing = 8

        recipientsTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        recipientsTitleLabel.textColor = AppColor.primaryText

        allRecipientsButton.setTitleColor(AppColor.accentOlive, for: .normal)
        allRecipientsButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)

        recipientsStack.axis = .vertical
        recipientsStack.spacing = 10

        ibanSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        ibanSectionLabel.textColor = AppColor.primaryText

        ibanFieldContainer.backgroundColor = AppColor.surfacePanel
        ibanFieldContainer.layer.borderWidth = 1
        ibanFieldContainer.layer.borderColor = AppColor.chipSurface.cgColor

        ibanIconView.image = UIImage(systemName: "creditcard")
        ibanIconView.tintColor = AppColor.iconMuted
        ibanIconView.contentMode = .scaleAspectFit

        ibanTextField.font = .systemFont(ofSize: 15, weight: .semibold)
        ibanTextField.textColor = AppColor.inputText
        ibanTextField.autocapitalizationType = .allCharacters
        ibanTextField.autocorrectionType = .no

        categorySectionLabel.font = .systemFont(ofSize: 18, weight: .bold)
        categorySectionLabel.textColor = AppColor.primaryText

        categoryFieldContainer.backgroundColor = AppColor.surfacePanel
        categoryFieldContainer.layer.borderWidth = 1
        categoryFieldContainer.layer.borderColor = AppColor.chipSurface.cgColor

        categoryButton.contentHorizontalAlignment = .left
        categoryButton.setTitleColor(AppColor.inputText, for: .normal)
        categoryButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)

        categoryChevronView.image = UIImage(systemName: "chevron.down")
        categoryChevronView.tintColor = AppColor.iconMuted
        categoryChevronView.contentMode = .scaleAspectFit

        noteSectionLabel.font = .systemFont(ofSize: 18, weight: .bold)
        noteSectionLabel.textColor = AppColor.primaryText

        noteContainer.backgroundColor = AppColor.surfacePanel
        noteContainer.layer.borderWidth = 1
        noteContainer.layer.borderColor = AppColor.chipSurface.cgColor

        noteTextView.font = .systemFont(ofSize: 15, weight: .medium)
        noteTextView.textColor = AppColor.inputText
        noteTextView.backgroundColor = .clear

        notePlaceholderLabel.font = .systemFont(ofSize: 15, weight: .medium)
        notePlaceholderLabel.textColor = AppColor.notePlaceholder

        confirmButton.backgroundColor = AppColor.darkSurface
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)

        loadingIndicator.hidesWhenStopped = true
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)

        [
            titleLabel,
            subtitleLabel,
            amountSectionLabel,
            balanceInfoLabel,
            amountCard,
            amountErrorLabel,
            recipientsTitleLabel,
            allRecipientsButton,
            recipientsStack,
            ibanSectionLabel,
            ibanFieldContainer,
            lookupView,
            categorySectionLabel,
            categoryFieldContainer,
            noteSectionLabel,
            noteContainer,
            confirmButton
        ].forEach {
            containerView.addSubview($0)
        }

        amountCard.addSubview(amountTitleLabel)
        amountCard.addSubview(amountInputStack)
        amountCard.addSubview(amountChipsStack)
        amountCard.addSubview(loadingIndicator)

        amountInputStack.addArrangedSubview(amountCurrencyLabel)
        amountInputStack.addArrangedSubview(amountTextField)

        ibanFieldContainer.addSubview(ibanTextField)
        ibanFieldContainer.addSubview(ibanIconView)
        categoryFieldContainer.addSubview(categoryButton)
        categoryFieldContainer.addSubview(categoryChevronView)

        noteContainer.addSubview(noteTextView)
        noteContainer.addSubview(notePlaceholderLabel)
    }

    func setupLayout() {
        [
            scrollView,
            containerView,
            titleLabel,
            subtitleLabel,
            amountSectionLabel,
            balanceInfoLabel,
            amountCard,
            amountTitleLabel,
            amountInputStack,
            amountCurrencyLabel,
            amountTextField,
            amountErrorLabel,
            amountChipsStack,
            recipientsTitleLabel,
            allRecipientsButton,
            recipientsStack,
            ibanSectionLabel,
            ibanFieldContainer,
            ibanTextField,
            ibanIconView,
            lookupView,
            categorySectionLabel,
            categoryFieldContainer,
            categoryButton,
            categoryChevronView,
            noteSectionLabel,
            noteContainer,
            noteTextView,
            notePlaceholderLabel,
            balanceInfoLabel,
            confirmButton,
            loadingIndicator
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            amountSectionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 22),
            amountSectionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            balanceInfoLabel.topAnchor.constraint(equalTo: amountSectionLabel.bottomAnchor, constant: 6),
            balanceInfoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            balanceInfoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            amountCard.topAnchor.constraint(equalTo: balanceInfoLabel.bottomAnchor, constant: 10),
            amountCard.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            amountCard.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            amountTitleLabel.topAnchor.constraint(equalTo: amountCard.topAnchor, constant: 14),
            amountTitleLabel.leadingAnchor.constraint(equalTo: amountCard.leadingAnchor, constant: 20),
            amountTitleLabel.trailingAnchor.constraint(equalTo: amountCard.trailingAnchor, constant: -20),

            amountInputStack.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor, constant: 10),
            amountInputStack.centerXAnchor.constraint(equalTo: amountCard.centerXAnchor),
            amountInputStack.leadingAnchor.constraint(greaterThanOrEqualTo: amountCard.leadingAnchor, constant: 20),
            amountInputStack.trailingAnchor.constraint(lessThanOrEqualTo: amountCard.trailingAnchor, constant: -20),

            amountTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 72),

            amountChipsStack.topAnchor.constraint(equalTo: amountInputStack.bottomAnchor, constant: 14),
            amountChipsStack.leadingAnchor.constraint(equalTo: amountCard.leadingAnchor, constant: 12),
            amountChipsStack.trailingAnchor.constraint(equalTo: amountCard.trailingAnchor, constant: -12),
            amountChipsStack.heightAnchor.constraint(equalToConstant: 38),
            amountChipsStack.bottomAnchor.constraint(equalTo: amountCard.bottomAnchor, constant: -14),

            loadingIndicator.topAnchor.constraint(equalTo: amountCard.topAnchor, constant: 16),
            loadingIndicator.trailingAnchor.constraint(equalTo: amountCard.trailingAnchor, constant: -16),

            amountErrorLabel.topAnchor.constraint(equalTo: amountCard.bottomAnchor, constant: 8),
            amountErrorLabel.leadingAnchor.constraint(equalTo: amountCard.leadingAnchor, constant: 2),
            amountErrorLabel.trailingAnchor.constraint(equalTo: amountCard.trailingAnchor, constant: -2),

            recipientsTitleLabel.topAnchor.constraint(equalTo: amountErrorLabel.bottomAnchor, constant: 18),
            recipientsTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            allRecipientsButton.centerYAnchor.constraint(equalTo: recipientsTitleLabel.centerYAnchor),
            allRecipientsButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            recipientsStack.topAnchor.constraint(equalTo: recipientsTitleLabel.bottomAnchor, constant: 12),
            recipientsStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            recipientsStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            ibanSectionLabel.topAnchor.constraint(equalTo: recipientsStack.bottomAnchor, constant: 18),
            ibanSectionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ibanSectionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            ibanFieldContainer.topAnchor.constraint(equalTo: ibanSectionLabel.bottomAnchor, constant: 10),
            ibanFieldContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ibanFieldContainer.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            ibanFieldContainer.heightAnchor.constraint(equalToConstant: 52),

            ibanTextField.leadingAnchor.constraint(equalTo: ibanFieldContainer.leadingAnchor, constant: 14),
            ibanTextField.trailingAnchor.constraint(equalTo: ibanIconView.leadingAnchor, constant: -10),
            ibanTextField.centerYAnchor.constraint(equalTo: ibanFieldContainer.centerYAnchor),

            ibanIconView.trailingAnchor.constraint(equalTo: ibanFieldContainer.trailingAnchor, constant: -14),
            ibanIconView.centerYAnchor.constraint(equalTo: ibanFieldContainer.centerYAnchor),
            ibanIconView.widthAnchor.constraint(equalToConstant: 20),
            ibanIconView.heightAnchor.constraint(equalToConstant: 20),

            lookupView.topAnchor.constraint(equalTo: ibanFieldContainer.bottomAnchor, constant: 10),
            lookupView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lookupView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            categorySectionLabel.topAnchor.constraint(equalTo: lookupView.bottomAnchor, constant: 18),
            categorySectionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            categoryFieldContainer.topAnchor.constraint(equalTo: categorySectionLabel.bottomAnchor, constant: 10),
            categoryFieldContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryFieldContainer.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            categoryFieldContainer.heightAnchor.constraint(equalToConstant: 52),

            categoryButton.leadingAnchor.constraint(equalTo: categoryFieldContainer.leadingAnchor, constant: 14),
            categoryButton.trailingAnchor.constraint(equalTo: categoryChevronView.leadingAnchor, constant: -10),
            categoryButton.centerYAnchor.constraint(equalTo: categoryFieldContainer.centerYAnchor),

            categoryChevronView.trailingAnchor.constraint(equalTo: categoryFieldContainer.trailingAnchor, constant: -14),
            categoryChevronView.centerYAnchor.constraint(equalTo: categoryFieldContainer.centerYAnchor),
            categoryChevronView.widthAnchor.constraint(equalToConstant: 18),
            categoryChevronView.heightAnchor.constraint(equalToConstant: 18),

            noteSectionLabel.topAnchor.constraint(equalTo: categoryFieldContainer.bottomAnchor, constant: 18),
            noteSectionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            noteContainer.topAnchor.constraint(equalTo: noteSectionLabel.bottomAnchor, constant: 10),
            noteContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            noteContainer.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            noteContainer.heightAnchor.constraint(equalToConstant: 120),

            noteTextView.topAnchor.constraint(equalTo: noteContainer.topAnchor, constant: 12),
            noteTextView.leadingAnchor.constraint(equalTo: noteContainer.leadingAnchor, constant: 12),
            noteTextView.trailingAnchor.constraint(equalTo: noteContainer.trailingAnchor, constant: -12),
            noteTextView.bottomAnchor.constraint(equalTo: noteContainer.bottomAnchor, constant: -12),

            notePlaceholderLabel.topAnchor.constraint(equalTo: noteTextView.topAnchor, constant: 2),
            notePlaceholderLabel.leadingAnchor.constraint(equalTo: noteTextView.leadingAnchor, constant: 4),

            confirmButton.topAnchor.constraint(equalTo: noteContainer.bottomAnchor, constant: 20),
            confirmButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 54),
            confirmButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])

        lookupHeightConstraint = lookupView.heightAnchor.constraint(equalToConstant: 0)
        lookupHeightConstraint?.isActive = true
    }

    func applyContent() {
        titleLabel.text = "Para Gönder"
        subtitleLabel.text = "Göndermek istediğiniz kişiyi seçin ve tutarı belirleyin."
        amountSectionLabel.text = "İŞLEM TUTARI"
        amountCurrencyLabel.text = "₺"
        amountTitleLabel.text = "TUTAR"
        recipientsTitleLabel.text = "Alıcı Seç"
        allRecipientsButton.setTitle("Tümü", for: .normal)
        ibanSectionLabel.text = "Yeni Kullanıcı / IBAN"
        ibanTextField.placeholder = "TR..."
        categorySectionLabel.text = "Kategori"
        categoryButton.setTitle("Kategori Seç", for: .normal)
        noteSectionLabel.text = "İşlem Notu"
        notePlaceholderLabel.text = "İşlem notu ekleyin"
        confirmButton.setTitle("Onayla →", for: .normal)
    }

    func applyData(_ data: SendMoneyViewData) {
        balanceInfoLabel.text = "Kullanılabilir bakiye: \(data.balanceText)"
        amountTextField.text = data.amountText
        ibanTextField.text = data.enteredIBAN
        categoryButton.setTitle(data.selectedCategoryTitle, for: .normal)
        noteTextView.text = data.noteText
        notePlaceholderLabel.isHidden = !data.noteText.isEmpty
        amountErrorLabel.text = data.amountErrorMessage
        amountErrorLabel.isHidden = data.amountErrorMessage == nil
        lookupView.applyRecipient(data.lookupRecipient)
        lookupHeightConstraint?.constant = data.lookupRecipient == nil ? 0 : 56
        confirmButton.isEnabled = data.canConfirm
        confirmButton.alpha = data.canConfirm ? 1 : 0.55
        updateQuickAmounts(data.quickAmounts, selectedAmount: data.selectedAmount)
        updateRecipients(data.recipients, selectedRecipientID: data.selectedRecipientID)
    }

    func updateQuickAmounts(_ amounts: [Decimal], selectedAmount: Decimal) {
        amountChipButtons.forEach { $0.removeFromSuperview() }
        amountChipButtons = amounts.map { SendMoneyAmountChipButton(amount: $0) }
        amountChipButtons.forEach { chip in
            chip.applySelected(chip.amount == selectedAmount)
            amountChipsStack.addArrangedSubview(chip)
        }
    }

    func updateRecipients(_ recipients: [SendMoneyRecipient], selectedRecipientID: String?) {
        recipientViews.forEach { $0.removeFromSuperview() }
        recipientViews = recipients.map { recipient in
            let view = SendMoneyRecipientRowView(recipient: recipient)
            view.applySelected(recipient.id == selectedRecipientID)
            recipientsStack.addArrangedSubview(view)
            return view
        }
    }

    func setLoading(_ isLoading: Bool) {
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}
