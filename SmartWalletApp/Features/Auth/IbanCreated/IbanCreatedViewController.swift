import UIKit

class IbanCreatedViewController: UIViewController {
    var onContinue: (() -> Void)?

    private let contentView = UIView()
    private let cardView = UIView()
    private let iconWrapper = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let ibanTitleLabel = UILabel()
    private let ibanContainer = UIView()
    private let ibanIconView = UIImageView()
    private let ibanValueLabel = UILabel()
    private let copyButton = UIButton(type: .system)
    private let ibanDescriptionLabel = UILabel()
    private let continueButton = UIButton(type: .system)
    private let titleText = "Hesabınız Oluşturuldu"
    private let subtitleText = "Size özel IBAN başarıyla oluşturuldu"
    private let ibanTitleText = "YENİ IBAN ADRESİNİZ"
    private let ibanValueText = "TR123456789012345678912345"
    private let ibanDescriptionText = "Bu IBAN ile para transferi yapabilirsiniz"
    private let buttonTitleText = "Devam Et  →"

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        buildHierarchy()
        setupLayout()
        applyContent()
        bindActions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardView.layer.cornerRadius = 26
        iconWrapper.layer.cornerRadius = iconWrapper.bounds.width / 2
        ibanContainer.layer.cornerRadius = ibanContainer.bounds.height / 2
        continueButton.layer.cornerRadius = continueButton.bounds.height / 2
    }
}

extension IbanCreatedViewController {
    func configureView() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)

        contentView.backgroundColor = .clear

        cardView.backgroundColor = .white
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 24
        cardView.layer.shadowOffset = CGSize(width: 0, height: 12)

        iconWrapper.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)

        iconView.image = UIImage(systemName: "square.fill")
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit

        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)

        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.56, green: 0.58, blue: 0.63, alpha: 1.0)
        subtitleLabel.numberOfLines = 0

        ibanTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        ibanTitleLabel.textColor = UIColor(red: 0.47, green: 0.49, blue: 0.54, alpha: 1.0)

        ibanContainer.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)

        ibanIconView.image = UIImage(systemName: "wallet.pass.fill")
        ibanIconView.tintColor = UIColor(red: 0.62, green: 0.65, blue: 0.71, alpha: 1.0)
        ibanIconView.contentMode = .scaleAspectFit

        ibanValueLabel.font = .systemFont(ofSize: 15, weight: .bold)
        ibanValueLabel.textColor = UIColor(red: 0.33, green: 0.35, blue: 0.41, alpha: 1.0)
        ibanValueLabel.lineBreakMode = .byTruncatingMiddle

        copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        copyButton.tintColor = UIColor(red: 0.45, green: 0.47, blue: 0.54, alpha: 1.0)

        ibanDescriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        ibanDescriptionLabel.textColor = UIColor(red: 0.64, green: 0.66, blue: 0.71, alpha: 1.0)
        ibanDescriptionLabel.numberOfLines = 0

        continueButton.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        continueButton.layer.shadowColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0).cgColor
        continueButton.layer.shadowOpacity = 0.2
        continueButton.layer.shadowRadius = 18
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 10)
    }

    func buildHierarchy() {
        view.addSubview(contentView)
        contentView.addSubview(cardView)

        cardView.addSubview(iconWrapper)
        iconWrapper.addSubview(iconView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(ibanTitleLabel)
        cardView.addSubview(ibanContainer)
        ibanContainer.addSubview(ibanIconView)
        ibanContainer.addSubview(ibanValueLabel)
        ibanContainer.addSubview(copyButton)
        cardView.addSubview(ibanDescriptionLabel)
        cardView.addSubview(continueButton)
    }
}

extension IbanCreatedViewController {
    func setupLayout() {
        [
            contentView,
            cardView,
            iconWrapper,
            iconView,
            titleLabel,
            subtitleLabel,
            ibanTitleLabel,
            ibanContainer,
            ibanIconView,
            ibanValueLabel,
            copyButton,
            ibanDescriptionLabel,
            continueButton,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            cardView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            iconWrapper.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 36),
            iconWrapper.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            iconWrapper.widthAnchor.constraint(equalToConstant: 64),
            iconWrapper.heightAnchor.constraint(equalToConstant: 64),

            iconView.centerXAnchor.constraint(equalTo: iconWrapper.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconWrapper.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.topAnchor.constraint(equalTo: iconWrapper.bottomAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 28),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -28),

            ibanTitleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28),
            ibanTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 28),
            ibanTitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -28),

            ibanContainer.topAnchor.constraint(equalTo: ibanTitleLabel.bottomAnchor, constant: 12),
            ibanContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            ibanContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            ibanContainer.heightAnchor.constraint(equalToConstant: 48),

            ibanIconView.leadingAnchor.constraint(equalTo: ibanContainer.leadingAnchor, constant: 16),
            ibanIconView.centerYAnchor.constraint(equalTo: ibanContainer.centerYAnchor),
            ibanIconView.widthAnchor.constraint(equalToConstant: 18),
            ibanIconView.heightAnchor.constraint(equalToConstant: 18),

            copyButton.trailingAnchor.constraint(equalTo: ibanContainer.trailingAnchor, constant: -16),
            copyButton.centerYAnchor.constraint(equalTo: ibanContainer.centerYAnchor),
            copyButton.widthAnchor.constraint(equalToConstant: 20),
            copyButton.heightAnchor.constraint(equalToConstant: 20),

            ibanValueLabel.leadingAnchor.constraint(equalTo: ibanIconView.trailingAnchor, constant: 10),
            ibanValueLabel.centerYAnchor.constraint(equalTo: ibanContainer.centerYAnchor),
            ibanValueLabel.trailingAnchor.constraint(equalTo: copyButton.leadingAnchor, constant: -10),

            ibanDescriptionLabel.topAnchor.constraint(equalTo: ibanContainer.bottomAnchor, constant: 16),
            ibanDescriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 28),
            ibanDescriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -28),

            continueButton.topAnchor.constraint(equalTo: ibanDescriptionLabel.bottomAnchor, constant: 28),
            continueButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            continueButton.heightAnchor.constraint(equalToConstant: 54),
            continueButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -28),
        ])
    }
}

extension IbanCreatedViewController {
    func applyContent() {
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        ibanTitleLabel.text = ibanTitleText
        ibanValueLabel.text = ibanValueText
        ibanDescriptionLabel.text = ibanDescriptionText
        continueButton.setTitle(buttonTitleText, for: .normal)
    }

    func bindActions() {
        copyButton.addTarget(self, action: #selector(handleCopyTap), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinueTap), for: .touchUpInside)
    }

    @objc func handleCopyTap() {
        UIPasteboard.general.string = ibanValueText
    }

    @objc func handleContinueTap() {
        onContinue?()
    }
}
