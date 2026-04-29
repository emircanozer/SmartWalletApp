import UIKit

final class SendMoneyRecipientRowView: UIControl {
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()

    let recipient: SendMoneyRecipient

    init(recipient: SendMoneyRecipient) {
        self.recipient = recipient
        super.init(frame: .zero)
        configureView()
        buildHierarchy()
        setupLayout()
        applyData(recipient)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 16
        avatarView.layer.cornerRadius = avatarView.bounds.width / 2
    }

    func applySelected(_ isSelected: Bool) {
        layer.borderWidth = isSelected ? 1.5 : 0
        layer.borderColor = isSelected ? AppColor.primaryYellow.cgColor : UIColor.clear.cgColor
    }
}

 extension SendMoneyRecipientRowView {
    func configureView() {
        backgroundColor = AppColor.whitePrimary
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.04
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)

        avatarView.backgroundColor = AppColor.surfaceMuted

        avatarLabel.font = .systemFont(ofSize: 15, weight: .bold)
        avatarLabel.textColor = AppColor.mutedText
        avatarLabel.textAlignment = .center

        nameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        nameLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        subtitleLabel.textColor = AppColor.tertiaryText
    }

    func buildHierarchy() {
        addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        addSubview(nameLabel)
        addSubview(subtitleLabel)
    }

    func setupLayout() {
        [avatarView, avatarLabel, nameLabel, subtitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 64),

            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 32),
            avatarView.heightAnchor.constraint(equalToConstant: 32),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])

        nameTopConstraint = nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        nameCenterYConstraint = nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        nameTopConstraint?.isActive = true
    }

    func applyData(_ recipient: SendMoneyRecipient) {
        avatarLabel.text = String(recipient.name.prefix(1)).uppercased()
        nameLabel.text = recipient.name
        subtitleLabel.text = recipient.subtitle
        let hasSubtitle = !recipient.subtitle.isEmpty
        subtitleLabel.isHidden = !hasSubtitle
        nameTopConstraint?.isActive = hasSubtitle
        nameCenterYConstraint?.isActive = !hasSubtitle
    }
}
    private var nameTopConstraint: NSLayoutConstraint?
    private var nameCenterYConstraint: NSLayoutConstraint?
