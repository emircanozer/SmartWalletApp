import UIKit

final class TransactionsDateFilterViewController: UIViewController {
    var onApply: ((Date, Date) -> Void)?

    private let startDate: Date
    private let endDate: Date

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let rangeSummaryView = UIView()
    private let rangeColumnsStackView = UIStackView()
    private let startColumnView = UIStackView()
    private let endColumnView = UIStackView()
    private let startTitleLabel = UILabel()
    private let endTitleLabel = UILabel()
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    private let pickerCardView = UIView()
    private let segmentControl = UISegmentedControl(items: ["Başlangıç", "Bitiş"])
    private let datePicker = UIDatePicker()
    private let buttonStackView = UIStackView()
    private let clearButton = UIButton(type: .system)
    private let applyButton = UIButton(type: .system)

    private var currentStartDate: Date
    private var currentEndDate: Date

    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        self.currentStartDate = startDate
        self.currentEndDate = endDate
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
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

        if let sheet = sheetPresentationController {
            sheet.detents = [.custom { _ in 430 }]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [rangeSummaryView, pickerCardView].forEach { $0.layer.cornerRadius = 20 }
        [clearButton, applyButton].forEach { $0.layer.cornerRadius = $0.bounds.height / 2 }
    }
}

 extension TransactionsDateFilterViewController {
    func configureView() {
        view.backgroundColor = AppColor.appBackground

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = AppColor.primaryText

        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = AppColor.secondaryText

        [rangeSummaryView, pickerCardView].forEach {
            $0.backgroundColor = AppColor.whitePrimary
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.03
            $0.layer.shadowRadius = 10
            $0.layer.shadowOffset = CGSize(width: 0, height: 6)
        }

        [startTitleLabel, endTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 12, weight: .bold)
            $0.textColor = AppColor.tertiaryText
        }

        [startDateLabel, endDateLabel].forEach {
            $0.font = .systemFont(ofSize: 13, weight: .semibold)
            $0.textColor = AppColor.primaryText
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
        }

        [rangeColumnsStackView, startColumnView, endColumnView].forEach {
            $0.axis = .vertical
        }

        rangeColumnsStackView.axis = .horizontal
        rangeColumnsStackView.alignment = .fill
        rangeColumnsStackView.distribution = .fillEqually
        rangeColumnsStackView.spacing = 12

        [startColumnView, endColumnView].forEach {
            $0.spacing = 4
            $0.alignment = .fill
            $0.distribution = .fill
        }

        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = AppColor.primaryYellow
        segmentControl.setTitleTextAttributes([.foregroundColor: AppColor.primaryText], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor: AppColor.secondaryText], for: .normal)
        segmentControl.addTarget(self, action: #selector(handleSegmentChanged), for: .valueChanged)

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "tr_TR")
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(handleDateChanged), for: .valueChanged)

        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually

        clearButton.backgroundColor = AppColor.surfaceMuted
        clearButton.setTitleColor(AppColor.primaryText, for: .normal)
        clearButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        clearButton.addTarget(self, action: #selector(handleClearTap), for: .touchUpInside)

        applyButton.backgroundColor = AppColor.primaryYellow
        applyButton.setTitleColor(AppColor.primaryText, for: .normal)
        applyButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        applyButton.addTarget(self, action: #selector(handleApplyTap), for: .touchUpInside)
    }

    func buildHierarchy() {
        [
            titleLabel,
            subtitleLabel,
            rangeSummaryView,
            pickerCardView,
            buttonStackView
        ].forEach(view.addSubview)

        rangeSummaryView.addSubview(rangeColumnsStackView)
        [startColumnView, endColumnView].forEach(rangeColumnsStackView.addArrangedSubview)
        [startTitleLabel, startDateLabel].forEach(startColumnView.addArrangedSubview)
        [endTitleLabel, endDateLabel].forEach(endColumnView.addArrangedSubview)
        [segmentControl, datePicker].forEach(pickerCardView.addSubview)
        [clearButton, applyButton].forEach(buttonStackView.addArrangedSubview)
    }

    func setupLayout() {
        [
            titleLabel,
            subtitleLabel,
            rangeSummaryView,
            rangeColumnsStackView,
            pickerCardView,
            segmentControl,
            datePicker,
            buttonStackView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            rangeSummaryView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            rangeSummaryView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            rangeSummaryView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            rangeColumnsStackView.topAnchor.constraint(equalTo: rangeSummaryView.topAnchor, constant: 16),
            rangeColumnsStackView.leadingAnchor.constraint(equalTo: rangeSummaryView.leadingAnchor, constant: 16),
            rangeColumnsStackView.trailingAnchor.constraint(equalTo: rangeSummaryView.trailingAnchor, constant: -16),
            rangeColumnsStackView.bottomAnchor.constraint(equalTo: rangeSummaryView.bottomAnchor, constant: -16),

            pickerCardView.topAnchor.constraint(equalTo: rangeSummaryView.bottomAnchor, constant: 14),
            pickerCardView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pickerCardView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            segmentControl.topAnchor.constraint(equalTo: pickerCardView.topAnchor, constant: 14),
            segmentControl.leadingAnchor.constraint(equalTo: pickerCardView.leadingAnchor, constant: 14),
            segmentControl.trailingAnchor.constraint(equalTo: pickerCardView.trailingAnchor, constant: -14),
            segmentControl.heightAnchor.constraint(equalToConstant: 32),

            datePicker.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 2),
            datePicker.leadingAnchor.constraint(equalTo: pickerCardView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: pickerCardView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: pickerCardView.bottomAnchor, constant: -4),
            datePicker.heightAnchor.constraint(equalToConstant: 140),

            buttonStackView.topAnchor.constraint(equalTo: pickerCardView.bottomAnchor, constant: 16),
            buttonStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18)
        ])

        [clearButton, applyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }

    func applyContent() {
        titleLabel.text = "Tarih Filtresi"
        subtitleLabel.text = "İşlemleri tarih aralığına göre filtreleyin."
        startTitleLabel.text = "Başlangıç"
        endTitleLabel.text = "Bitiş"
        clearButton.setTitle("Sıfırla", for: .normal)
        applyButton.setTitle("Uygula", for: .normal)
        datePicker.setDate(currentStartDate, animated: false)
        updateDateLabels()
    }

    func updateDateLabels() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMM yyyy"
        startDateLabel.text = formatter.string(from: currentStartDate)
        endDateLabel.text = formatter.string(from: currentEndDate)
    }

    @objc func handleSegmentChanged() {
        let selectedDate = segmentControl.selectedSegmentIndex == 0 ? currentStartDate : currentEndDate
        datePicker.setDate(selectedDate, animated: true)
    }

    @objc func handleDateChanged() {
        if segmentControl.selectedSegmentIndex == 0 {
            currentStartDate = datePicker.date
        } else {
            currentEndDate = datePicker.date
        }

        if currentStartDate > currentEndDate {
            if segmentControl.selectedSegmentIndex == 0 {
                currentEndDate = currentStartDate
            } else {
                currentStartDate = currentEndDate
            }
        }

        updateDateLabels()
    }

    @objc func handleClearTap() {
        currentStartDate = startDate
        currentEndDate = endDate
        let selectedDate = segmentControl.selectedSegmentIndex == 0 ? currentStartDate : currentEndDate
        datePicker.setDate(selectedDate, animated: true)
        updateDateLabels()
    }

    @objc func handleApplyTap() {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.onApply?(self.currentStartDate, self.currentEndDate)
        }
    }
}
