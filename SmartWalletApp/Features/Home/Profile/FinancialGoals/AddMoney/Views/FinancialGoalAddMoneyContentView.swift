import UIKit

final class FinancialGoalAddMoneyContentView: UIView {
    let backButton = UIButton(type: .system)
    let amountField = UITextField()
    let noteTextView = UITextView()
    let confirmButton = UIButton(type: .system)

    var onQuickAmountTap: ((Decimal) -> Void)?

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let bottomActionContainer = UIView()
    private let titleLabel = UILabel()
    private let summaryCardView = UIView()
    private let goalTitleLabel = UILabel()
    private let deadlineLabel = UILabel()
    private let badgeLabel = UILabel()
    private let savedTitleLabel = UILabel()
    private let savedAmountLabel = UILabel()
    private let targetAmountLabel = UILabel()
    private let remainingTitleLabel = UILabel()
    private let remainingAmountLabel = UILabel()
    private let progressTrackView = UIView()
    private let progressFillView = UIView()
    private let progressLabel = UILabel()
    private let amountTitleLabel = UILabel()
    private let amountFieldContainerView = UIView()
    private let quickAmountGrid = UIStackView()
    private let infoLabel = UILabel()
    private let noteTitleLabel = UILabel()
    private let noteContainerView = UIView()
    private let projectedSavingsLabel = UILabel()
    private let remainingAfterAddLabel = UILabel()
    private var progressWidthConstraint: NSLayoutConstraint?
    private var quickAmountButtons: [QuickAmountButton] = []
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
        [summaryCardView, amountFieldContainerView, noteContainerView, confirmButton].forEach {
            $0.layer.cornerRadius = 20
        }
        badgeLabel.layer.cornerRadius = badgeLabel.bounds.height / 2
        progressTrackView.layer.cornerRadius = progressTrackView.bounds.height / 2
        progressFillView.layer.cornerRadius = progressFillView.bounds.height / 2
        applyBottomInset()
    }
}

