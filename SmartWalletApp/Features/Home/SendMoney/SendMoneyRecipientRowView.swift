import UIKit

final class SendMoneyRecipientRowView: UIControl {
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let selectionOuterView = UIView()
    private let selectionInnerView = UIView()

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
        layer.cornerRadius = 18
        avatarView.layer.cornerRadius = avatarView.bounds.width / 2
        selectionOuterView.layer.cornerRadius = selectionOuterView.bounds.width / 2
        selectionInnerView.layer.cornerRadius = selectionInnerView.bounds.width / 2
    }

    func applySelected(_ isSelected: Bool) {
        layer.borderWidth = isSelected ? 1.5 : 0
        layer.borderColor = isSelected ? UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0).cgColor : UIColor.clear.cgColor
        selectionOuterView.layer.borderColor = isSelected
            ? UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0).cgColor
            : UIColor(red: 0.86, green: 0.87, blue: 0.9, alpha: 1.0).cgColor
        selectionInnerView.isHidden = !isSelected
    }
}

 extension SendMoneyRecipientRowView {
    func configureView() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.04
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)

        avatarView.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)

        avatarLabel.font = .systemFont(ofSize: 15, weight: .bold)
        avatarLabel.textColor = UIColor(red: 0.35, green: 0.37, blue: 0.43, alpha: 1.0)
        avatarLabel.textAlignment = .center

        nameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        nameLabel.textColor = UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)

        subtitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.52, green: 0.54, blue: 0.6, alpha: 1.0)

        selectionOuterView.layer.borderWidth = 1
        selectionOuterView.layer.borderColor = UIColor(red: 0.86, green: 0.87, blue: 0.9, alpha: 1.0).cgColor
        selectionOuterView.backgroundColor = .clear

        selectionInnerView.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        selectionInnerView.isHidden = true
    }

    func buildHierarchy() {
        addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(selectionOuterView)
        selectionOuterView.addSubview(selectionInnerView)
    }

    func setupLayout() {
        [avatarView, avatarLabel, nameLabel, subtitleLabel, selectionOuterView, selectionInnerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 72),

            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 36),
            avatarView.heightAnchor.constraint(equalToConstant: 36),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: selectionOuterView.leadingAnchor, constant: -12),

            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            selectionOuterView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectionOuterView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectionOuterView.widthAnchor.constraint(equalToConstant: 22),
            selectionOuterView.heightAnchor.constraint(equalToConstant: 22),

            selectionInnerView.centerXAnchor.constraint(equalTo: selectionOuterView.centerXAnchor),
            selectionInnerView.centerYAnchor.constraint(equalTo: selectionOuterView.centerYAnchor),
            selectionInnerView.widthAnchor.constraint(equalToConstant: 10),
            selectionInnerView.heightAnchor.constraint(equalToConstant: 10)
        ])

        nameTopConstraint = nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
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
