import UIKit

class WelcomeContentView: UIView {
    let primaryButton = UIButton(type: .system)
    let secondaryButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let headerStack = UIStackView()
    private let brandStack = UIStackView()
    private let titleLabel = UILabel()
    private let headerActionsStack = UIStackView()
    private let languageButton = UIButton(type: .system)
    private let heroContainer = UIView()
    private let avatarOrbitView = UIView()
    private let avatarCircleView = UIView()
    private let avatarIconView = UIImageView()
    private let welcomeLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let shortcutsStack = UIStackView()
    private let tertiaryButton = UIButton(type: .system)
    private let bottomBar = UIView()
    private let tabStack = UIStackView()

    private struct Shortcut {
        let title: String
        let iconName: String
    }

    private struct TabItem {
        let title: String
        let iconName: String
        let isHighlighted: Bool
    }

    
    private let welcomeTitleText = "Hoş Geldiniz"
    private let welcomeSubtitleText = "Finansal asistanınız her an yanınızda."
    private let primaryButtonTitleText = "Giriş Yap"
    private let secondaryButtonTitleText = "Kayıt Ol"
    private let shortcuts: [Shortcut] = [
        .init(title: "AI Analiz", iconName: "brain.head.profile"),
        .init(title: "Smart Limit", iconName: "gauge"),
        .init(title: "Hızlı Trf.", iconName: "arrow.left.arrow.right"),
        .init(title: "Birikim", iconName: "dollarsign.circle"),
        .init(title: "Piyasalar", iconName: "chart.line.uptrend.xyaxis")
    ]
    private let tabItems: [TabItem] = [
        .init(title: "Anasayfa", iconName: "house", isHighlighted: false),
        .init(title: "Piyasalar", iconName: "chart.bar.xaxis.ascending", isHighlighted: false),
        .init(title: "", iconName: "apple.intelligence", isHighlighted: true),
        .init(title: "Transfer", iconName: "arrow.left.arrow.right", isHighlighted: false),
        .init(title: "Profil", iconName: "person", isHighlighted: false)
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
        applyContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WelcomeContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.backgroundColor = AppColor.appBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        contentContainer.backgroundColor = AppColor.appBackground

        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalSpacing
        headerStack.spacing = 12

        brandStack.axis = .horizontal
        brandStack.alignment = .center
        brandStack.spacing = 10

        titleLabel.font = .systemFont(ofSize: 21, weight: .bold)
        titleLabel.textColor = AppColor.titleDark
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.lineBreakMode = .byTruncatingTail

        headerActionsStack.axis = .horizontal
        headerActionsStack.alignment = .center
        headerActionsStack.spacing = 14

        languageButton.setTitleColor(AppColor.mutedText, for: .normal)
        languageButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)

        avatarOrbitView.backgroundColor = AppColor.surfaceWarmSoft
        avatarOrbitView.layer.borderWidth = 0.5

        avatarCircleView.backgroundColor = AppColor.whitePrimary
        avatarCircleView.layer.borderWidth = 5
        avatarCircleView.layer.borderColor = AppColor.resolvedCGColor(AppColor.accentYellow, for: traitCollection)

        avatarIconView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarIconView.tintColor = AppColor.accentYellow
        avatarIconView.contentMode = .scaleAspectFit

        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = AppColor.titleDark
        welcomeLabel.font = .systemFont(ofSize: 30, weight: .bold)

        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = AppColor.tertiaryText
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.numberOfLines = 0

        shortcutsStack.axis = .horizontal
        shortcutsStack.alignment = .top
        shortcutsStack.distribution = .fillEqually
        shortcutsStack.spacing = 8

        primaryButton.backgroundColor = AppColor.primaryYellow
        primaryButton.setTitleColor(AppColor.titleDark, for: .normal)
        primaryButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        primaryButton.layer.shadowColor = AppColor.primaryYellow.cgColor
        primaryButton.layer.shadowOpacity = 0.2
        primaryButton.layer.shadowRadius = 18
        primaryButton.layer.shadowOffset = CGSize(width: 0, height: 10)

        secondaryButton.backgroundColor = AppColor.whitePrimary
        secondaryButton.setTitleColor(AppColor.accentYellow, for: .normal)
        secondaryButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        secondaryButton.layer.borderWidth = 1
        secondaryButton.layer.borderColor = AppColor.resolvedCGColor(AppColor.borderSoft, for: traitCollection)

