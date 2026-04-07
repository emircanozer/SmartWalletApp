import UIKit


// uicontrol oalrak tanımladık uiview yerine default olarak tıklanabilirlik var tapgesture gerek yok iyi bi deneyim yani
// üstteki tıklanabilir işlem alanı component’i

class DashboardQuickActionControl: UIControl {
    let actionType: DashboardQuickActionType
    private let iconWrapper = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()

    init(item: DashboardQuickAction) {
        self.actionType = item.type
        super.init(frame: .zero)
        configureView(with: item)
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DashboardQuickActionControl {
    func configureView(with item: DashboardQuickAction) {
        iconWrapper.isUserInteractionEnabled = false
        iconView.isUserInteractionEnabled = false
        titleLabel.isUserInteractionEnabled = false

        let wrapperColor = item.isHighlighted
            ? AppColor.quickActionHighlight
            : AppColor.surfaceMuted

        let iconColor = item.isHighlighted
            ? AppColor.primaryText
            : AppColor.bodyText

        iconWrapper.backgroundColor = wrapperColor
        iconView.image = UIImage(systemName: item.iconName)
        iconView.tintColor = iconColor
        iconView.contentMode = .scaleAspectFit

        titleLabel.text = item.title.uppercased()
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 11, weight: .bold)
        titleLabel.textColor = AppColor.inputText
        titleLabel.numberOfLines = 2
    }

    func buildHierarchy() {
        addSubview(iconWrapper)
        iconWrapper.addSubview(iconView)
        addSubview(titleLabel)
    }

    func setupLayout() {
        [iconWrapper, iconView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            iconWrapper.topAnchor.constraint(equalTo: topAnchor),
            iconWrapper.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconWrapper.widthAnchor.constraint(equalToConstant: 56),
            iconWrapper.heightAnchor.constraint(equalToConstant: 56),

            iconView.centerXAnchor.constraint(equalTo: iconWrapper.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconWrapper.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),

            titleLabel.topAnchor.constraint(equalTo: iconWrapper.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconWrapper.layer.cornerRadius = iconWrapper.bounds.width / 2
    }
}
