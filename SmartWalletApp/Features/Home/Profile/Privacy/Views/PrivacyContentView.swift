import UIKit

final class PrivacyContentView: UIView {
    let backButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let brandLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let sectionsStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        buildHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PrivacyContentView {
    func apply(_ data: PrivacyViewData) {
        brandLabel.text = data.brandText
        titleLabel.text = data.titleText
        subtitleLabel.text = data.subtitleText

        sectionsStackView.arrangedSubviews.forEach {
            sectionsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        data.sections.forEach { item in
            let sectionView = PrivacySectionView()
            sectionView.configure(with: item)
            sectionsStackView.addArrangedSubview(sectionView)
        }
    }
}

extension PrivacyContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        contentContainer.backgroundColor = AppColor.appBackground

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint

        brandLabel.font = .systemFont(ofSize: 20, weight: .bold)
        brandLabel.textColor = AppColor.brandTextStrong
        brandLabel.textAlignment = .center

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.numberOfLines = 0

        sectionsStackView.axis = .vertical
        sectionsStackView.spacing = 24
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            brandLabel,
            titleLabel,
            subtitleLabel,
            sectionsStackView
        ].forEach(contentContainer.addSubview)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            brandLabel,
            titleLabel,
            subtitleLabel,
            sectionsStackView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            contentContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            brandLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            brandLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            sectionsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28),
            sectionsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sectionsStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            sectionsStackView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -32)
        ])
    }
}

private final class PrivacySectionView: UIView {
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
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

    func configure(with data: PrivacySectionViewData) {
        titleLabel.text = data.titleText
        bodyLabel.text = data.bodyText
    }
}

 extension PrivacySectionView {
    func configureView() {
        backgroundColor = .clear

        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = AppColor.accentOlive
        titleLabel.numberOfLines = 0

        bodyLabel.font = .systemFont(ofSize: 15, weight: .regular)
        bodyLabel.textColor = AppColor.bodyText
        bodyLabel.numberOfLines = 0
        bodyLabel.setLineSpacing(6)

        stackView.axis = .vertical
        stackView.spacing = 8
    }

    func buildHierarchy() {
        addSubview(stackView)
        [titleLabel, bodyLabel].forEach(stackView.addArrangedSubview)
    }

    func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
