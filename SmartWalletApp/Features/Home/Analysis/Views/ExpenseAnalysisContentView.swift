import UIKit
import DGCharts

final class ExpenseAnalysisContentView: UIView {
    let backButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentContainer = UIView()
    private let headerTitleLabel = UILabel()
    private let notificationButton = UIButton(type: .system)
    private let summaryGrid = UIStackView()
    private let chartCard = UIView()
    private let pieChartView = PieChartView()
    private let chartCenterTitleLabel = UILabel()
    private let chartCenterValueLabel = UILabel()
    private let categoriesCard = UIView()
    private let categoriesTitleLabel = UILabel()
    private let categoriesActionLabel = UILabel()
    private let categoriesStack = UIStackView()
    private let aiCard = UIView()
    private let aiTitleLabel = UILabel()
    private let aiBodyLabel = UILabel()
    private let emptyStateView = EmptyStateView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private var summaryCards: [SummaryCardView] = []

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
        [notificationButton, chartCard, categoriesCard, aiCard].forEach {
            $0.layer.cornerRadius = 20
        }
    }
}

extension ExpenseAnalysisContentView {
    func apply(_ data: ExpenseAnalysisViewData) {
        headerTitleLabel.text = data.titleText
        chartCenterTitleLabel.text = "Toplam Harcama"
        chartCenterValueLabel.text = data.totalExpenseText
        let isEmpty = data.emptyMessageText != nil

        summaryGrid.isHidden = isEmpty
        chartCard.isHidden = isEmpty
        categoriesCard.isHidden = isEmpty
        aiCard.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
        if let message = data.emptyMessageText {
            emptyStateView.configure(
                title: "Henüz harcama veriniz yok",
                message: message,
                systemImageName: "chart.pie"
            )
        }

        zip(summaryCards, data.summaryItems).forEach { card, item in
            card.configure(with: item)
        }

        categoriesStack.arrangedSubviews.forEach {
            categoriesStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        data.categoryItems.forEach { item in
            let row = ExpenseAnalysisCategoryRowView()
            row.configure(with: item)
            categoriesStack.addArrangedSubview(row)
        }

        aiTitleLabel.text = data.aiInsightTitle
        aiBodyLabel.text = data.aiInsightBody
        applyChart(slices: data.chartSlices)
    }

    func setLoading(_ isLoading: Bool) {
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}

 extension ExpenseAnalysisContentView {
    func configureView() {
        backgroundColor = AppColor.appBackground

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        contentContainer.backgroundColor = AppColor.appBackground

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = AppColor.navigationTint

        headerTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        headerTitleLabel.textColor = AppColor.primaryText

        notificationButton.backgroundColor = AppColor.whitePrimary
        notificationButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationButton.tintColor = AppColor.warmActionText
        notificationButton.layer.borderWidth = 1
        notificationButton.layer.borderColor = AppColor.borderSoft.cgColor

        summaryGrid.axis = .vertical
        summaryGrid.spacing = 12
        summaryGrid.distribution = .fillEqually

        chartCard.backgroundColor = AppColor.whitePrimary
        chartCard.layer.shadowColor = UIColor.black.cgColor
        chartCard.layer.shadowOpacity = 0.05
        chartCard.layer.shadowRadius = 18
        chartCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        pieChartView.legend.enabled = false
        pieChartView.rotationEnabled = false
        pieChartView.holeRadiusPercent = 0.72
        pieChartView.transparentCircleRadiusPercent = 0.75
        pieChartView.holeColor = AppColor.whitePrimary
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.usePercentValuesEnabled = false
        pieChartView.highlightPerTapEnabled = false

        chartCenterTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        chartCenterTitleLabel.textColor = AppColor.secondaryText
        chartCenterTitleLabel.textAlignment = .center

        chartCenterValueLabel.font = .systemFont(ofSize: 34, weight: .bold)
        chartCenterValueLabel.textColor = AppColor.primaryText
        chartCenterValueLabel.textAlignment = .center

        categoriesCard.backgroundColor = AppColor.whitePrimary
        categoriesCard.layer.shadowColor = UIColor.black.cgColor
        categoriesCard.layer.shadowOpacity = 0.05
        categoriesCard.layer.shadowRadius = 18
        categoriesCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        categoriesTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        categoriesTitleLabel.textColor = AppColor.primaryText
        categoriesTitleLabel.text = "Kategoriler"

        categoriesActionLabel.font = .systemFont(ofSize: 14, weight: .bold)
        categoriesActionLabel.textColor = AppColor.accentOlive
        categoriesActionLabel.text = "Tümünü Gör"

        categoriesStack.axis = .vertical
        categoriesStack.spacing = 18

        aiCard.backgroundColor = AppColor.surfaceWarm
        aiCard.layer.borderColor = AppColor.borderWarm.cgColor
        aiCard.layer.borderWidth = 1

        aiTitleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        aiTitleLabel.textColor = AppColor.warmActionText

        aiBodyLabel.font = .systemFont(ofSize: 14, weight: .medium)
        aiBodyLabel.textColor = AppColor.primaryText
        aiBodyLabel.numberOfLines = 0

        emptyStateView.isHidden = true

        loadingIndicator.color = AppColor.primaryText

        configureSummaryCards()
    }

    func configureSummaryCards() {
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.spacing = 12
        topRow.distribution = .fillEqually

        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.spacing = 12
        bottomRow.distribution = .fillEqually

        (0..<2).forEach { _ in topRow.addArrangedSubview(makeSummaryCard()) }
        (0..<2).forEach { _ in bottomRow.addArrangedSubview(makeSummaryCard()) }

        summaryGrid.addArrangedSubview(topRow)
        summaryGrid.addArrangedSubview(bottomRow)
    }

    func makeSummaryCard() -> UIView {
        let card = SummaryCardView()
        summaryCards.append(card)
        return card
    }

    func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        [
            backButton,
            headerTitleLabel,
            notificationButton,
            summaryGrid,
            emptyStateView,
            chartCard,
            categoriesCard,
            aiCard,
            loadingIndicator
        ].forEach(contentContainer.addSubview)

        [pieChartView, chartCenterTitleLabel, chartCenterValueLabel].forEach(chartCard.addSubview)
        [categoriesTitleLabel, categoriesActionLabel, categoriesStack].forEach(categoriesCard.addSubview)
        [aiTitleLabel, aiBodyLabel].forEach(aiCard.addSubview)
    }

    func setupLayout() {
        [
            scrollView,
            contentContainer,
            backButton,
            headerTitleLabel,
            notificationButton,
            summaryGrid,
            emptyStateView,
            chartCard,
            pieChartView,
            chartCenterTitleLabel,
            chartCenterValueLabel,
            categoriesCard,
            categoriesTitleLabel,
            categoriesActionLabel,
            categoriesStack,
            aiCard,
            aiTitleLabel,
            aiBodyLabel,
            loadingIndicator
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

            backButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 28),

            headerTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            headerTitleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 12),

            notificationButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            notificationButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            notificationButton.widthAnchor.constraint(equalToConstant: 34),
            notificationButton.heightAnchor.constraint(equalToConstant: 34),

            summaryGrid.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 22),
            summaryGrid.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            summaryGrid.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),
            summaryGrid.heightAnchor.constraint(equalToConstant: 220),

            emptyStateView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 36),
            emptyStateView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            emptyStateView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),

            chartCard.topAnchor.constraint(equalTo: summaryGrid.bottomAnchor, constant: 18),
            chartCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            chartCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),
            chartCard.heightAnchor.constraint(equalToConstant: 320),

            pieChartView.centerXAnchor.constraint(equalTo: chartCard.centerXAnchor),
            pieChartView.centerYAnchor.constraint(equalTo: chartCard.centerYAnchor),
            pieChartView.widthAnchor.constraint(equalToConstant: 250),
            pieChartView.heightAnchor.constraint(equalToConstant: 250),

            chartCenterTitleLabel.centerXAnchor.constraint(equalTo: pieChartView.centerXAnchor),
            chartCenterTitleLabel.centerYAnchor.constraint(equalTo: pieChartView.centerYAnchor, constant: -10),

            chartCenterValueLabel.centerXAnchor.constraint(equalTo: pieChartView.centerXAnchor),
            chartCenterValueLabel.topAnchor.constraint(equalTo: chartCenterTitleLabel.bottomAnchor, constant: 4),

            categoriesCard.topAnchor.constraint(equalTo: chartCard.bottomAnchor, constant: 18),
            categoriesCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            categoriesCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),

            categoriesTitleLabel.topAnchor.constraint(equalTo: categoriesCard.topAnchor, constant: 18),
            categoriesTitleLabel.leadingAnchor.constraint(equalTo: categoriesCard.leadingAnchor, constant: 18),

            categoriesActionLabel.centerYAnchor.constraint(equalTo: categoriesTitleLabel.centerYAnchor),
            categoriesActionLabel.trailingAnchor.constraint(equalTo: categoriesCard.trailingAnchor, constant: -18),

            categoriesStack.topAnchor.constraint(equalTo: categoriesTitleLabel.bottomAnchor, constant: 18),
            categoriesStack.leadingAnchor.constraint(equalTo: categoriesCard.leadingAnchor, constant: 18),
            categoriesStack.trailingAnchor.constraint(equalTo: categoriesCard.trailingAnchor, constant: -18),
            categoriesStack.bottomAnchor.constraint(equalTo: categoriesCard.bottomAnchor, constant: -18),

            aiCard.topAnchor.constraint(equalTo: categoriesCard.bottomAnchor, constant: 18),
            aiCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 18),
            aiCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -18),
            aiCard.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -24),

            aiTitleLabel.topAnchor.constraint(equalTo: aiCard.topAnchor, constant: 16),
            aiTitleLabel.leadingAnchor.constraint(equalTo: aiCard.leadingAnchor, constant: 18),
            aiTitleLabel.trailingAnchor.constraint(equalTo: aiCard.trailingAnchor, constant: -18),

            aiBodyLabel.topAnchor.constraint(equalTo: aiTitleLabel.bottomAnchor, constant: 10),
            aiBodyLabel.leadingAnchor.constraint(equalTo: aiCard.leadingAnchor, constant: 18),
            aiBodyLabel.trailingAnchor.constraint(equalTo: aiCard.trailingAnchor, constant: -18),
            aiBodyLabel.bottomAnchor.constraint(equalTo: aiCard.bottomAnchor, constant: -16),

            emptyStateView.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -24),

            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func applyChart(slices: [ExpenseAnalysisChartSlice]) {
        let entries = slices.map { PieChartDataEntry(value: $0.value, label: $0.label) }
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = slices.map(\.color)
        dataSet.sliceSpace = 3
        dataSet.drawValuesEnabled = false
        dataSet.selectionShift = 0

        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.animate(yAxisDuration: 1.0, easingOption: .easeOutCubic)
    }
}

private final class SummaryCardView: UIView {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

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
        layer.cornerRadius = 18
    }

    func configure(with item: ExpenseAnalysisSummaryItem) {
        iconView.image = UIImage(systemName: item.iconName)
        titleLabel.text = item.title.uppercased()
        valueLabel.text = item.value
    }

    private func configureView() {
        backgroundColor = AppColor.whitePrimary
        layer.borderWidth = 1
        layer.borderColor = AppColor.borderSoft.cgColor

        iconView.tintColor = AppColor.secondaryText
        iconView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 11, weight: .bold)
        titleLabel.textColor = AppColor.secondaryText
        titleLabel.numberOfLines = 2

        valueLabel.font = .systemFont(ofSize: 22, weight: .bold)
        valueLabel.textColor = AppColor.primaryText
        valueLabel.numberOfLines = 2
    }

    private func buildHierarchy() {
        [iconView, titleLabel, valueLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
}
