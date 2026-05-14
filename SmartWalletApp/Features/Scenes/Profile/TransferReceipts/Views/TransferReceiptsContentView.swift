import UIKit

final class TransferReceiptsContentView: UIView {
    let backButton = UIButton(type: .system)
    let searchField = UITextField()
    let dateFilterButton = UIButton(type: .system)
    let typeFilterButton = UIButton(type: .system)
    let tableView = UITableView(frame: .zero, style: .plain)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let filterCardView = UIView()
    private let searchContainerView = UIView()
    private let searchIconView = UIImageView()
    private let dateFilterContainerView = UIView()
    private let dateFilterIconView = UIImageView()
    private let dateChevronView = UIImageView()
    private let typeFilterContainerView = UIView()
    private let typeFilterIconView = UIImageView()
    private let typeChevronView = UIImageView()
    private let sectionTitleLabel = UILabel()
    private let emptyStateView = EmptyStateView()
    private var tableHeightConstraint: NSLayoutConstraint?

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
        filterCardView.layer.cornerRadius = 26
        [searchContainerView, dateFilterContainerView, typeFilterContainerView].forEach {
            $0.layer.cornerRadius = 16
        }
    }
}

extension TransferReceiptsContentView {
    func apply(_ data: TransferReceiptsViewData) {
        titleLabel.text = data.titleText
        descriptionLabel.text = data.descriptionText
        searchField.attributedPlaceholder = NSAttributedString(
            string: data.searchPlaceholderText,
            attributes: [
                .foregroundColor: AppColor.placeholderText,
                .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ]
        )
        dateFilterButton.setTitle(data.selectedDateFilterTitleText, for: .normal)
        typeFilterButton.setTitle(data.selectedTypeFilterTitleText, for: .normal)
        sectionTitleLabel.text = data.sectionTitleText
        let isEmpty = data.emptyMessageText != nil
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        if let message = data.emptyMessageText {
            emptyStateView.configure(
                title: "Dekont bulunamadı",
                message: message,
                systemImageName: "doc.text.magnifyingglass"
            )
        }
        tableHeightConstraint?.constant = CGFloat(data.items.count) * 128
    }

