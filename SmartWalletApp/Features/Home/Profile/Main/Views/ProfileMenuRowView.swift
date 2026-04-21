import UIKit

final class ProfileMenuRowView: UIControl {
    var onToggleChanged: ((Bool) -> Void)?

    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let toggleSwitch = UISwitch()
    private let separatorView = UIView()

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
        iconContainerView.layer.cornerRadius = 16
    }
}

extension ProfileMenuRowView {
    func configure(with item: ProfileRowItem, showsSeparator: Bool) {
        titleLabel.text = item.titleText
        titleLabel.textColor = item.isDestructive ? AppColor.dangerStrong : AppColor.primaryText
        iconImageView.image = UIImage(systemName: item.iconName)
        iconImageView.tintColor = item.isDestructive ? AppColor.dangerStrong : AppColor.navigationTint
        iconContainerView.backgroundColor = item.isDestructive ? UIColor(red: 1.0, green: 0.96, blue: 0.96, alpha: 1.0) : AppColor.surfaceMuted
        separatorView.isHidden = !showsSeparator

        switch item.accessory {
        case .chevron:
            chevronImageView.isHidden = false
            toggleSwitch.isHidden = true
            isUserInteractionEnabled = true
        case .toggle(let isOn):
            chevronImageView.isHidden = true
            toggleSwitch.isHidden = false
            toggleSwitch.isOn = isOn
            isUserInteractionEnabled = true
        case .none:
            chevronImageView.isHidden = true
            toggleSwitch.isHidden = true
            isUserInteractionEnabled = false
        }
    }
}

 extension ProfileMenuRowView {
    func configureView() {
        backgroundColor = .clear

        iconImageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = AppColor.iconMuted
        chevronImageView.contentMode = .scaleAspectFit

        toggleSwitch.onTintColor = AppColor.primaryYellow
        toggleSwitch.addTarget(self, action: #selector(handleSwitchChanged), for: .valueChanged)

        separatorView.backgroundColor = AppColor.divider
    }

    func buildHierarchy() {
        [iconContainerView, titleLabel, chevronImageView, toggleSwitch, separatorView].forEach(addSubview)
        iconContainerView.addSubview(iconImageView)
    }

    func setupLayout() {
        [iconContainerView, iconImageView, titleLabel, chevronImageView, toggleSwitch, separatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            iconContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 32),
            iconContainerView.heightAnchor.constraint(equalToConstant: 32),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16),

            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12),

            toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggleSwitch.leadingAnchor, constant: -12),

            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    @objc func handleSwitchChanged() {
        onToggleChanged?(toggleSwitch.isOn)
    }
}