extension FinancialGoalAddMoneyContentView {
    func apply(_ data: FinancialGoalAddMoneyViewData) {
        titleLabel.text = data.navigationTitleText
        goalTitleLabel.text = data.goalTitleText
        deadlineLabel.text = data.deadlineText
        badgeLabel.text = data.badgeText
        savedTitleLabel.text = data.savedTitleText
        savedAmountLabel.text = data.savedAmountText
        targetAmountLabel.text = data.targetAmountText
        remainingTitleLabel.text = data.remainingTitleText
        remainingAmountLabel.text = data.remainingAmountText
        progressLabel.text = data.progressText
        amountTitleLabel.text = data.amountFieldTitleText
        amountField.attributedPlaceholder = NSAttributedString(
            string: data.amountPlaceholderText,
            attributes: [
                .foregroundColor: AppColor.placeholderText,
                .font: UIFont.systemFont(ofSize: 22, weight: .bold)
            ]
        )
        noteTitleLabel.text = data.noteTitleText
        noteTextView.text = data.notePlaceholderText
        noteTextView.textColor = AppColor.placeholderText
        infoLabel.text = data.infoText

        quickAmountGrid.arrangedSubviews.forEach {
            quickAmountGrid.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        quickAmountButtons.removeAll()

        stride(from: 0, to: data.quickAmounts.count, by: 2).forEach { index in
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 10
            rowStack.distribution = .fillEqually

            let firstButton = makeQuickAmountButton(with: data.quickAmounts[index])
            rowStack.addArrangedSubview(firstButton)
            quickAmountButtons.append(firstButton)

            if index + 1 < data.quickAmounts.count {
                let secondButton = makeQuickAmountButton(with: data.quickAmounts[index + 1])
                rowStack.addArrangedSubview(secondButton)
                quickAmountButtons.append(secondButton)
            } else {
                rowStack.addArrangedSubview(UIView())
            }

            quickAmountGrid.addArrangedSubview(rowStack)
        }

        progressWidthConstraint?.isActive = false
        progressWidthConstraint = progressFillView.widthAnchor.constraint(equalTo: progressTrackView.widthAnchor, multiplier: max(0.06, min(data.progress, 1)))
        progressWidthConstraint?.isActive = true
        setNeedsLayout()
    }

    func applyFormState(_ state: FinancialGoalAddMoneyFormState) {
        if amountField.text != state.amountText {
            amountField.text = state.amountText
        }
        projectedSavingsLabel.text = state.projectedSavingsText
        remainingAfterAddLabel.text = state.remainingAfterAddText
        confirmButton.setTitle(state.isSubmitting ? "Aktariliyor..." : state.confirmButtonTitleText, for: .normal)
        confirmButton.isEnabled = state.isConfirmEnabled
        confirmButton.alpha = state.isConfirmEnabled ? 1 : 0.6
        quickAmountButtons.forEach {
            $0.isSelectedAmount = $0.amount == state.selectedQuickAmount
        }
        amountField.isEnabled = !state.isSubmitting
        noteTextView.isEditable = !state.isSubmitting
    }

    func setKeyboardBottomInset(_ inset: CGFloat) {
        keyboardInset = inset
        applyBottomInset()
    }

    func scrollToVisible(_ view: UIView) {
        let rect = view.convert(view.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -24), animated: true)
    }
}

 extension FinancialGoalAddMoneyContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive

        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = AppColor.accentOlive

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        summaryCardView.backgroundColor = AppColor.whitePrimary
        summaryCardView.layer.shadowColor = UIColor.black.cgColor
        summaryCardView.layer.shadowOpacity = 0.03
        summaryCardView.layer.shadowRadius = 12
        summaryCardView.layer.shadowOffset = CGSize(width: 0, height: 6)

        goalTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        goalTitleLabel.textColor = AppColor.primaryText

        deadlineLabel.font = .systemFont(ofSize: 14, weight: .medium)
        deadlineLabel.textColor = AppColor.secondaryText

        badgeLabel.backgroundColor = AppColor.surfaceWarmSoft
        badgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textColor = AppColor.accentOlive
        badgeLabel.textAlignment = .center

        [savedTitleLabel, remainingTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 10, weight: .bold)
            $0.textColor = AppColor.secondaryText
        }

        savedAmountLabel.font = .systemFont(ofSize: 28, weight: .bold)
        savedAmountLabel.textColor = AppColor.primaryText

        targetAmountLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        targetAmountLabel.textColor = AppColor.secondaryText

        remainingAmountLabel.font = .systemFont(ofSize: 16, weight: .bold)
        remainingAmountLabel.textColor = AppColor.accentOlive
        remainingAmountLabel.numberOfLines = 2
        remainingAmountLabel.textAlignment = .right

        progressTrackView.backgroundColor = AppColor.divider
        progressFillView.backgroundColor = AppColor.primaryYellow

        progressLabel.font = .systemFont(ofSize: 13, weight: .bold)
        progressLabel.textColor = AppColor.accentOlive
        progressLabel.textAlignment = .center

        amountTitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        amountTitleLabel.textColor = AppColor.fieldTitleText

        amountFieldContainerView.backgroundColor = AppColor.whitePrimary
        amountFieldContainerView.layer.borderWidth = 1
        amountFieldContainerView.layer.borderColor = AppColor.resolvedCGColor(AppColor.borderSoft, for: traitCollection)

        amountField.font = .systemFont(ofSize: 22, weight: .bold)
        amountField.textColor = AppColor.placeholderText
        amountField.textAlignment = .center
        amountField.keyboardType = .decimalPad

        quickAmountGrid.axis = .vertical
        quickAmountGrid.spacing = 10

        infoLabel.font = .systemFont(ofSize: 12, weight: .medium)
        infoLabel.textColor = AppColor.secondaryText

        noteTitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        noteTitleLabel.textColor = AppColor.fieldTitleText

        noteContainerView.backgroundColor = AppColor.whitePrimary
        noteContainerView.layer.borderWidth = 1
        noteContainerView.layer.borderColor = AppColor.resolvedCGColor(AppColor.borderSoft, for: traitCollection)

        noteTextView.backgroundColor = .clear
        noteTextView.font = .systemFont(ofSize: 15, weight: .medium)
        noteTextView.textColor = AppColor.placeholderText
        noteTextView.isScrollEnabled = false

        projectedSavingsLabel.font = .systemFont(ofSize: 15, weight: .medium)
        projectedSavingsLabel.textColor = AppColor.bodyText
        projectedSavingsLabel.textAlignment = .center

        remainingAfterAddLabel.font = .systemFont(ofSize: 15, weight: .medium)
        remainingAfterAddLabel.textColor = AppColor.bodyText
        remainingAfterAddLabel.textAlignment = .center

        bottomActionContainer.backgroundColor = AppColor.appBackground
        bottomActionContainer.layer.shadowColor = UIColor.black.cgColor
        bottomActionContainer.layer.shadowOpacity = 0.04
        bottomActionContainer.layer.shadowRadius = 10
        bottomActionContainer.layer.shadowOffset = CGSize(width: 0, height: -4)

        confirmButton.backgroundColor = AppColor.primaryYellow
        confirmButton.setTitleColor(AppColor.authHeadingText, for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.6
    }

    func buildHierarchy() {
        addSubview(scrollView)
        addSubview(bottomActionContainer)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            titleLabel,
            summaryCardView,
            amountTitleLabel,
            amountFieldContainerView,
            quickAmountGrid,
            infoLabel,
            noteTitleLabel,
            noteContainerView,
            projectedSavingsLabel,
            remainingAfterAddLabel
        ].forEach(contentContainer.addSubview)
            bottomActionContainer.addSubview(confirmButton)

        [
            goalTitleLabel,
            deadlineLabel,
            badgeLabel,
            savedTitleLabel,
            savedAmountLabel,
            targetAmountLabel,
            remainingTitleLabel,
            remainingAmountLabel,
            progressTrackView,
            progressLabel
        ].forEach(summaryCardView.addSubview)
        progressTrackView.addSubview(progressFillView)
        amountFieldContainerView.addSubview(amountField)
        noteContainerView.addSubview(noteTextView)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            bottomActionContainer,
            backButton,
            titleLabel,
            summaryCardView,
            goalTitleLabel,
            deadlineLabel,
            badgeLabel,
            savedTitleLabel,
            savedAmountLabel,
            targetAmountLabel,
            remainingTitleLabel,
            remainingAmountLabel,
            progressTrackView,
            progressFillView,
            progressLabel,
            amountTitleLabel,
            amountFieldContainerView,
            amountField,
            quickAmountGrid,
            infoLabel,
            noteTitleLabel,
            noteContainerView,
            noteTextView,
            projectedSavingsLabel,
            remainingAfterAddLabel,
            confirmButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

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
            titleLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),

            summaryCardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28),
            summaryCardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            summaryCardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            goalTitleLabel.topAnchor.constraint(equalTo: summaryCardView.topAnchor, constant: 18),
            goalTitleLabel.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor, constant: 16),
            goalTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: badgeLabel.leadingAnchor, constant: -12),

            badgeLabel.topAnchor.constraint(equalTo: summaryCardView.topAnchor, constant: 16),
            badgeLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor, constant: -16),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            badgeLabel.heightAnchor.constraint(equalToConstant: 24),

            deadlineLabel.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 4),
            deadlineLabel.leadingAnchor.constraint(equalTo: goalTitleLabel.leadingAnchor),
            deadlineLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor, constant: -16),

            savedTitleLabel.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor, constant: 18),
            savedTitleLabel.leadingAnchor.constraint(equalTo: goalTitleLabel.leadingAnchor),

            remainingTitleLabel.centerYAnchor.constraint(equalTo: savedTitleLabel.centerYAnchor),
            remainingTitleLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor, constant: -16),

            savedAmountLabel.topAnchor.constraint(equalTo: savedTitleLabel.bottomAnchor, constant: 6),
            savedAmountLabel.leadingAnchor.constraint(equalTo: savedTitleLabel.leadingAnchor),

            targetAmountLabel.lastBaselineAnchor.constraint(equalTo: savedAmountLabel.lastBaselineAnchor),
            targetAmountLabel.leadingAnchor.constraint(equalTo: savedAmountLabel.trailingAnchor, constant: 8),
            targetAmountLabel.trailingAnchor.constraint(lessThanOrEqualTo: remainingAmountLabel.leadingAnchor, constant: -12),

            remainingAmountLabel.topAnchor.constraint(equalTo: remainingTitleLabel.bottomAnchor, constant: 6),
            remainingAmountLabel.trailingAnchor.constraint(equalTo: remainingTitleLabel.trailingAnchor),
            remainingAmountLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 110),

            progressTrackView.topAnchor.constraint(equalTo: savedAmountLabel.bottomAnchor, constant: 14),
            progressTrackView.leadingAnchor.constraint(equalTo: savedAmountLabel.leadingAnchor),
            progressTrackView.trailingAnchor.constraint(equalTo: remainingAmountLabel.trailingAnchor),
            progressTrackView.heightAnchor.constraint(equalToConstant: 10),

            progressFillView.topAnchor.constraint(equalTo: progressTrackView.topAnchor),
            progressFillView.leadingAnchor.constraint(equalTo: progressTrackView.leadingAnchor),
            progressFillView.bottomAnchor.constraint(equalTo: progressTrackView.bottomAnchor),

            progressLabel.topAnchor.constraint(equalTo: progressTrackView.bottomAnchor, constant: 12),
            progressLabel.centerXAnchor.constraint(equalTo: summaryCardView.centerXAnchor),
            progressLabel.bottomAnchor.constraint(equalTo: summaryCardView.bottomAnchor, constant: -18),

            amountTitleLabel.topAnchor.constraint(equalTo: summaryCardView.bottomAnchor, constant: 22),
            amountTitleLabel.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),

            amountFieldContainerView.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor, constant: 10),
            amountFieldContainerView.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            amountFieldContainerView.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),
            amountFieldContainerView.heightAnchor.constraint(equalToConstant: 58),

            amountField.centerXAnchor.constraint(equalTo: amountFieldContainerView.centerXAnchor),
            amountField.centerYAnchor.constraint(equalTo: amountFieldContainerView.centerYAnchor),
            amountField.leadingAnchor.constraint(equalTo: amountFieldContainerView.leadingAnchor, constant: 16),
            amountField.trailingAnchor.constraint(equalTo: amountFieldContainerView.trailingAnchor, constant: -16),

            quickAmountGrid.topAnchor.constraint(equalTo: amountFieldContainerView.bottomAnchor, constant: 16),
            quickAmountGrid.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            quickAmountGrid.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),

            infoLabel.topAnchor.constraint(equalTo: quickAmountGrid.bottomAnchor, constant: 14),
            infoLabel.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),

            noteTitleLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 18),
            noteTitleLabel.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),

            noteContainerView.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 10),
            noteContainerView.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            noteContainerView.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),
            noteContainerView.heightAnchor.constraint(equalToConstant: 76),

            noteTextView.topAnchor.constraint(equalTo: noteContainerView.topAnchor, constant: 10),
            noteTextView.leadingAnchor.constraint(equalTo: noteContainerView.leadingAnchor, constant: 12),
            noteTextView.trailingAnchor.constraint(equalTo: noteContainerView.trailingAnchor, constant: -12),
            noteTextView.bottomAnchor.constraint(equalTo: noteContainerView.bottomAnchor, constant: -10),

            projectedSavingsLabel.topAnchor.constraint(equalTo: noteContainerView.bottomAnchor, constant: 28),
            projectedSavingsLabel.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            projectedSavingsLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),

            remainingAfterAddLabel.topAnchor.constraint(equalTo: projectedSavingsLabel.bottomAnchor, constant: 14),
            remainingAfterAddLabel.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            remainingAfterAddLabel.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),
            remainingAfterAddLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -32),

            confirmButton.topAnchor.constraint(equalTo: bottomActionContainer.topAnchor, constant: 12),
            confirmButton.leadingAnchor.constraint(equalTo: bottomActionContainer.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: bottomActionContainer.trailingAnchor, constant: -16),
            confirmButton.bottomAnchor.constraint(equalTo: bottomActionContainer.bottomAnchor, constant: -12),
            confirmButton.heightAnchor.constraint(equalToConstant: 52)
        ])

        progressWidthConstraint = progressFillView.widthAnchor.constraint(equalToConstant: 28)
        progressWidthConstraint?.isActive = true
    }

    func applyBottomInset() {
        let baseInset = bottomActionContainer.bounds.height + 24
        scrollView.contentInset.bottom = max(baseInset, keyboardInset + 16)
        scrollView.verticalScrollIndicatorInsets.bottom = max(baseInset, keyboardInset + 16)
    }

    func clearAmountPlaceholder() {
        guard amountField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true else { return }
        amountField.attributedPlaceholder = nil
        amountField.placeholder = ""
    }

    func restoreAmountPlaceholder(_ text: String) {
        amountField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: AppColor.placeholderText,
                .font: UIFont.systemFont(ofSize: 22, weight: .bold)
            ]
        )
    }

    func makeQuickAmountButton(with item: FinancialGoalAddMoneyQuickAmountViewData) -> QuickAmountButton {
        let button = QuickAmountButton(amount: item.amount)
        button.setTitle(item.titleText, for: .normal)
        button.addTarget(self, action: #selector(handleQuickAmountTap(_:)), for: .touchUpInside)
        return button
    }

    @objc func handleQuickAmountTap(_ sender: QuickAmountButton) {
        onQuickAmountTap?(sender.amount)
    }
}

final class QuickAmountButton: UIButton {
    let amount: Decimal

    var isSelectedAmount = false {
        didSet {
            updateAppearance()
        }
    }

    init(amount: Decimal) {
        self.amount = amount
        super.init(frame: .zero)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        layer.cornerRadius = 16
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateAppearance() {
        backgroundColor = isSelectedAmount ? AppColor.primaryYellow : AppColor.surfaceMuted
        setTitleColor(isSelectedAmount ? AppColor.authHeadingText : AppColor.primaryText, for: .normal)
    }
}
