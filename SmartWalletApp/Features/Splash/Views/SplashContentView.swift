import UIKit

final class SplashContentView: UIView {
    private let contentStack = UIStackView()
    private let titleStack = UIStackView()
    private let logoContainer = UIView()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let aiLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let footerStack = UIStackView()
    private let footerIconView = UIImageView()
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
        logoContainer.layer.cornerRadius = 16
        logoContainer.layer.cornerCurve = .continuous
        logoImageView.layer.cornerRadius = 12
        logoImageView.layer.cornerCurve = .continuous
    }
}

extension SplashContentView {
    func apply(_ data: SplashViewData) {
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText
        footerLabel.text = data.footerText
        logoImageView.image = UIImage(named: data.logoImageName)
    }
}

private extension SplashContentView {
    func configureView() {
        backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)

        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 18

        titleStack.axis = .horizontal
        titleStack.alignment = .center
        titleStack.spacing = 6

        logoContainer.backgroundColor = AppColor.primaryYellow
        logoContainer.layer.shadowColor = UIColor(red: 1.0, green: 0.76, blue: 0.08, alpha: 0.4).cgColor
        logoContainer.layer.shadowOpacity = 0.45
        logoContainer.layer.shadowRadius = 16
        logoContainer.layer.shadowOffset = CGSize(width: 0, height: 8)

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.backgroundColor = UIColor(red: 1.0, green: 0.74, blue: 0.07, alpha: 1.0)
        logoImageView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.12, green: 0.13, blue: 0.16, alpha: 1.0)

        aiLabel.font = .systemFont(ofSize: 32, weight: .bold)
        aiLabel.textColor = AppColor.primaryYellow
        aiLabel.text = "AI"

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.53, alpha: 1.0)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 1

        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.spacing = 8

        footerIconView.image = UIImage(systemName: "shield")
        footerIconView.tintColor = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1.0)
        footerIconView.contentMode = .scaleAspectFit

        footerLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        footerLabel.textColor = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1.0)
        footerLabel.textAlignment = .center
    }

    func buildHierarchy() {
        addSubview(contentStack)
        addSubview(footerStack)

        contentStack.addArrangedSubview(logoContainer)
        logoContainer.addSubview(logoImageView)

        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(aiLabel)

        contentStack.addArrangedSubview(titleStack)
        contentStack.addArrangedSubview(subtitleLabel)

        footerStack.addArrangedSubview(footerIconView)
        footerStack.addArrangedSubview(footerLabel)
    }

    func setupLayout() {
        [
            contentStack,
            titleStack,
            logoContainer,
            logoImageView,
            titleLabel,
            aiLabel,
            subtitleLabel,
            footerStack,
            footerIconView,
            footerLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -24),
            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),

            logoContainer.widthAnchor.constraint(equalToConstant: 116),
            logoContainer.heightAnchor.constraint(equalToConstant: 116),

            logoImageView.topAnchor.constraint(equalTo: logoContainer.topAnchor, constant: 20),
            logoImageView.leadingAnchor.constraint(equalTo: logoContainer.leadingAnchor, constant: 20),
            logoImageView.trailingAnchor.constraint(equalTo: logoContainer.trailingAnchor, constant: -20),
            logoImageView.bottomAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: -20),

            subtitleLabel.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor),

            footerStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            footerStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -72),
            footerStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            footerStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),

            footerIconView.widthAnchor.constraint(equalToConstant: 14),
            footerIconView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
}
