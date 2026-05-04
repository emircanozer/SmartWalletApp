import Foundation
import UIKit

final class FinancialGoalsViewModel {
    var onStateChange: ((FinancialGoalsViewData) -> Void)?

    private var goals: [FinancialGoalRecord] = FinancialGoalsViewModel.makeMockGoals()
}

extension FinancialGoalsViewModel {
    func load() {
        emitState()
    }

    func goalRecord(for id: UUID) -> FinancialGoalRecord? {
        goals.first { $0.id == id }
    }

    func addContribution(to id: UUID, amount: Decimal) {
        guard let index = goals.firstIndex(where: { $0.id == id }) else { return }
        let goal = goals[index]
        goals[index] = FinancialGoalRecord(
            id: goal.id,
            title: goal.title,
            targetAmount: goal.targetAmount,
            savedAmount: goal.savedAmount + amount,
            deadline: goal.deadline,
            note: goal.note,
            iconName: goal.iconName,
            iconTintColor: goal.iconTintColor,
            iconBackgroundColor: goal.iconBackgroundColor
        )
        emitState()
    }

    func updateGoal(_ updatedGoal: FinancialGoalRecord) {
        guard let index = goals.firstIndex(where: { $0.id == updatedGoal.id }) else { return }
        goals[index] = updatedGoal
        emitState()
    }

    func deleteGoal(id: UUID) {
        goals.removeAll { $0.id == id }
        emitState()
    }

    func addGoal(_ draft: FinancialGoalDraft) {
        let icon = suggestedIcon(for: draft.title)
        let newGoal = FinancialGoalRecord(
            id: UUID(),
            title: draft.title,
            targetAmount: draft.targetAmount,
            savedAmount: .zero,
            deadline: draft.deadline,
            note: draft.note,
            iconName: icon.name,
            iconTintColor: icon.tint,
            iconBackgroundColor: icon.background
        )
        goals.append(newGoal)
        emitState()
    }
}

 extension FinancialGoalsViewModel {
    func emitState() {
        onStateChange?(makeViewData())
    }

    func makeViewData() -> FinancialGoalsViewData {
        let totalSaved = goals.reduce(Decimal.zero) { $0 + $1.savedAmount }
        let totalTarget = goals.reduce(Decimal.zero) { $0 + $1.targetAmount }
        let progress = totalTarget > .zero
            ? min(1, CGFloat(NSDecimalNumber(decimal: totalSaved / totalTarget).doubleValue))
            : 0
        let remaining = max(totalTarget - totalSaved, .zero)
        let completionPercent = Int((progress * 100).rounded())

        return FinancialGoalsViewData(
            titleText: "Finansal Hedefler",
            subtitleText: "Toplam birikim ilerlemen",
            totalGoalCountText: "TOPLAM HEDEF: \(goals.count)",
            totalSavedAmountText: AppNumberTextFormatter.prefixedLira(totalSaved, minimumFractionDigits: 0, maximumFractionDigits: 0),
            totalTargetAmountText: AppNumberTextFormatter.prefixedLira(totalTarget, minimumFractionDigits: 0, maximumFractionDigits: 0),
            completionText: "%\(completionPercent) Tamamlandi",
            remainingAmountText: AppNumberTextFormatter.prefixedLira(remaining, minimumFractionDigits: 0, maximumFractionDigits: 0) + " kaldi",
            progress: progress,
            aiSuggestionTitleText: "AI ONERISI",
            aiSuggestionHeadlineText: "Kisa vadeli hedeflerin icin mevcut birikimin yetersiz.",
            aiSuggestionBodyText: "Tatil hedefin icin \(AppNumberTextFormatter.prefixedLira(Decimal(38_000), minimumFractionDigits: 0, maximumFractionDigits: 0)) birikim yapmalisin. Kisa vadeli hedefe odaklanip uzun vadeli hedefi ertelemen onerilir.",
            sectionTitleText: "HEDEFLERIN",
            items: goals.map(mapGoal)
        )
    }

    func mapGoal(_ goal: FinancialGoalRecord) -> FinancialGoalItemViewData {
        let progress = goal.targetAmount > .zero
            ? min(1, CGFloat(NSDecimalNumber(decimal: goal.savedAmount / goal.targetAmount).doubleValue))
            : 0
        return FinancialGoalItemViewData(
            id: goal.id,
            titleText: goal.title,
            deadlineText: "Son tarih: " + Self.goalDateFormatter.string(from: goal.deadline),
            currentAmountText: AppNumberTextFormatter.prefixedLira(goal.savedAmount, minimumFractionDigits: 0, maximumFractionDigits: 0),
            targetAmountText: AppNumberTextFormatter.prefixedLira(goal.targetAmount, minimumFractionDigits: 0, maximumFractionDigits: 0),
            progress: progress,
            iconName: goal.iconName,
            iconTintColor: goal.iconTintColor,
            iconBackgroundColor: goal.iconBackgroundColor
        )
    }

    static func makeMockGoals() -> [FinancialGoalRecord] {
        [
            FinancialGoalRecord(
                id: UUID(),
                title: "iPhone 15 Pro",
                targetAmount: Decimal(120_000),
                savedAmount: Decimal(8_000),
                deadline: Calendar.current.date(from: DateComponents(year: 2026, month: 8, day: 30)) ?? Date(),
                note: "Yil sonuna kadar almayi planliyorum.",
                iconName: "iphone.gen3",
                iconTintColor: AppColor.navigationTint,
                iconBackgroundColor: AppColor.surfaceMuted
            ),
            FinancialGoalRecord(
                id: UUID(),
                title: "Tatil",
                targetAmount: Decimal(50_000),
                savedAmount: Decimal(12_000),
                deadline: Calendar.current.date(from: DateComponents(year: 2026, month: 7, day: 1)) ?? Date(),
                note: "Yaz tatili icin birikim.",
                iconName: "sun.max",
                iconTintColor: AppColor.navigationTint,
                iconBackgroundColor: AppColor.surfaceMuted
            )
        ]
    }

    func suggestedIcon(for title: String) -> (name: String, tint: UIColor, background: UIColor) {
        let normalized = title.lowercased()
        if normalized.contains("telefon") || normalized.contains("iphone") {
            return ("iphone.gen3", AppColor.navigationTint, AppColor.surfaceMuted)
        }
        if normalized.contains("tatil") || normalized.contains("gezi") {
            return ("sun.max", AppColor.navigationTint, AppColor.surfaceMuted)
        }
        if normalized.contains("araba") {
            return ("car", AppColor.navigationTint, AppColor.surfaceMuted)
        }
        return ("target", AppColor.navigationTint, AppColor.surfaceMuted)
    }

    static let goalDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
}
