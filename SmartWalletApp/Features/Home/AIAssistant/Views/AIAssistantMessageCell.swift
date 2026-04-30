import UIKit

protocol AIAssistantMessageCellDelegate: AnyObject {
    func aiAssistantMessageCellDidTapAccept(_ cell: AIAssistantMessageCell)
    func aiAssistantMessageCellDidTapDecline(_ cell: AIAssistantMessageCell)
}

final class AIAssistantMessageCell: UITableViewCell {
    weak var delegate: AIAssistantMessageCellDelegate?

    private let rowStack = UIStackView()
    private let avatarView = UIView()
    private let avatarIconView = UIImageView()
    private let bubbleContainer = UIView()
    private let bubbleStack = UIStackView()
    private let messageLabel = UILabel()
    private let actionsStack = UIStackView()
    private let acceptButton = UIButton(type: .system)
    private let declineButton = UIButton(type: .system)
    private let statusBadgeLabel = UILabel()
    private let timestampLabel = UILabel()
    private let typingIndicatorView = AIAssistantTypingIndicatorView()

    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var timestampLeadingConstraint: NSLayoutConstraint!
    private var timestampTrailingConstraint: NSLayoutConstraint!

    private var assistantMaxWidthConstraint: NSLayoutConstraint!
    private var userMaxWidthConstraint: NSLayoutConstraint!
    private var assistantTypingWidthConstraint: NSLayoutConstraint!
    private var dynamicBubbleWidthConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        delegate = nil
        typingIndicatorView.stopAnimating()

        dynamicBubbleWidthConstraint?.isActive = false
        dynamicBubbleWidthConstraint = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        avatarView.layer.cornerRadius = avatarView.bounds.width / 2
        bubbleContainer.layer.cornerRadius = 20
        bubbleContainer.layer.cornerCurve = .continuous
        acceptButton.layer.cornerRadius = acceptButton.bounds.height / 2
        declineButton.layer.cornerRadius = declineButton.bounds.height / 2
        statusBadgeLabel.layer.cornerRadius = statusBadgeLabel.bounds.height / 2
    }
}

extension AIAssistantMessageCell {
    func configure(with item: AIAssistantMessageItem) {
        messageLabel.text = item.text
        timestampLabel.text = item.timestampText

        let isAssistant = item.sender == .assistant
        let isTyping = item.kind == .typing

        dynamicBubbleWidthConstraint?.isActive = false
        dynamicBubbleWidthConstraint = nil

        avatarView.isHidden = !isAssistant
        rowStack.alignment = isAssistant ? .leading : .trailing

        leadingConstraint.isActive = isAssistant
        trailingConstraint.isActive = !isAssistant

        timestampLeadingConstraint.isActive = isAssistant
        timestampTrailingConstraint.isActive = !isAssistant

        assistantMaxWidthConstraint.isActive = isAssistant && !isTyping
        userMaxWidthConstraint.isActive = !isAssistant
        assistantTypingWidthConstraint.isActive = isAssistant && isTyping

        bubbleContainer.backgroundColor = isAssistant ? AppColor.whitePrimary : AppColor.warmHighlight
        bubbleContainer.layer.shadowOpacity = isAssistant ? 0.06 : 0.02
        bubbleContainer.layer.shadowRadius = isAssistant ? 16 : 10
        bubbleContainer.layer.shadowOffset = CGSize(width: 0, height: 8)
        bubbleContainer.layer.shadowColor = UIColor.black.cgColor

        messageLabel.textColor = AppColor.primaryText
        messageLabel.isHidden = isTyping
        typingIndicatorView.isHidden = !isTyping

        if isTyping {
            typingIndicatorView.startAnimating()
        } else {
            typingIndicatorView.stopAnimating()
            updateBubbleWidth(for: item, isAssistant: isAssistant)
        }

        if let action = item.action {
            bubbleStack.spacing = 14

            switch action.state {
            case .pending:
                actionsStack.isHidden = false
                statusBadgeLabel.isHidden = true
                acceptButton.setTitle(action.titleText, for: .normal)
                declineButton.setTitle(action.secondaryTitleText, for: .normal)

            case .accepted:
                actionsStack.isHidden = true
                statusBadgeLabel.isHidden = false
                statusBadgeLabel.text = "Yönlendirildi"

            case .declined:
                actionsStack.isHidden = true
                statusBadgeLabel.isHidden = false
                statusBadgeLabel.text = "İptal Edildi"
            }
        } else {
            actionsStack.isHidden = true
            statusBadgeLabel.isHidden = true
            bubbleStack.spacing = 0
        }
    }

