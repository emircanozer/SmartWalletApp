import Foundation

enum EditFinancialGoalValidationError: LocalizedError {
    case emptyTitle
    case invalidAmount

    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Lutfen hedef adini girin."
        case .invalidAmount:
            return "Lutfen gecerli bir hedef tutari girin."
        }
    }
}

final class EditFinancialGoalViewModel {
    var onStateChange: ((EditFinancialGoalFormState) -> Void)?

    private let originalGoal: FinancialGoalRecord
    private var titleText: String
    private var amountText: String
    private var selectedDate: Date
    private var noteText: String

    init(goal: FinancialGoalRecord) {
        self.originalGoal = goal
        self.titleText = goal.title
        self.amountText = AppNumberTextFormatter.prefixedLira(goal.targetAmount, minimumFractionDigits: 0, maximumFractionDigits: 0)
        self.selectedDate = goal.deadline
        self.noteText = goal.note ?? ""
    }
}

extension EditFinancialGoalViewModel {
    var saveGoalID: UUID { originalGoal.id }
    var initialTitleText: String { titleText }
    var initialAmountText: String { amountText }
    var initialNoteText: String { noteText }
    var initialDate: Date { selectedDate }

    func makeViewData() -> EditFinancialGoalViewData {
        EditFinancialGoalViewData(
            titleText: "Hedefi Duzenle",
            nameTitleText: "Hedef Adi",
            amountTitleText: "Hedef Tutari",
            dateTitleText: "Hedef Tarihi",
            noteTitleText: "Aciklama",
            notePlaceholderText: "Istege bagli aciklama",
            saveButtonTitleText: "Kaydet",
            cancelButtonTitleText: "Iptal",
            deleteButtonTitleText: "Hedefi Sil",
            deleteDescriptionText: "Bu islem geri alinamaz."
        )
    }

    func load() {
        emitState()
    }

    func updateTitle(_ value: String) {
        titleText = value.trimmingCharacters(in: .whitespacesAndNewlines)
        emitState()
    }

    func updateAmount(_ value: String) {
        amountText = value
        emitState()
    }

    func updateDate(_ value: Date) {
        selectedDate = value
        emitState()
    }

    func updateNote(_ value: String) {
        noteText = value
    }

    func save() -> Result<FinancialGoalRecord, EditFinancialGoalValidationError> {
        guard !titleText.isEmpty else {
            return .failure(.emptyTitle)
        }

        guard let parsedAmount, parsedAmount > .zero else {
            return .failure(.invalidAmount)
        }

        return .success(
            FinancialGoalRecord(
                id: originalGoal.id,
                title: titleText,
                targetAmount: parsedAmount,
                savedAmount: originalGoal.savedAmount,
                deadline: selectedDate,
                note: noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : noteText.trimmingCharacters(in: .whitespacesAndNewlines),
                iconName: originalGoal.iconName,
                iconTintColor: originalGoal.iconTintColor,
                iconBackgroundColor: originalGoal.iconBackgroundColor
            )
        )
    }

    private var parsedAmount: Decimal? {
        let normalized = amountText
            .replacingOccurrences(of: "₺", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Decimal(string: normalized)
    }

    private func emitState() {
        onStateChange?(
            EditFinancialGoalFormState(
                selectedDateText: Self.dateFormatter.string(from: selectedDate),
                isSaveEnabled: !titleText.isEmpty && parsedAmount != nil && parsedAmount! > .zero
            )
        )
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
}
