import UIKit

final class ChangePasswordSuccessContentView: UIView {
    let homeButton = UIButton(type: .system)

    private let contentContainer = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()

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
        homeButton.layer.cornerRadius = 16
    }
}

extension ChangePasswordSuccessContentView {
    func apply(_ data: ChangePasswordSuccessViewData) {
        titleLabel.text = data.titleText
        bodyLabel.text = data.bodyText
        homeButton.setTitle(data.homeButtonTitleText, for: .normal)
    }
}

 extension ChangePasswordSuccessContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        iconImageView.image = UIImage(named: "success3")
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        bodyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        bodyLabel.textColor = AppColor.bodyText
        bodyLabel.textAlignment = .center
        bodyLabel.numberOfLines = 0
        bodyLabel.setLineSpacing(7)

        homeButton.backgroundColor = AppColor.primaryYellow
        homeButton.setTitleColor(AppColor.primaryText, for: .normal)
        homeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    }

    func buildHierarchy() {
        addSubview(contentContainer)
        [iconImageView, titleLabel, bodyLabel, homeButton].forEach(contentContainer.addSubview)
    }

    func setupLayout() {
        [contentContainer, iconImageView, titleLabel, bodyLabel, homeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            iconImageView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 110),
            iconImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 190),
            iconImageView.heightAnchor.constraint(equalToConstant: 190),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 44),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -44),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            bodyLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 42),
            bodyLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -42),

            homeButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 34),
            homeButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -34),
            homeButton.heightAnchor.constraint(equalToConstant: 64),
            homeButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -62)
        ])
    }
}