    private func updateBubbleWidth(for item: AIAssistantMessageItem, isAssistant: Bool) {
        let screenWidth = UIScreen.main.bounds.width

        let maxBubbleWidth: CGFloat = screenWidth * 0.84
        let minBubbleWidth: CGFloat = isAssistant ? 180 : 44
        let horizontalPadding: CGFloat = 48

        let rawTextWidth = (item.text as NSString).size(
            withAttributes: [
                .font: messageLabel.font as Any
            ]
        ).width

        let targetWidth = min(max(rawTextWidth + horizontalPadding, minBubbleWidth), maxBubbleWidth)

        dynamicBubbleWidthConstraint = bubbleContainer.widthAnchor.constraint(equalToConstant: targetWidth)
        dynamicBubbleWidthConstraint?.priority = .required
        dynamicBubbleWidthConstraint?.isActive = true
    }
}

extension AIAssistantMessageCell {
    func configureView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        rowStack.axis = .horizontal
        rowStack.alignment = .bottom
        rowStack.spacing = 10
        rowStack.distribution = .fill

        avatarView.backgroundColor = AppColor.surfaceWarmSoft

        avatarIconView.image = UIImage(systemName: "apple.intelligence")
        avatarIconView.tintColor = AppColor.warmActionText
        avatarIconView.contentMode = .scaleAspectFit

        bubbleStack.axis = .vertical
        bubbleStack.spacing = 0

        messageLabel.font = .systemFont(ofSize: 17, weight: .medium)
        messageLabel.textColor = AppColor.primaryText
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byCharWrapping

        messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        messageLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        messageLabel.setContentHuggingPriority(.required, for: .horizontal)

        actionsStack.axis = .horizontal
        actionsStack.spacing = 10
        actionsStack.distribution = .fillEqually
        actionsStack.isHidden = true

        configureButton(acceptButton, backgroundColor: AppColor.accentOlive, titleColor: AppColor.whitePrimary)
        configureButton(declineButton, backgroundColor: AppColor.surfaceWarmSoft, titleColor: AppColor.warmActionText)

        statusBadgeLabel.font = .systemFont(ofSize: 13, weight: .bold)
        statusBadgeLabel.textColor = AppColor.warmActionText
        statusBadgeLabel.backgroundColor = AppColor.surfaceWarmSoft
        statusBadgeLabel.textAlignment = .center
        statusBadgeLabel.clipsToBounds = true
        statusBadgeLabel.isHidden = true

        timestampLabel.font = .systemFont(ofSize: 12, weight: .medium)
        timestampLabel.textColor = AppColor.secondaryText
        timestampLabel.textAlignment = .left

