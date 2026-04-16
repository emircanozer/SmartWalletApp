import UIKit

final class AIAssistantContentView: UIView {
    let tableView = UITableView(frame: .zero, style: .plain)
    let messageTextField = UITextField()
    let sendButton = UIButton(type: .system)

    private let topPanel = UIView()
    private let headerTitleLabel = UILabel()
    private let headerSubtitleLabel = UILabel()
    private let headerBadgeLabel = UILabel()
    private let inputContainer = UIView()
    private let inputShadowView = UIView()
    private let keyboardTapGesture = UITapGestureRecognizer()

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
        inputContainer.layer.cornerRadius = inputContainer.bounds.height / 2
        inputShadowView.layer.cornerRadius = inputShadowView.bounds.height / 2
        sendButton.layer.cornerRadius = sendButton.bounds.height / 2
    }
}

extension AIAssistantContentView {
    func apply(_ data: AIAssistantViewData) {
        headerTitleLabel.text = data.titleText
        headerSubtitleLabel.text = data.subtitleText
        messageTextField.placeholder = data.placeholderText
        if messageTextField.text != data.draftText {
            messageTextField.text = data.draftText
        }
        sendButton.setImage(UIImage(systemName: data.sendButtonImageName), for: .normal)
        sendButton.isEnabled = data.isSendEnabled
        sendButton.alpha = data.isSendEnabled ? 1 : 0.65
    }
}

 extension AIAssistantContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        keyboardTapGesture.addTarget(self, action: #selector(handleBackgroundTap))
        keyboardTapGesture.cancelsTouchesInView = false
        addGestureRecognizer(keyboardTapGesture)

        topPanel.backgroundColor = AppColor.whitePrimary
        topPanel.layer.cornerRadius = 28
        topPanel.layer.cornerCurve = .continuous
        topPanel.layer.shadowColor = UIColor.black.cgColor
        topPanel.layer.shadowOpacity = 0.04
        topPanel.layer.shadowRadius = 18
        topPanel.layer.shadowOffset = CGSize(width: 0, height: 10)

        headerTitleLabel.font = .systemFont(ofSize: 27, weight: .bold)
        headerTitleLabel.textColor = AppColor.primaryText

        headerSubtitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        headerSubtitleLabel.textColor = AppColor.secondaryText
        headerSubtitleLabel.textAlignment = .left
        headerSubtitleLabel.text = "Akıllı Finansal Asistan"

        headerBadgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        headerBadgeLabel.textColor = AppColor.warmActionText
        headerBadgeLabel.textAlignment = .center
        headerBadgeLabel.text = "SMARTWALLET AI"
        headerBadgeLabel.backgroundColor = AppColor.surfaceWarmSoft
        headerBadgeLabel.layer.cornerRadius = 12
        headerBadgeLabel.layer.cornerCurve = .continuous
        headerBadgeLabel.clipsToBounds = true

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .interactive
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 18, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120

        inputShadowView.backgroundColor = .clear
        inputShadowView.layer.shadowColor = UIColor.black.cgColor
        inputShadowView.layer.shadowOpacity = 0.07
        inputShadowView.layer.shadowRadius = 20
        inputShadowView.layer.shadowOffset = CGSize(width: 0, height: 10)

        inputContainer.backgroundColor = AppColor.whitePrimary
        inputContainer.layer.borderWidth = 1
        inputContainer.layer.borderColor = AppColor.borderSoft.cgColor
        inputContainer.layer.cornerCurve = .continuous

        messageTextField.font = .systemFont(ofSize: 16, weight: .medium)
        messageTextField.textColor = AppColor.primaryText
        messageTextField.tintColor = AppColor.primaryYellow
        messageTextField.borderStyle = .none
        messageTextField.returnKeyType = .send

        sendButton.backgroundColor = AppColor.primaryYellow
        sendButton.tintColor = AppColor.primaryText
    }

    func buildHierarchy() {
        addSubview(topPanel)
        topPanel.addSubview(headerBadgeLabel)
        topPanel.addSubview(headerTitleLabel)
        topPanel.addSubview(headerSubtitleLabel)
        addSubview(tableView)
        addSubview(inputShadowView)
        inputShadowView.addSubview(inputContainer)
        inputContainer.addSubview(messageTextField)
        inputContainer.addSubview(sendButton)
    }

    func setupLayout() {
        [
            topPanel,
            headerTitleLabel,
            headerSubtitleLabel,
            headerBadgeLabel,
            tableView,
            inputShadowView,
            inputContainer,
            messageTextField,
            sendButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let keyboardGuide = keyboardLayoutGuide
        keyboardGuide.followsUndockedKeyboard = true

        NSLayoutConstraint.activate([
            topPanel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            topPanel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            topPanel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            headerBadgeLabel.topAnchor.constraint(equalTo: topPanel.topAnchor, constant: 16),
            headerBadgeLabel.leadingAnchor.constraint(equalTo: topPanel.leadingAnchor, constant: 18),
            headerBadgeLabel.heightAnchor.constraint(equalToConstant: 24),
            headerBadgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 124),

            headerTitleLabel.topAnchor.constraint(equalTo: headerBadgeLabel.bottomAnchor, constant: 12),
            headerTitleLabel.leadingAnchor.constraint(equalTo: topPanel.leadingAnchor, constant: 18),
            headerTitleLabel.trailingAnchor.constraint(equalTo: topPanel.trailingAnchor, constant: -18),

            headerSubtitleLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 4),
            headerSubtitleLabel.leadingAnchor.constraint(equalTo: headerTitleLabel.leadingAnchor),
            headerSubtitleLabel.trailingAnchor.constraint(equalTo: headerTitleLabel.trailingAnchor),
            headerSubtitleLabel.bottomAnchor.constraint(equalTo: topPanel.bottomAnchor, constant: -18),

            inputShadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            inputShadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            inputShadowView.bottomAnchor.constraint(equalTo: keyboardGuide.topAnchor, constant: -10),

            inputContainer.topAnchor.constraint(equalTo: inputShadowView.topAnchor),
            inputContainer.leadingAnchor.constraint(equalTo: inputShadowView.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: inputShadowView.trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: inputShadowView.bottomAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 60),

            sendButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -8),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalToConstant: 44),

            messageTextField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 18),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            messageTextField.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),

            tableView.topAnchor.constraint(equalTo: topPanel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputShadowView.topAnchor, constant: -10)
        ])
    }

    @objc func handleBackgroundTap() {
        endEditing(true)
    }
}
