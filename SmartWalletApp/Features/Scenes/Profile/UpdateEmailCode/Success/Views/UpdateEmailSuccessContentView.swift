import UIKit

final class UpdateEmailSuccessContentView: UIView {
    let homeButton = UIButton(type: .system)

    private let brandLabel = UILabel()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let footerLabel = UILabel()

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
        homeButton.layer.cornerRadius = 10
    }
}

extension UpdateEmailSuccessContentView {
    func apply(_ data: UpdateEmailSuccessViewData) {
        brandLabel.text = data.brandText
        titleLabel.text = data.titleText
        bodyLabel.text = data.bodyText
        homeButton.setTitle(data.homeButtonTitleText, for: .normal)
        footerLabel.text = data.footerText
    }
}

 extension UpdateEmailSuccessContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        brandLabel.font = .systemFont(ofSize: 17, weight: .bold)
        brandLabel.textColor = AppColor.accentOlive
        brandLabel.textAlignment = .center

        iconImageView.image = UIImage(named: "success3")
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText
        titleLabel.textAlignment = .center

        bodyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        bodyLabel.textColor = AppColor.bodyText
        bodyLabel.textAlignment = .center
        bodyLabel.numberOfLines = 0

        homeButton.backgroundColor = AppColor.primaryYellow
        homeButton.setTitleColor(AppColor.primaryText, for: .normal)
        homeButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)

        footerLabel.font = .systemFont(ofSize: 13, weight: .medium)
        footerLabel.textColor = AppColor.secondaryText
        footerLabel.textAlignment = .center
    }

    func buildHierarchy() {
        [brandLabel, iconImageView, titleLabel, bodyLabel, homeButton, footerLabel].forEach(addSubview)
    }

    func setupLayout() {
        [brandLabel, iconImageView, titleLabel, bodyLabel, homeButton, footerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            brandLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            brandLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            iconImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 188),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 160),
            iconImageView.heightAnchor.constraint(equalToConstant: 160),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            homeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 54),
            homeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -54),
            homeButton.heightAnchor.constraint(equalToConstant: 56),
            homeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -86),

            footerLabel.topAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: 18),
            footerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            footerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
}
