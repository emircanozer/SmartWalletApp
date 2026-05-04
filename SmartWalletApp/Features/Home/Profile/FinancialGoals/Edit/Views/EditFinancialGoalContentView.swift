import UIKit

final class EditFinancialGoalContentView: UIView {
    let backButton = UIButton(type: .system)
    let nameField = AuthInputFieldView(title: "", placeholder: "", iconName: "target")
    let amountField = AuthInputFieldView(title: "", placeholder: "", iconName: "turkishlirasign.circle")
    let saveButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    let deleteButton = UIButton(type: .system)
    let noteTextView = UITextView()

    var onDateTap: (() -> Void)?

    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let formCardView = UIView()
    private let nameTitleLabel = UILabel()
    private let amountTitleLabel = UILabel()
    private let dateTitleLabel = UILabel()
    private let dateFieldView = UIView()
    private let dateValueLabel = UILabel()
    private let dateIconView = UIImageView()
    private let noteTitleLabel = UILabel()
    private let noteContainerView = UIView()
    private let deleteDescriptionLabel = UILabel()
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
        formCardView.layer.cornerRadius = 24
        dateFieldView.layer.cornerRadius = 16
        noteContainerView.layer.cornerRadius = 16
        saveButton.layer.cornerRadius = 16
        cancelButton.layer.cornerRadius = 16
    }
}

extension EditFinancialGoalContentView {
    func apply(_ data: EditFinancialGoalViewData) {
        titleLabel.text = data.titleText
        nameTitleLabel.text = data.nameTitleText
        amountTitleLabel.text = data.amountTitleText
        dateTitleLabel.text = data.dateTitleText
        noteTitleLabel.text = data.noteTitleText
        saveButton.setTitle(data.saveButtonTitleText, for: .normal)
        cancelButton.setTitle(data.cancelButtonTitleText, for: .normal)
        deleteButton.setTitle(data.deleteButtonTitleText, for: .normal)
        deleteDescriptionLabel.text = data.deleteDescriptionText
        noteTextView.text = data.notePlaceholderText
        noteTextView.textColor = AppColor.placeholderText
    }

    func setInitialValues(name: String, amount: String, note: String) {
        nameField.setText(name)
        amountField.setText(amount)

        if note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }

        noteTextView.text = note
        noteTextView.textColor = AppColor.inputText
    }

    func applyFormState(_ state: EditFinancialGoalFormState) {
        dateValueLabel.text = state.selectedDateText
        saveButton.isEnabled = state.isSaveEnabled
        saveButton.alpha = state.isSaveEnabled ? 1 : 0.6
    }

    func setKeyboardBottomInset(_ inset: CGFloat) {
        keyboardInset = inset
        transform = inset > 0 ? CGAffineTransform(translationX: 0, y: -min(inset * 0.32, 110)) : .identity
    }
}

