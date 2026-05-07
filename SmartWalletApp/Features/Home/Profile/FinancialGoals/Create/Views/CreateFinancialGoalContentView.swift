import UIKit

final class CreateFinancialGoalContentView: UIView {
    let backButton = UIButton(type: .system)
    let nameField = AuthInputFieldView(title: "", placeholder: "", iconName: "target")
    let amountField = AuthInputFieldView(title: "", placeholder: "", iconName: "turkishlirasign.circle")
    let approveButton = UIButton(type: .system)

    var onDateTap: (() -> Void)?

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let bottomActionContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let formCardView = UIView()

    private let nameTitleLabel = UILabel()
    private let amountTitleLabel = UILabel()
    private let deadlineTitleLabel = UILabel()

    private let deadlineFieldView = UIView()
    private let deadlinePlaceholderLabel = UILabel()
    private let deadlineValueLabel = UILabel()
    private let deadlineIconView = UIImageView()

    private var keyboardInset: CGFloat = 0

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
        formCardView.layer.cornerRadius = 22
        deadlineFieldView.layer.cornerRadius = 16
        approveButton.layer.cornerRadius = 18
        applyBottomInset()
    }
}

extension CreateFinancialGoalContentView {
    func apply(_ data: CreateFinancialGoalViewData) {
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText
        nameTitleLabel.text = data.nameTitleText
        amountTitleLabel.text = data.targetTitleText
        deadlineTitleLabel.text = data.deadlineTitleText

        nameField.setPlaceholder(data.namePlaceholderText)
        amountField.setPlaceholder(data.targetPlaceholderText)

        deadlinePlaceholderLabel.text = data.deadlinePlaceholderText
        approveButton.setTitle(data.approveButtonTitleText, for: .normal)
    }

    func applyFormState(_ state: CreateFinancialGoalFormState) {
        let hasDate = state.selectedDateText != nil

        deadlinePlaceholderLabel.isHidden = hasDate
        deadlineValueLabel.isHidden = !hasDate
        deadlineValueLabel.text = state.selectedDateText

        approveButton.isEnabled = state.isApproveEnabled
        approveButton.alpha = state.isApproveEnabled ? 1 : 0.6
        approveButton.setTitle(state.isSubmitting ? "Oluşturuluyor..." : "Hedefi Onayla", for: .normal)
    }

    func setKeyboardBottomInset(_ inset: CGFloat) {
        keyboardInset = inset
        applyBottomInset()
    }

    private func applyBottomInset() {
        let baseInset = bottomActionContainer.bounds.height + 24
        let finalInset = max(baseInset, keyboardInset + 16)

        scrollView.contentInset.bottom = finalInset
        scrollView.verticalScrollIndicatorInsets.bottom = finalInset
    }

    func scrollToVisible(_ view: UIView) {
        let rect = view.convert(view.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -24), animated: true)
    }
}

