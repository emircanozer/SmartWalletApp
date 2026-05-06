import Foundation
import UIKit

@MainActor
final class FinancialGoalAddMoneyViewModel: BaseViewModel {
    var onStateChange: ((FinancialGoalAddMoneyFormState) -> Void)?

    private let walletService: WalletService
    private let goal: FinancialGoalRecord
    private let quickAmounts: [Decimal] = [500, 1_000, 5_000, 10_000]
    private var amountText = ""
    private var noteText = ""
    private var selectedQuickAmount: Decimal?
    private var isSubmitting = false

    init(walletService: WalletService, goal: FinancialGoalRecord) {
        self.walletService = walletService
        self.goal = goal
    }
}

extension FinancialGoalAddMoneyViewModel {
    func makeViewData() -> FinancialGoalAddMoneyViewData {
        let progress = goal.targetAmount > .zero
            ? min(1, CGFloat(NSDecimalNumber(decimal: goal.savedAmount / goal.targetAmount).doubleValue))
            : 0
        let completionPercent = Int((progress * 100).rounded())
        let remainingAmount = max(goal.targetAmount - goal.savedAmount, .zero)

        return FinancialGoalAddMoneyViewData(
            navigationTitleText: "Hedefe Para Ekle",
            goalTitleText: goal.title,
            deadlineText: "Hedef Tarihi: \(AppDateTextFormatter.string(from: goal.deadline, style: .financialGoalDayMonth))",
            badgeText: "%\(completionPercent)",
            savedTitleText: "BIRIKEN",
            savedAmountText: AppNumberTextFormatter.prefixedLira(goal.savedAmount, minimumFractionDigits: 0, maximumFractionDigits: 0),
            targetAmountText: "/ \(AppNumberTextFormatter.prefixedLira(goal.targetAmount, minimumFractionDigits: 0, maximumFractionDigits: 0))",
            remainingTitleText: "KALAN",
            remainingAmountText: "\(AppNumberTextFormatter.prefixedLira(remainingAmount, minimumFractionDigits: 0, maximumFractionDigits: 0)) kaldi",
            progressText: "%\(completionPercent) tamamlandi",
            progress: progress,
            amountFieldTitleText: "Eklenecek Tutar",
            amountPlaceholderText: "₺5000",
            quickAmounts: quickAmounts.map {
                FinancialGoalAddMoneyQuickAmountViewData(
                    amount: $0,
                    titleText: AppNumberTextFormatter.prefixedLira($0, minimumFractionDigits: 0, maximumFractionDigits: 0)
                )
            },
            noteTitleText: "Not (Opsiyonel)",
            notePlaceholderText: "Orn: Bu ay maastan ayirdim",
            infoText: "Eklenen tutar hedef birikimine aninda yansitilir."
        )
    }

    func load() {
        emitState()
    }

    func selectQuickAmount(_ amount: Decimal) {
        selectedQuickAmount = amount
        amountText = AppNumberTextFormatter.prefixedLira(amount, minimumFractionDigits: 0, maximumFractionDigits: 0)
        emitState()
    }

    func updateAmount(_ value: String) {
        amountText = value
        selectedQuickAmount = nil
        emitState()
    }

    func updateNote(_ value: String) {
        noteText = value
    }

    func confirmAmount() -> Decimal? {
        guard let parsedAmount, parsedAmount > .zero else { return nil }
        return parsedAmount
    }

    func submit() async -> (context: FinancialGoalAddMoneySuccessContext?, errorMessage: String?) {
        guard let amount = confirmAmount() else {
            return (nil, "Lutfen gecerli bir tutar girin.")
        }

        do {
            let response = try await performSubmission(
                setSubmitting: { [weak self] in self?.isSubmitting = $0 },
                emitState: { [weak self] in self?.emitState() }
            ) {
                try await self.walletService.addFinancialGoalFunds(
                    goalID: self.goal.id,
                    request: AddFinancialGoalFundsRequest(
                        amount: amount
                    )
                )
            }

            guard response.success else {
                return (nil, response.message)
            }

            let refreshedGoals = try await walletService.fetchFinancialGoals()
            guard let refreshedGoal = refreshedGoals.first(where: { $0.id == goal.id }) else {
                return (nil, "Guncel hedef bilgisi alinamadi. Lutfen tekrar deneyin.")
            }

            let updatedGoal = FinancialGoalRecord(
                id: refreshedGoal.id,
                title: refreshedGoal.title,
                targetAmount: refreshedGoal.targetAmount,
                savedAmount: refreshedGoal.currentAmount,
                deadline: AppDateTextFormatter.parseServerDate(refreshedGoal.targetDate),
                note: goal.note,
                iconName: goal.iconName,
                iconTintColor: goal.iconTintColor,
                iconBackgroundColor: goal.iconBackgroundColor
            )

            return (
                FinancialGoalAddMoneySuccessContext(
                    originalGoal: goal,
                    updatedGoal: updatedGoal,
                    addedAmount: amount,
                    message: response.message
                ),
                nil
            )
        } catch let error as NetworkError {
            return (nil, error.errorDescription ?? "Hedefe para eklenemedi. Lutfen tekrar deneyin.")
        } catch {
            return (nil, error.localizedDescription)
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
        let amount = parsedAmount ?? .zero
        let projectedSavings = goal.savedAmount + amount
        let remainingAfterAdd = max(goal.targetAmount - projectedSavings, .zero)

        emit(
            FinancialGoalAddMoneyFormState(
                amountText: amountText,
                selectedQuickAmount: selectedQuickAmount,
                projectedSavingsText: "Bu islem sonrasi birikim: \(AppNumberTextFormatter.prefixedLira(projectedSavings, minimumFractionDigits: 0, maximumFractionDigits: 0))",
                remainingAfterAddText: "Onayladiktan sonra hedefe kalan: \(AppNumberTextFormatter.prefixedLira(remainingAfterAdd, minimumFractionDigits: 0, maximumFractionDigits: 0))",
                confirmButtonTitleText: "Onayla ve \(AppNumberTextFormatter.prefixedLira(amount, minimumFractionDigits: 0, maximumFractionDigits: 0)) Ekle",
                isConfirmEnabled: !isSubmitting && amount > .zero,
                isSubmitting: isSubmitting
            ),
            using: onStateChange
        )
    }
}