extension EditFinancialGoalContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = AppColor.primaryText

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        formCardView.backgroundColor = AppColor.whitePrimary
        formCardView.layer.shadowColor = UIColor.black.cgColor
        formCardView.layer.shadowOpacity = 0.03
        formCardView.layer.shadowRadius = 12
        formCardView.layer.shadowOffset = CGSize(width: 0, height: 6)

        [nameTitleLabel, amountTitleLabel, dateTitleLabel, noteTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .bold)
            $0.textColor = AppColor.primaryText
        }

        amountField.setKeyboardType(.decimalPad)

        dateFieldView.backgroundColor = AppColor.whitePrimary
        dateFieldView.layer.borderWidth = 1
        dateFieldView.layer.borderColor = AppColor.borderSoft.cgColor

        dateValueLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dateValueLabel.textColor = AppColor.inputText

        dateIconView.image = UIImage(systemName: "calendar")
        dateIconView.tintColor = AppColor.navigationTint
        dateIconView.contentMode = .scaleAspectFit

        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDateTap))
        dateFieldView.addGestureRecognizer(dateTapGesture)
        dateFieldView.isUserInteractionEnabled = true

        noteContainerView.backgroundColor = AppColor.whitePrimary
        noteContainerView.layer.borderWidth = 1
        noteContainerView.layer.borderColor = AppColor.borderSoft.cgColor

        noteTextView.backgroundColor = .clear
        noteTextView.font = .systemFont(ofSize: 16, weight: .medium)
        noteTextView.textColor = AppColor.placeholderText
        noteTextView.isScrollEnabled = false

        saveButton.backgroundColor = AppColor.primaryYellow
        saveButton.setTitleColor(AppColor.accentOlive, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        saveButton.isEnabled = false
        saveButton.alpha = 0.6

        cancelButton.backgroundColor = AppColor.whitePrimary
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = AppColor.resolvedCGColor(AppColor.borderSoft, for: traitCollection)
        cancelButton.setTitleColor(AppColor.primaryText, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.semanticContentAttribute = .forceLeftToRight
        deleteButton.contentHorizontalAlignment = .center
        deleteButton.configuration = .plain()
        deleteButton.configuration?.imagePadding = 6
        deleteButton.configuration?.contentInsets = .zero

        deleteDescriptionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        deleteDescriptionLabel.textColor = AppColor.bodyText
        deleteDescriptionLabel.textAlignment = .center
    }

    func buildHierarchy() {
        addSubview(contentContainer)

        [backButton, titleLabel, formCardView, saveButton, cancelButton, deleteButton, deleteDescriptionLabel].forEach(contentContainer.addSubview)
        [nameTitleLabel, nameField, amountTitleLabel, amountField, dateTitleLabel, dateFieldView, noteTitleLabel, noteContainerView].forEach(formCardView.addSubview)
        [dateValueLabel, dateIconView].forEach(dateFieldView.addSubview)
        noteContainerView.addSubview(noteTextView)
    }

    func setupLayout() {
        [
            contentContainer,
            backButton,
            titleLabel,
            formCardView,
            nameTitleLabel,
            nameField,
            amountTitleLabel,
            amountField,
            dateTitleLabel,
            dateFieldView,
            dateValueLabel,
            dateIconView,
            noteTitleLabel,
            noteContainerView,
            noteTextView,
            saveButton,
            cancelButton,
            deleteButton,
            deleteDescriptionLabel
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            formCardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            formCardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            formCardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),

            nameTitleLabel.topAnchor.constraint(equalTo: formCardView.topAnchor, constant: 22),
            nameTitleLabel.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor, constant: 20),
            nameTitleLabel.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor, constant: -20),

            nameField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            nameField.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            amountTitleLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 18),
            amountTitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            amountTitleLabel.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            amountField.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor, constant: 8),
            amountField.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            amountField.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            dateTitleLabel.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 18),
            dateTitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            dateTitleLabel.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            dateFieldView.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 8),
            dateFieldView.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            dateFieldView.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),
            dateFieldView.heightAnchor.constraint(equalToConstant: 56),

            dateValueLabel.centerYAnchor.constraint(equalTo: dateFieldView.centerYAnchor),
            dateValueLabel.leadingAnchor.constraint(equalTo: dateFieldView.leadingAnchor, constant: 18),
            dateValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateIconView.leadingAnchor, constant: -12),

            dateIconView.centerYAnchor.constraint(equalTo: dateFieldView.centerYAnchor),
            dateIconView.trailingAnchor.constraint(equalTo: dateFieldView.trailingAnchor, constant: -18),
            dateIconView.widthAnchor.constraint(equalToConstant: 22),
            dateIconView.heightAnchor.constraint(equalToConstant: 22),

            noteTitleLabel.topAnchor.constraint(equalTo: dateFieldView.bottomAnchor, constant: 18),
            noteTitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            noteTitleLabel.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),

            noteContainerView.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 8),
            noteContainerView.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            noteContainerView.trailingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor),
            noteContainerView.heightAnchor.constraint(equalToConstant: 88),
            noteContainerView.bottomAnchor.constraint(equalTo: formCardView.bottomAnchor, constant: -20),

            noteTextView.topAnchor.constraint(equalTo: noteContainerView.topAnchor, constant: 12),
            noteTextView.leadingAnchor.constraint(equalTo: noteContainerView.leadingAnchor, constant: 12),
            noteTextView.trailingAnchor.constraint(equalTo: noteContainerView.trailingAnchor, constant: -12),
            noteTextView.bottomAnchor.constraint(equalTo: noteContainerView.bottomAnchor, constant: -12),

            saveButton.topAnchor.constraint(equalTo: formCardView.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50),

            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 48),

            deleteButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 18),
            deleteButton.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),

            deleteDescriptionLabel.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 4),
            deleteDescriptionLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            deleteDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -12)
        ])
    }

    @objc func handleDateTap() {
        onDateTap?()
    }
}
