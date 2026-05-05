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

    private let walletService: WalletService
    private let originalGoal: FinancialGoalRecord
    private var titleText: String
    private var amountText: String
    private var selectedDate: Date
    private var noteText: String
    private var isSubmitting = false

    init(walletService: WalletService, goal: FinancialGoalRecord) {
        self.walletService = walletService
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

    func saveDraft() -> Result<FinancialGoalRecord, EditFinancialGoalValidationError> {
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

    @MainActor
    func submit() async -> (goal: FinancialGoalRecord?, errorMessage: String?) {
        let draftResult = saveDraft()

        switch draftResult {
        case .failure(let error):
            return (nil, error.localizedDescription)
        case .success(let draftGoal):
            isSubmitting = true
            emitState()

            defer {
                isSubmitting = false
                emitState()
            }

            do {
                let response = try await walletService.updateFinancialGoal(
                    goalID: originalGoal.id,
                    request: UpdateFinancialGoalRequest(
                        title: draftGoal.title,
                        targetAmount: draftGoal.targetAmount,
                        targetDate: draftGoal.deadline
                    )
                )

                guard response else {
                    return (nil, "Hedef guncellenemedi. Lutfen tekrar deneyin.")
                }

                let refreshedGoals = try await walletService.fetchFinancialGoals()
                guard let refreshedGoal = refreshedGoals.first(where: { $0.id == originalGoal.id }) else {
                    return (nil, "Guncel hedef bilgisi alinamadi. Lutfen tekrar deneyin.")
                }

                return (
                    FinancialGoalRecord(
                        id: refreshedGoal.id,
                        title: refreshedGoal.title,
                        targetAmount: refreshedGoal.targetAmount,
                        savedAmount: refreshedGoal.currentAmount,
                        deadline: AppDateTextFormatter.parseServerDate(refreshedGoal.targetDate),
                        note: draftGoal.note,
                        iconName: originalGoal.iconName,
                        iconTintColor: originalGoal.iconTintColor,
                        iconBackgroundColor: originalGoal.iconBackgroundColor
                    ),
                    nil
                )
            } catch let error as NetworkError {
                return (nil, error.errorDescription ?? "Hedef guncellenemedi. Lutfen tekrar deneyin.")
            } catch {
                return (nil, error.localizedDescription)
            }
        }
    }

    @MainActor
    func closeGoal() async -> String? {
        isSubmitting = true
        emitState()

        defer {
            isSubmitting = false
            emitState()
        }

        do {
            let response = try await walletService.closeFinancialGoal(goalID: originalGoal.id)
            return response.success ? nil : response.message
        } catch let error as NetworkError {
            return error.errorDescription ?? "Hedef kapatilamadi. Lutfen tekrar deneyin."
        } catch {
            return error.localizedDescription
        }
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
                selectedDateText: AppDateTextFormatter.string(from: selectedDate, style: .financialGoalDayMonth),
                isSaveEnabled: !isSubmitting && !titleText.isEmpty && parsedAmount != nil && parsedAmount! > .zero,
                isSubmitting: isSubmitting
            )
        )
    }
}