        tertiaryButton.setTitleColor(AppColor.bodyText, for: .normal)
        tertiaryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

        bottomBar.backgroundColor = AppColor.whitePrimary
        bottomBar.layer.shadowColor = UIColor.black.cgColor
        bottomBar.layer.shadowOpacity = 0.08
        bottomBar.layer.shadowRadius = 24
        bottomBar.layer.shadowOffset = CGSize(width: 0, height: -6)

        tabStack.axis = .horizontal
        tabStack.alignment = .center
        tabStack.distribution = .fillEqually
    }

    func buildHierarchy() {
        addSubview(scrollView)
        addSubview(bottomBar)

        scrollView.addSubview(contentContainer)

        contentContainer.addSubview(headerStack)
        contentContainer.addSubview(heroContainer)
        contentContainer.addSubview(welcomeLabel)
        contentContainer.addSubview(subtitleLabel)
        contentContainer.addSubview(shortcutsStack)
        contentContainer.addSubview(primaryButton)
        contentContainer.addSubview(secondaryButton)
        contentContainer.addSubview(tertiaryButton)

        headerStack.addArrangedSubview(brandStack)
        headerStack.addArrangedSubview(headerActionsStack)
        brandStack.addArrangedSubview(titleLabel)

        headerActionsStack.addArrangedSubview(languageButton)

        heroContainer.addSubview(avatarOrbitView)
        avatarOrbitView.addSubview(avatarCircleView)
        avatarCircleView.addSubview(avatarIconView)

        bottomBar.addSubview(tabStack)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            headerStack,
            heroContainer,
            avatarOrbitView,
            avatarCircleView,
            avatarIconView,
            welcomeLabel,
            subtitleLabel,
            shortcutsStack,
            primaryButton,
            secondaryButton,
            tertiaryButton,
            bottomBar,
            tabStack
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor, constant: -10),

            contentContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentContainer.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            headerStack.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 14),
            headerStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            heroContainer.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 40),
            heroContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            heroContainer.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            heroContainer.heightAnchor.constraint(equalToConstant: 166),

            avatarOrbitView.centerXAnchor.constraint(equalTo: heroContainer.centerXAnchor),
            avatarOrbitView.centerYAnchor.constraint(equalTo: heroContainer.centerYAnchor),
            avatarOrbitView.widthAnchor.constraint(equalToConstant: 138),
            avatarOrbitView.heightAnchor.constraint(equalToConstant: 138),

            avatarCircleView.centerXAnchor.constraint(equalTo: avatarOrbitView.centerXAnchor),
            avatarCircleView.centerYAnchor.constraint(equalTo: avatarOrbitView.centerYAnchor),
            avatarCircleView.widthAnchor.constraint(equalToConstant: 74),
            avatarCircleView.heightAnchor.constraint(equalToConstant: 74),

            avatarIconView.centerXAnchor.constraint(equalTo: avatarCircleView.centerXAnchor),
            avatarIconView.centerYAnchor.constraint(equalTo: avatarCircleView.centerYAnchor),
            avatarIconView.widthAnchor.constraint(equalToConstant: 34),
            avatarIconView.heightAnchor.constraint(equalToConstant: 34),

            welcomeLabel.topAnchor.constraint(equalTo: heroContainer.bottomAnchor, constant: 18),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -32),

            shortcutsStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            shortcutsStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 14),
            shortcutsStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -14),

            primaryButton.topAnchor.constraint(equalTo: shortcutsStack.bottomAnchor, constant: 34),
            primaryButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            primaryButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),
            primaryButton.heightAnchor.constraint(equalToConstant: 56),

            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: 14),
            secondaryButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            secondaryButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),
            secondaryButton.heightAnchor.constraint(equalToConstant: 56),

            tertiaryButton.topAnchor.constraint(equalTo: secondaryButton.bottomAnchor, constant: 18),
            tertiaryButton.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            tertiaryButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -20),

            bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            bottomBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            bottomBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            bottomBar.heightAnchor.constraint(equalToConstant: 88),

            tabStack.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 8),
            tabStack.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 8),
            tabStack.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -8),
            tabStack.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -10)
        ])
    }

    func applyContent() {
        titleLabel.text = "SmartWallet AI"
        welcomeLabel.text = welcomeTitleText
        subtitleLabel.text = welcomeSubtitleText
        primaryButton.setTitle(primaryButtonTitleText, for: .normal)
        secondaryButton.setTitle(secondaryButtonTitleText, for: .normal)
       

        shortcuts.forEach { shortcut in
            shortcutsStack.addArrangedSubview(ShortcutItemView(title: shortcut.title, iconName: shortcut.iconName))
        }

        tabItems.forEach { item in
            tabStack.addArrangedSubview(FooterTabItemView(title: item.title, iconName: item.iconName, isHighlighted: item.isHighlighted))
        }
    }

    func applyCornerRadius() {
        primaryButton.layer.cornerRadius = primaryButton.bounds.height / 2
        secondaryButton.layer.cornerRadius = secondaryButton.bounds.height / 2
        bottomBar.layer.cornerRadius = 30
        avatarOrbitView.layer.cornerRadius = avatarOrbitView.bounds.width / 2
        avatarCircleView.layer.cornerRadius = avatarCircleView.bounds.width / 2
        avatarOrbitView.layer.borderColor = AppColor.resolvedCGColor(AppColor.borderSoft, for: traitCollection)
        secondaryButton.layer.borderColor = AppColor.resolvedCGColor(AppColor.borderSoft, for: traitCollection)
        avatarCircleView.layer.borderColor = AppColor.resolvedCGColor(AppColor.accentYellow, for: traitCollection)
    }
}

