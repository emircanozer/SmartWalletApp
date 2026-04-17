import UIKit

final class SendMoneyLookupView: UIView {
    let starButton = UIButton(type: .system)

    private let dotView = UIView()
    private let nameLabel = UILabel()
    private let ibanLabel = UILabel()

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
        layer.cornerRadius = 14
        dotView.layer.cornerRadius = dotView.bounds.width / 2
    }

    func applyRecipient(_ recipient: SendMoneyLookupRecipient?) {
        guard let recipient else {
            isHidden = true
            return
        }

        isHidden = false
        nameLabel.text = recipient.ownerMaskedName
        ibanLabel.isHidden = true
        let iconName = recipient.isSaved ? "star.fill" : "star"
        starButton.setImage(UIImage(systemName: iconName), for: .normal)
        starButton.tintColor = AppColor.accentGold
    }
}

 extension SendMoneyLookupView {
    func configureView() {
        backgroundColor = AppColor.successSurface
        isHidden = true

        dotView.backgroundColor = AppColor.successStrong

        nameLabel.font = .systemFont(ofSize: 13, weight: .bold)
        nameLabel.textColor = AppColor.primaryText

        ibanLabel.font = .systemFont(ofSize: 12, weight: .medium)
        ibanLabel.textColor = AppColor.bodyText
        ibanLabel.isHidden = true

        starButton.contentMode = .scaleAspectFit
    }

    func buildHierarchy() {
        addSubview(dotView)
        addSubview(nameLabel)
        addSubview(ibanLabel)
        addSubview(starButton)
    }

    func setupLayout() {
        [dotView, nameLabel, ibanLabel, starButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            dotView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            dotView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            dotView.widthAnchor.constraint(equalToConstant: 8),
            dotView.heightAnchor.constraint(equalToConstant: 8),

            nameLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: starButton.leadingAnchor, constant: -8),

            ibanLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ibanLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ibanLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            ibanLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            starButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            starButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            starButton.widthAnchor.constraint(equalToConstant: 28),
            starButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
}
