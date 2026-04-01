import UIKit

class AuthInputFieldView: UIView {
    private let titleRow = UIStackView()
    private let titleLabel = UILabel()
    private let topActionButton = UIButton(type: .system)
    private let containerView = UIView()
    private let contentStack = UIStackView()
    private let leadingImageView = UIImageView()
    private let textField = UITextField()
    private let trailingButton = UIButton(type: .system)
    private let helperLabel = UILabel()
    private let placeholderText: String

    init(
        title: String,
        placeholder: String,
        iconName: String,
        topActionTitle: String? = nil,
        trailingIconName: String? = nil,
        helperText: String? = nil,
        isSecure: Bool = false
    ) {
        self.placeholderText = placeholder
        super.init(frame: .zero)

        titleLabel.text = title
        topActionButton.setTitle(topActionTitle, for: .normal)
        helperLabel.text = helperText

        setupView(placeholder: placeholder, iconName: iconName, trailingIconName: trailingIconName, isSecure: isSecure)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var text: String {
        textField.text ?? ""
    }

    var trimmedText: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func setTopActionTarget(_ target: Any?, action: Selector) {
        topActionButton.addTarget(target, action: action, for: .touchUpInside)
    }

    func setTrailingTarget(_ target: Any?, action: Selector) {
        trailingButton.addTarget(target, action: action, for: .touchUpInside)
    }

    func toggleSecureEntry() {
        textField.isSecureTextEntry.toggle()
    }

    func setKeyboardType(_ keyboardType: UIKeyboardType) {
        textField.keyboardType = keyboardType
    }

    func setTextContentType(_ textContentType: UITextContentType?) {
        textField.textContentType = textContentType
    }

    func setAutocapitalizationType(_ type: UITextAutocapitalizationType) {
        textField.autocapitalizationType = type
    }

    func setText(_ text: String) {
        textField.text = text
    }

    private func setupView(placeholder: String, iconName: String, trailingIconName: String?, isSecure: Bool) {
        titleRow.axis = .horizontal
        titleRow.alignment = .center
        titleRow.distribution = .equalSpacing

        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.39, green: 0.41, blue: 0.48, alpha: 1.0)

        topActionButton.setTitleColor(UIColor(red: 0.98, green: 0.78, blue: 0.0, alpha: 1.0), for: .normal)
        topActionButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        topActionButton.isHidden = topActionButton.title(for: .normal) == nil

        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 0.91, green: 0.92, blue: 0.95, alpha: 1.0).cgColor
        containerView.layer.cornerRadius = 12

        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 10

        leadingImageView.image = UIImage(systemName: iconName)
        leadingImageView.tintColor = UIColor(red: 0.72, green: 0.75, blue: 0.8, alpha: 1.0)
        leadingImageView.contentMode = .scaleAspectFit

        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.textColor = UIColor(red: 0.28, green: 0.31, blue: 0.38, alpha: 1.0)
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: UIColor(red: 0.65, green: 0.69, blue: 0.76, alpha: 1.0),
                .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ]
        )

        trailingButton.tintColor = UIColor(red: 0.72, green: 0.75, blue: 0.8, alpha: 1.0)
        trailingButton.setImage(trailingIconName == nil ? nil : UIImage(systemName: trailingIconName!), for: .normal)
        trailingButton.isHidden = trailingIconName == nil

        helperLabel.font = .systemFont(ofSize: 12, weight: .medium)
        helperLabel.textColor = UIColor(red: 0.73, green: 0.75, blue: 0.8, alpha: 1.0)
        helperLabel.numberOfLines = 0
        helperLabel.isHidden = helperLabel.text == nil
    }

    private func setupLayout() {
        [titleRow, containerView, contentStack, leadingImageView, textField, trailingButton, helperLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(titleRow)
        addSubview(containerView)
        addSubview(helperLabel)

        titleRow.addArrangedSubview(titleLabel)
        titleRow.addArrangedSubview(topActionButton)

        containerView.addSubview(contentStack)

        contentStack.addArrangedSubview(leadingImageView)
        contentStack.addArrangedSubview(textField)
        contentStack.addArrangedSubview(trailingButton)

        NSLayoutConstraint.activate([
            titleRow.topAnchor.constraint(equalTo: topAnchor),
            titleRow.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleRow.trailingAnchor.constraint(equalTo: trailingAnchor),

            containerView.topAnchor.constraint(equalTo: titleRow.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 52),

            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -14),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            leadingImageView.widthAnchor.constraint(equalToConstant: 18),
            leadingImageView.heightAnchor.constraint(equalToConstant: 18),

            trailingButton.widthAnchor.constraint(equalToConstant: 22),
            trailingButton.heightAnchor.constraint(equalToConstant: 22),

            helperLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            helperLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            helperLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            helperLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