        bubbleContainer.setContentCompressionResistancePriority(.required, for: .vertical)
        bubbleContainer.setContentCompressionResistancePriority(.required, for: .horizontal)
        bubbleContainer.setContentHuggingPriority(.required, for: .horizontal)
    }

    func configureButton(_ button: UIButton, backgroundColor: UIColor, titleColor: UIColor) {
        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    func buildHierarchy() {
        contentView.addSubview(rowStack)

        rowStack.addArrangedSubview(avatarView)
        rowStack.addArrangedSubview(bubbleContainer)

        avatarView.addSubview(avatarIconView)
        bubbleContainer.addSubview(bubbleStack)

        [
            messageLabel,
            typingIndicatorView,
            actionsStack,
            statusBadgeLabel
        ].forEach {
            bubbleStack.addArrangedSubview($0)
        }

        actionsStack.addArrangedSubview(acceptButton)
        actionsStack.addArrangedSubview(declineButton)

        contentView.addSubview(timestampLabel)

        acceptButton.addTarget(self, action: #selector(handleAcceptTap), for: .touchUpInside)
        declineButton.addTarget(self, action: #selector(handleDeclineTap), for: .touchUpInside)
    }

    func setupLayout() {
        [
            rowStack,
            avatarView,
            avatarIconView,
            bubbleContainer,
            bubbleStack,
            timestampLabel,
            typingIndicatorView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        leadingConstraint = rowStack.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 20
        )

        trailingConstraint = rowStack.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -20
        )

        timestampLeadingConstraint = timestampLabel.leadingAnchor.constraint(
            equalTo: bubbleContainer.leadingAnchor,
            constant: 4
        )

        timestampTrailingConstraint = timestampLabel.trailingAnchor.constraint(
            equalTo: bubbleContainer.trailingAnchor,
            constant: -4
        )

        assistantMaxWidthConstraint = bubbleContainer.widthAnchor.constraint(
            lessThanOrEqualTo: contentView.widthAnchor,
            multiplier: 0.84
        )

        userMaxWidthConstraint = bubbleContainer.widthAnchor.constraint(
            lessThanOrEqualTo: contentView.widthAnchor,
            multiplier: 0.84
        )

        assistantTypingWidthConstraint = bubbleContainer.widthAnchor.constraint(
            equalToConstant: 96
        )

        NSLayoutConstraint.activate([
            rowStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            rowStack.leadingAnchor.constraint(
                greaterThanOrEqualTo: contentView.leadingAnchor,
                constant: 20
            ),

            rowStack.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -20
            ),

            avatarView.widthAnchor.constraint(equalToConstant: 28),
            avatarView.heightAnchor.constraint(equalToConstant: 28),

            avatarIconView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarIconView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            avatarIconView.widthAnchor.constraint(equalToConstant: 14),
            avatarIconView.heightAnchor.constraint(equalToConstant: 14),

            bubbleStack.topAnchor.constraint(equalTo: bubbleContainer.topAnchor, constant: 16),
            bubbleStack.leadingAnchor.constraint(equalTo: bubbleContainer.leadingAnchor, constant: 16),
            bubbleStack.trailingAnchor.constraint(equalTo: bubbleContainer.trailingAnchor, constant: -16),
            bubbleStack.bottomAnchor.constraint(equalTo: bubbleContainer.bottomAnchor, constant: -16),

            typingIndicatorView.heightAnchor.constraint(equalToConstant: 20),
            typingIndicatorView.widthAnchor.constraint(equalToConstant: 44),

            statusBadgeLabel.heightAnchor.constraint(equalToConstant: 32),

            timestampLabel.topAnchor.constraint(equalTo: rowStack.bottomAnchor, constant: 6),
            timestampLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    @objc func handleAcceptTap() {
        delegate?.aiAssistantMessageCellDidTapAccept(self)
    }

    @objc func handleDeclineTap() {
        delegate?.aiAssistantMessageCellDidTapDecline(self)
    }
}

private final class AIAssistantTypingIndicatorView: UIView {
    private let dotsStack = UIStackView()
    private let dots = [UIView(), UIView(), UIView()]

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

        dots.forEach {
            $0.layer.cornerRadius = $0.bounds.width / 2
        }
    }
}

extension AIAssistantTypingIndicatorView {
    func configureView() {
        dotsStack.axis = .horizontal
        dotsStack.spacing = 6
        dotsStack.alignment = .center
        dotsStack.distribution = .equalSpacing

        dots.forEach {
            $0.backgroundColor = AppColor.secondaryText
            $0.alpha = 0.35
        }
    }

    func buildHierarchy() {
        addSubview(dotsStack)

        dots.forEach {
            dotsStack.addArrangedSubview($0)
        }
    }

    func setupLayout() {
        [
            dotsStack,
            dots[0],
            dots[1],
            dots[2]
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            dotsStack.topAnchor.constraint(equalTo: topAnchor),
            dotsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            dotsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        dots.forEach { dot in
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8)
            ])
        }
    }

    func startAnimating() {
        for (index, dot) in dots.enumerated() {
            let delay = Double(index) * 0.18

            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 0.25
            animation.toValue = 1.0
            animation.duration = 0.55
            animation.autoreverses = true
            animation.repeatCount = .infinity
            animation.beginTime = CACurrentMediaTime() + delay

            dot.layer.add(animation, forKey: "typingOpacity")
        }
    }

    func stopAnimating() {
        dots.forEach {
            $0.layer.removeAnimation(forKey: "typingOpacity")
        }
    }
}