    func setLoading(_ isLoading: Bool) {
        tableView.alpha = isLoading ? 0.5 : 1
    }
}

 extension TransferReceiptsContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.accentOlive

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        descriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textColor = AppColor.bodyText
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setLineSpacing(5)

        filterCardView.backgroundColor = AppColor.surfaceMuted

        [searchContainerView, dateFilterContainerView, typeFilterContainerView].forEach {
            $0.backgroundColor = AppColor.whitePrimary
        }

        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.tintColor = AppColor.iconMuted

        searchField.borderStyle = .none
        searchField.font = .systemFont(ofSize: 16, weight: .medium)
        searchField.textColor = AppColor.inputText
        searchField.keyboardAppearance = .default
        searchField.clearButtonMode = .whileEditing

        dateFilterIconView.image = UIImage(systemName: "calendar")
        dateFilterIconView.tintColor = AppColor.navigationTint
        typeFilterIconView.image = UIImage(systemName: "line.3.horizontal.decrease")
        typeFilterIconView.tintColor = AppColor.navigationTint
        [dateChevronView, typeChevronView].forEach {
            $0.image = UIImage(systemName: "chevron.down")
            $0.tintColor = AppColor.iconMuted
        }

        [dateFilterButton, typeFilterButton].forEach {
            $0.setTitleColor(AppColor.primaryText, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.contentHorizontalAlignment = .left
        }

        sectionTitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        sectionTitleLabel.textColor = AppColor.secondaryText
        sectionTitleLabel.letterSpacing = 2.2

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.keyboardDismissMode = .interactive
        tableView.register(TransferReceiptsItemCell.self, forCellReuseIdentifier: TransferReceiptsItemCell.reuseIdentifier)

        emptyStateView.isHidden = true
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            titleLabel,
            descriptionLabel,
            filterCardView,
            sectionTitleLabel,
            tableView,
            emptyStateView
        ].forEach(contentContainer.addSubview)

        [searchContainerView, dateFilterContainerView, typeFilterContainerView].forEach(filterCardView.addSubview)
        [searchIconView, searchField].forEach(searchContainerView.addSubview)
        [dateFilterIconView, dateFilterButton, dateChevronView].forEach(dateFilterContainerView.addSubview)
        [typeFilterIconView, typeFilterButton, typeChevronView].forEach(typeFilterContainerView.addSubview)
    }

    func setupLayout() {
        [
            scrollView, contentContainer, backButton, titleLabel, descriptionLabel, filterCardView,
            searchContainerView, searchIconView, searchField, dateFilterContainerView, dateFilterIconView,
            dateFilterButton, dateChevronView, typeFilterContainerView, typeFilterIconView, typeFilterButton,
            typeChevronView, sectionTitleLabel, tableView, emptyStateView
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

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 14),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentContainer.trailingAnchor, constant: -24),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 42),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            filterCardView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            filterCardView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            filterCardView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),

            searchContainerView.topAnchor.constraint(equalTo: filterCardView.topAnchor, constant: 20),
            searchContainerView.leadingAnchor.constraint(equalTo: filterCardView.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(equalTo: filterCardView.trailingAnchor, constant: -16),
            searchContainerView.heightAnchor.constraint(equalToConstant: 48),

            searchIconView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 16),
            searchIconView.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchIconView.widthAnchor.constraint(equalToConstant: 18),
            searchIconView.heightAnchor.constraint(equalToConstant: 18),

            searchField.leadingAnchor.constraint(equalTo: searchIconView.trailingAnchor, constant: 12),
            searchField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -16),
            searchField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),

            dateFilterContainerView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 14),
            dateFilterContainerView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor),
            dateFilterContainerView.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor),
            dateFilterContainerView.heightAnchor.constraint(equalToConstant: 48),

            dateFilterIconView.leadingAnchor.constraint(equalTo: dateFilterContainerView.leadingAnchor, constant: 16),
            dateFilterIconView.centerYAnchor.constraint(equalTo: dateFilterContainerView.centerYAnchor),
            dateFilterIconView.widthAnchor.constraint(equalToConstant: 18),
            dateFilterIconView.heightAnchor.constraint(equalToConstant: 18),

            dateChevronView.trailingAnchor.constraint(equalTo: dateFilterContainerView.trailingAnchor, constant: -16),
            dateChevronView.centerYAnchor.constraint(equalTo: dateFilterContainerView.centerYAnchor),
            dateChevronView.widthAnchor.constraint(equalToConstant: 14),
            dateChevronView.heightAnchor.constraint(equalToConstant: 14),

            dateFilterButton.leadingAnchor.constraint(equalTo: dateFilterIconView.trailingAnchor, constant: 12),
            dateFilterButton.trailingAnchor.constraint(equalTo: dateChevronView.leadingAnchor, constant: -10),
            dateFilterButton.centerYAnchor.constraint(equalTo: dateFilterContainerView.centerYAnchor),

            typeFilterContainerView.topAnchor.constraint(equalTo: dateFilterContainerView.bottomAnchor, constant: 14),
            typeFilterContainerView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor),
            typeFilterContainerView.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor),
            typeFilterContainerView.heightAnchor.constraint(equalToConstant: 48),
            typeFilterContainerView.bottomAnchor.constraint(equalTo: filterCardView.bottomAnchor, constant: -20),

            typeFilterIconView.leadingAnchor.constraint(equalTo: typeFilterContainerView.leadingAnchor, constant: 16),
            typeFilterIconView.centerYAnchor.constraint(equalTo: typeFilterContainerView.centerYAnchor),
            typeFilterIconView.widthAnchor.constraint(equalToConstant: 18),
            typeFilterIconView.heightAnchor.constraint(equalToConstant: 18),

            typeChevronView.trailingAnchor.constraint(equalTo: typeFilterContainerView.trailingAnchor, constant: -16),
            typeChevronView.centerYAnchor.constraint(equalTo: typeFilterContainerView.centerYAnchor),
            typeChevronView.widthAnchor.constraint(equalToConstant: 14),
            typeChevronView.heightAnchor.constraint(equalToConstant: 14),

            typeFilterButton.leadingAnchor.constraint(equalTo: typeFilterIconView.trailingAnchor, constant: 12),
            typeFilterButton.trailingAnchor.constraint(equalTo: typeChevronView.leadingAnchor, constant: -10),
            typeFilterButton.centerYAnchor.constraint(equalTo: typeFilterContainerView.centerYAnchor),

            sectionTitleLabel.topAnchor.constraint(equalTo: filterCardView.bottomAnchor, constant: 30),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            emptyStateView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 20),
            emptyStateView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            emptyStateView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
            emptyStateView.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -28),
            
            tableView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 18),
            tableView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -24)
        ])

        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableHeightConstraint?.isActive = true
    }
}
