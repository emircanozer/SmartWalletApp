import UIKit

final class EmptyStateView: UIView {
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let stackView = UIStackView()

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
        iconContainerView.layer.cornerRadius = iconContainerView.bounds.width / 2
        layer.cornerRadius = 24
    }

    func configure(title: String, message: String, systemImageName: String = "tray") {
        titleLabel.text = title
        messageLabel.text = message
        iconImageView.image = UIImage(systemName: systemImageName)
    }
}

 extension EmptyStateView {
    func configureView() {
        backgroundColor = AppColor.whitePrimary
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 18
        layer.shadowOffset = CGSize(width: 0, height: 8)

        iconContainerView.backgroundColor = AppColor.surfaceMuted

        iconImageView.tintColor = AppColor.accentOlive
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageLabel.font = .systemFont(ofSize: 15, weight: .medium)
        messageLabel.textColor = AppColor.secondaryText
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 14
    }

    func buildHierarchy() {
        addSubview(stackView)
        iconContainerView.addSubview(iconImageView)
        [iconContainerView, titleLabel, messageLabel].forEach(stackView.addArrangedSubview)
    }

    func setupLayout() {
        [stackView, iconContainerView, iconImageView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 28),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),

            iconContainerView.widthAnchor.constraint(equalToConstant: 64),
            iconContainerView.heightAnchor.constraint(equalToConstant: 64),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
}