class ShortcutItemView: UIView {
    private let iconContainer = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()

    init(title: String, iconName: String) {
        super.init(frame: .zero)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.backgroundColor = AppColor.surfaceWarmSoft
        iconContainer.layer.cornerRadius = 22

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(systemName: iconName)
        iconView.tintColor = AppColor.accentYellow
        iconView.contentMode = .scaleAspectFit

        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = AppColor.inputText
        titleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        titleLabel.numberOfLines = 2

        addSubview(stack)
        stack.addArrangedSubview(iconContainer)
        stack.addArrangedSubview(titleLabel)
        iconContainer.addSubview(iconView)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconContainer.widthAnchor.constraint(equalToConstant: 44),
            iconContainer.heightAnchor.constraint(equalToConstant: 44),

            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FooterTabItemView: UIView {
    init(title: String, iconName: String, isHighlighted: Bool) {
        super.init(frame: .zero)

        if isHighlighted {
            let circle = UIView()
            let iconView = UIImageView()

            circle.translatesAutoresizingMaskIntoConstraints = false
            iconView.translatesAutoresizingMaskIntoConstraints = false

            circle.backgroundColor = AppColor.primaryYellow
            circle.layer.cornerRadius = 25

            iconView.image = UIImage(systemName: iconName)
            iconView.tintColor = AppColor.authHeadingText
            iconView.contentMode = .scaleAspectFit

            addSubview(circle)
            circle.addSubview(iconView)

            NSLayoutConstraint.activate([
                circle.centerXAnchor.constraint(equalTo: centerXAnchor),
                circle.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -6),
                circle.widthAnchor.constraint(equalToConstant: 50),
                circle.heightAnchor.constraint(equalToConstant: 50),

                iconView.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
                iconView.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
                iconView.widthAnchor.constraint(equalToConstant: 24),
                iconView.heightAnchor.constraint(equalToConstant: 24)
            ])
        } else {
            let stack = UIStackView()
            let iconView = UIImageView()
            let titleLabel = UILabel()

            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.alignment = .center
            stack.spacing = 6

            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.image = UIImage(systemName: iconName)
            iconView.tintColor = AppColor.iconMuted
            iconView.contentMode = .scaleAspectFit

            titleLabel.text = title
            titleLabel.textColor = AppColor.iconMuted
            titleLabel.font = .systemFont(ofSize: 10, weight: .medium)
            titleLabel.textAlignment = .center

            addSubview(stack)
            stack.addArrangedSubview(iconView)
            stack.addArrangedSubview(titleLabel)

            NSLayoutConstraint.activate([
                stack.centerXAnchor.constraint(equalTo: centerXAnchor),
                stack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 4),

                iconView.widthAnchor.constraint(equalToConstant: 18),
                iconView.heightAnchor.constraint(equalToConstant: 18)
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
