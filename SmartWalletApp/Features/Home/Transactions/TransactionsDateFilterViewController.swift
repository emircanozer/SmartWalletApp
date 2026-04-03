import UIKit

final class TransactionsDateFilterViewController: UIViewController {
    var onApply: ((Date, Date) -> Void)?

    private enum ActiveField {
        case start
        case end
    }

    private let startDate: Date
    private let endDate: Date

    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let startFieldButton = UIButton(type: .system)
    private let endFieldButton = UIButton(type: .system)
    private let pickerCard = UIView()
    private let pickerTitleLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let applyButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)

    private var currentStartDate: Date
    private var currentEndDate: Date
    private var activeField: ActiveField = .start

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
            sheet.detents = [.custom { _ in 500 }]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.layer.cornerRadius = 24
        applyButton.layer.cornerRadius = 14
        clearButton.layer.cornerRadius = 14
        pickerCard.layer.cornerRadius = 18
        startFieldButton.layer.cornerRadius = 14
        endFieldButton.layer.cornerRadius = 14
    }
}

extension TransactionsDateFilterViewController {
    func configureView() {
        view.backgroundColor = .clear
        contentView.backgroundColor = .white

        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)

        subtitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.44, green: 0.47, blue: 0.55, alpha: 1.0)
        subtitleLabel.numberOfLines = 1

        [startFieldButton, endFieldButton].forEach {
            $0.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
            $0.setTitleColor(UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0), for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            $0.contentHorizontalAlignment = .left
        }

        startFieldButton.addTarget(self, action: #selector(handleStartTap), for: .touchUpInside)
        endFieldButton.addTarget(self, action: #selector(handleEndTap), for: .touchUpInside)

        pickerCard.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)

        pickerTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        pickerTitleLabel.textColor = UIColor(red: 0.44, green: 0.47, blue: 0.55, alpha: 1.0)

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "tr_TR")
        datePicker.maximumDate = Date()
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.setValue(UIColor.black, forKey: "textColor")
        datePicker.addTarget(self, action: #selector(handleDateChanged), for: .valueChanged)

        applyButton.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        applyButton.setTitleColor(UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0), for: .normal)
        applyButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        applyButton.addTarget(self, action: #selector(handleApplyTap), for: .touchUpInside)

        clearButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.0)
        clearButton.setTitleColor(UIColor(red: 0.34, green: 0.36, blue: 0.41, alpha: 1.0), for: .normal)
        clearButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        clearButton.addTarget(self, action: #selector(handleClearTap), for: .touchUpInside)
    }

    func buildHierarchy() {
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(startFieldButton)
        contentView.addSubview(endFieldButton)
        contentView.addSubview(pickerCard)
        pickerCard.addSubview(pickerTitleLabel)
        pickerCard.addSubview(datePicker)
        contentView.addSubview(clearButton)
        contentView.addSubview(applyButton)
    }

    func setupLayout() {
        [
            contentView,
            titleLabel,
            subtitleLabel,
            startFieldButton,
            endFieldButton,
            pickerCard,
            pickerTitleLabel,
            datePicker,
            clearButton,
            applyButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            startFieldButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 14),
            startFieldButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            startFieldButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            startFieldButton.heightAnchor.constraint(equalToConstant: 46),

            endFieldButton.topAnchor.constraint(equalTo: startFieldButton.bottomAnchor, constant: 10),
            endFieldButton.leadingAnchor.constraint(equalTo: startFieldButton.leadingAnchor),
            endFieldButton.trailingAnchor.constraint(equalTo: startFieldButton.trailingAnchor),
            endFieldButton.heightAnchor.constraint(equalToConstant: 46),

            pickerCard.topAnchor.constraint(equalTo: endFieldButton.bottomAnchor, constant: 14),
            pickerCard.leadingAnchor.constraint(equalTo: startFieldButton.leadingAnchor),
            pickerCard.trailingAnchor.constraint(equalTo: startFieldButton.trailingAnchor),

            pickerTitleLabel.topAnchor.constraint(equalTo: pickerCard.topAnchor, constant: 10),
            pickerTitleLabel.leadingAnchor.constraint(equalTo: pickerCard.leadingAnchor, constant: 16),
            pickerTitleLabel.trailingAnchor.constraint(equalTo: pickerCard.trailingAnchor, constant: -16),

            datePicker.topAnchor.constraint(equalTo: pickerTitleLabel.bottomAnchor, constant: 4),
            datePicker.leadingAnchor.constraint(equalTo: pickerCard.leadingAnchor, constant: 6),
            datePicker.trailingAnchor.constraint(equalTo: pickerCard.trailingAnchor, constant: -6),
            datePicker.bottomAnchor.constraint(equalTo: pickerCard.bottomAnchor, constant: -8),

            clearButton.topAnchor.constraint(equalTo: pickerCard.bottomAnchor, constant: 16),
            clearButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 46),
            clearButton.widthAnchor.constraint(equalToConstant: 100),

            applyButton.topAnchor.constraint(equalTo: pickerCard.bottomAnchor, constant: 16),
            applyButton.leadingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: 12),
            applyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            applyButton.heightAnchor.constraint(equalToConstant: 46),
            applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
        ])
    }

    func applyContent() {
        titleLabel.text = "Tarih Filtresi"
        subtitleLabel.text = "Tarih aralığını seçin"
        clearButton.setTitle("Sıfırla", for: .normal)
        applyButton.setTitle("Filtrele", for: .normal)
        syncPicker(with: .start)
        updateFieldTitles()
    }

    @objc func handleApplyTap() {
        guard currentStartDate <= currentEndDate else { return }
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.onApply?(self.currentStartDate, self.currentEndDate)
        }
    }

    @objc func handleClearTap() {
        currentStartDate = startDate
        currentEndDate = endDate
        syncPicker(with: activeField)
        updateFieldTitles()
    }

    @objc func handleStartTap() {
        syncPicker(with: .start)
    }

    @objc func handleEndTap() {
        syncPicker(with: .end)
    }

    @objc func handleDateChanged() {
        switch activeField {
        case .start:
            currentStartDate = datePicker.date
            if currentStartDate > currentEndDate {
                currentEndDate = currentStartDate
            }
        case .end:
            currentEndDate = datePicker.date
            if currentEndDate < currentStartDate {
                currentStartDate = currentEndDate
            }
        }

        updateFieldTitles()
    }

    private func syncPicker(with field: ActiveField) {
        activeField = field
        let selectedDate = field == .start ? currentStartDate : currentEndDate
        datePicker.setDate(selectedDate, animated: false)
        pickerTitleLabel.text = field == .start ? "Başlangıç Tarihi" : "Bitiş Tarihi"
        updateFieldSelection()
    }

    private func updateFieldTitles() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd.MM.yyyy"

        startFieldButton.setTitle("Başlangıç  \(formatter.string(from: currentStartDate))", for: .normal)
        endFieldButton.setTitle("Bitiş  \(formatter.string(from: currentEndDate))", for: .normal)
    }

    private func updateFieldSelection() {
        let selectedColor = UIColor(red: 1.0, green: 0.97, blue: 0.88, alpha: 1.0)
        let normalColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)

        startFieldButton.backgroundColor = activeField == .start ? selectedColor : normalColor
        endFieldButton.backgroundColor = activeField == .end ? selectedColor : normalColor
    }
}