extension CreateFinancialGoalContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive

        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = AppColor.primaryText

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = AppColor.bodyText
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setLineSpacing(5)

        formCardView.backgroundColor = AppColor.whitePrimary
        formCardView.layer.shadowColor = UIColor.black.cgColor
        formCardView.layer.shadowOpacity = 0.03
        formCardView.layer.shadowRadius = 12
        formCardView.layer.shadowOffset = CGSize(width: 0, height: 6)

        [nameTitleLabel, amountTitleLabel, deadlineTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .bold)
            $0.textColor = AppColor.primaryText
        }

        amountField.setKeyboardType(.decimalPad)
        amountField.setTextContentType(.none)

        deadlineFieldView.backgroundColor = AppColor.whitePrimary
        deadlineFieldView.layer.borderWidth = 1
        deadlineFieldView.layer.borderColor = AppColor.borderSoft.cgColor

        deadlinePlaceholderLabel.font = .systemFont(ofSize: 16, weight: .medium)
        deadlinePlaceholderLabel.textColor = AppColor.placeholderText

        deadlineValueLabel.font = .systemFont(ofSize: 16, weight: .medium)
        deadlineValueLabel.textColor = AppColor.inputText
        deadlineValueLabel.isHidden = true

        deadlineIconView.image = UIImage(systemName: "calendar")
        deadlineIconView.tintColor = AppColor.navigationTint
        deadlineIconView.contentMode = .scaleAspectFit

        let deadlineTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDateTap))
        deadlineFieldView.addGestureRecognizer(deadlineTapGesture)
        deadlineFieldView.isUserInteractionEnabled = true

        bottomActionContainer.backgroundColor = AppColor.appBackground
        bottomActionContainer.layer.shadowColor = UIColor.black.cgColor
        bottomActionContainer.layer.shadowOpacity = 0.04
        bottomActionContainer.layer.shadowRadius = 10
        bottomActionContainer.layer.shadowOffset = CGSize(width: 0, height: -4)

        approveButton.backgroundColor = AppColor.primaryYellow
        approveButton.setTitleColor(AppColor.accentOlive, for: .normal)
        approveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        approveButton.isEnabled = false
        approveButton.alpha = 0.6
    }

    func buildHierarchy() {
        addSubview(scrollView)
        addSubview(bottomActionContainer)

        scrollView.addSubview(contentContainer)

        [backButton, titleLabel, subtitleLabel, formCardView].forEach {
            contentContainer.addSubview($0)
        }

        bottomActionContainer.addSubview(approveButton)

        [
            nameTitleLabel,
            nameField,
            amountTitleLabel,
            amountField,
            deadlineTitleLabel,
            deadlineFieldView
        ].forEach {
            formCardView.addSubview($0)
        }

        [deadlinePlaceholderLabel, deadlineValueLabel, deadlineIconView].forEach {
            deadlineFieldView.addSubview($0)
        }
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            bottomActionContainer,
            backButton,
            titleLabel,
            subtitleLabel,
            formCardView,
            nameTitleLabel,
            nameField,
            amountTitleLabel,
            amountField,
            deadlineTitleLabel,
            deadlineFieldView,
            deadlinePlaceholderLabel,
            deadlineValueLabel,
            deadlineIconView,
            approveButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomActionContainer.topAnchor),

            bottomActionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomActionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomActionContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

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
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            formCardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            formCardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            formCardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            formCardView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -24),

            nameTitleLabel.topAnchor.constraint(equalTo: formCardView.topAnchor, constant: 26),
            nameTitleLabel.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor, constant: 24),
            nameTitleLabel.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor, constant: -24),

            nameField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 10),
            nameField.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),
            nameField.heightAnchor.constraint(equalToConstant: 56),

            amountTitleLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            amountTitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            amountTitleLabel.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            amountField.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor, constant: 10),
            amountField.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            amountField.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),
            amountField.heightAnchor.constraint(equalToConstant: 56),

            deadlineTitleLabel.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 24),
            deadlineTitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            deadlineTitleLabel.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            deadlineFieldView.topAnchor.constraint(equalTo: deadlineTitleLabel.bottomAnchor, constant: 10),
            deadlineFieldView.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            deadlineFieldView.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),
            deadlineFieldView.heightAnchor.constraint(equalToConstant: 56),
            deadlineFieldView.bottomAnchor.constraint(equalTo: formCardView.bottomAnchor, constant: -26),

            deadlinePlaceholderLabel.centerYAnchor.constraint(equalTo: deadlineFieldView.centerYAnchor),
            deadlinePlaceholderLabel.leadingAnchor.constraint(equalTo: deadlineFieldView.leadingAnchor, constant: 22),

            deadlineValueLabel.centerYAnchor.constraint(equalTo: deadlineFieldView.centerYAnchor),
            deadlineValueLabel.leadingAnchor.constraint(equalTo: deadlinePlaceholderLabel.leadingAnchor),
            deadlineValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: deadlineIconView.leadingAnchor, constant: -12),

            deadlineIconView.centerYAnchor.constraint(equalTo: deadlineFieldView.centerYAnchor),
            deadlineIconView.trailingAnchor.constraint(equalTo: deadlineFieldView.trailingAnchor, constant: -18),
            deadlineIconView.widthAnchor.constraint(equalToConstant: 22),
            deadlineIconView.heightAnchor.constraint(equalToConstant: 22),

            approveButton.topAnchor.constraint(equalTo: bottomActionContainer.topAnchor, constant: 12),
            approveButton.leadingAnchor.constraint(equalTo: bottomActionContainer.leadingAnchor, constant: 16),
            approveButton.trailingAnchor.constraint(equalTo: bottomActionContainer.trailingAnchor, constant: -16),
            approveButton.bottomAnchor.constraint(equalTo: bottomActionContainer.bottomAnchor, constant: -12),
            approveButton.heightAnchor.constraint(equalToConstant: 68)
        ])
    }

    @objc func handleDateTap() {
        onDateTap?()
    }
}
